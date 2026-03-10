/**
 * Netlify Function: Sync Zelty dish photos to recettes
 *
 * POST /.netlify/functions/sync-zelty-photos
 * Body: { dry_run?: boolean, force_overwrite?: boolean }
 *
 * Fetches all dishes from Zelty API (GET /catalog/dishes),
 * matches them to recettes via zelty_product_id,
 * and updates photo_url for recettes that don't have one.
 *
 * Zelty Dish schema (confirmed from API docs):
 *   - id: integer
 *   - name: string
 *   - image: string (URL of original image)
 *   - thumb: string (URL of thumbnail)
 *   - sku: string
 *   - price: integer (cents, TTC)
 *
 * Returns { synced, skipped, unmatched, products_with_photos, errors }
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 500; // Zelty default max is 2500, we use 500 for safety

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!ZELTY_API_KEY) {
    return { statusCode: 500, body: JSON.stringify({ error: 'ZELTY_API_KEY non configurée' }) };
  }
  if (!SUPABASE_URL || !SUPABASE_KEY) {
    return { statusCode: 500, body: JSON.stringify({ error: 'Configuration Supabase manquante' }) };
  }

  try {
    const body = JSON.parse(event.body || '{}');
    const dryRun = body.dry_run === true;
    const forceOverwrite = body.force_overwrite === true;

    const results = {
      zelty_products_total: 0,
      zelty_products_with_photos: 0,
      recettes_matched: 0,
      synced: 0,
      skipped_already_has_photo: 0,
      skipped_no_zelty_photo: 0,
      unmatched: 0,
      errors: 0,
      dry_run: dryRun,
      details: [],
    };

    // 1. Fetch all dishes from Zelty (GET /catalog/dishes with limit/offset)
    let allDishes = [];
    let offset = 0;
    let hasMore = true;

    while (hasMore) {
      const url = `${ZELTY_BASE_URL}/catalog/dishes?limit=${PAGE_SIZE}&offset=${offset}&show_all=true`;
      const resp = await fetch(url, {
        headers: {
          'Authorization': `Bearer ${ZELTY_API_KEY}`,
          'Accept': 'application/json',
        },
      });

      if (!resp.ok) {
        const errText = await resp.text();
        throw new Error(`Zelty API error ${resp.status}: ${errText}`);
      }

      const data = await resp.json();
      const dishes = data.dishes || [];
      allDishes.push(...dishes);

      if (dishes.length < PAGE_SIZE) {
        hasMore = false;
      } else {
        offset += PAGE_SIZE;
      }
    }

    results.zelty_products_total = allDishes.length;

    // 2. Extract dishes that have photos
    // Zelty confirmed fields: image (string URL), thumb (string URL)
    // Index by both dish.id and dish.sku since zelty_product_id in DB may be either
    const zeltyPhotos = new Map();
    for (const dish of allDishes) {
      // Prefer full image, fallback to thumb
      const photoUrl = dish.image || dish.thumb || null;

      if (photoUrl && typeof photoUrl === 'string' && photoUrl.startsWith('http')) {
        const entry = {
          url: photoUrl,
          thumb: dish.thumb || photoUrl,
          name: dish.name || '',
        };
        // Index by numeric ID
        zeltyPhotos.set(String(dish.id), entry);
        // Also index by SKU (used by inpulse migration)
        if (dish.sku) {
          zeltyPhotos.set(String(dish.sku), entry);
        }
        results.zelty_products_with_photos++;
      }
    }

    // 3. Fetch recettes with zelty_product_id from Supabase
    const recettesResp = await fetch(
      `${SUPABASE_URL}/rest/v1/recettes?zelty_product_id=not.is.null&select=id,nom,zelty_product_id,photo_url`,
      {
        headers: {
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'Accept': 'application/json',
        },
      }
    );

    if (!recettesResp.ok) {
      throw new Error(`Supabase fetch error: ${recettesResp.status}`);
    }

    const recettes = await recettesResp.json();

    // 4. Match and sync
    for (const recette of recettes) {
      const zeltyId = String(recette.zelty_product_id);
      const zeltyPhoto = zeltyPhotos.get(zeltyId);

      results.recettes_matched++;

      if (!zeltyPhoto) {
        results.skipped_no_zelty_photo++;
        continue;
      }

      // Skip if recette already has a photo (unless forceOverwrite)
      if (recette.photo_url && !forceOverwrite) {
        results.skipped_already_has_photo++;
        results.details.push({
          recette: recette.nom,
          zelty_id: zeltyId,
          status: 'skipped_has_photo',
        });
        continue;
      }

      if (!dryRun) {
        // Update recette photo_url
        const updateResp = await fetch(
          `${SUPABASE_URL}/rest/v1/recettes?id=eq.${recette.id}`,
          {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              'apikey': SUPABASE_KEY,
              'Authorization': `Bearer ${SUPABASE_KEY}`,
              'Prefer': 'return=minimal',
            },
            body: JSON.stringify({ photo_url: zeltyPhoto.url }),
          }
        );

        if (updateResp.ok) {
          results.synced++;
          results.details.push({
            recette: recette.nom,
            zelty_id: zeltyId,
            zelty_name: zeltyPhoto.name,
            photo_url: zeltyPhoto.url,
            status: 'synced',
          });
        } else {
          results.errors++;
          results.details.push({
            recette: recette.nom,
            zelty_id: zeltyId,
            status: 'error',
            error: await updateResp.text(),
          });
        }
      } else {
        results.synced++;
        results.details.push({
          recette: recette.nom,
          zelty_id: zeltyId,
          zelty_name: zeltyPhoto.name,
          photo_url: zeltyPhoto.url,
          status: 'would_sync',
        });
      }
    }

    results.unmatched = results.zelty_products_total - results.recettes_matched;

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(results),
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: err.message || 'Erreur interne' }),
    };
  }
};
