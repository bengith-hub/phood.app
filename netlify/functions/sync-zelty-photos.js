/**
 * Netlify Function: Sync Zelty dish photos to recettes
 *
 * POST /.netlify/functions/sync-zelty-photos
 * Body: { dry_run?: boolean, force_overwrite?: boolean }
 *
 * Fetches all dishes from Zelty API (GET /catalog/dishes),
 * matches them to recettes via zelty_product_id (ID or SKU)
 * with fallback to normalized name matching,
 * and updates photo_url for recettes that don't have one.
 *
 * Returns { synced, skipped, unmatched, products_with_photos, errors, details }
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 500;

/**
 * Normalize a product name for fuzzy matching:
 * lowercase, remove accents, trim, collapse whitespace
 */
function normalizeName(name) {
  if (!name) return '';
  return name
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '') // strip accents
    .replace(/[^a-z0-9\s]/g, '')     // keep only alphanumeric + spaces
    .replace(/\s+/g, ' ')
    .trim();
}

/**
 * Simple Levenshtein distance for fuzzy name suggestions
 */
function levenshtein(a, b) {
  const m = a.length, n = b.length;
  const dp = Array.from({ length: m + 1 }, () => new Array(n + 1).fill(0));
  for (let i = 0; i <= m; i++) dp[i][0] = i;
  for (let j = 0; j <= n; j++) dp[0][j] = j;
  for (let i = 1; i <= m; i++) {
    for (let j = 1; j <= n; j++) {
      dp[i][j] = a[i - 1] === b[j - 1]
        ? dp[i - 1][j - 1]
        : 1 + Math.min(dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]);
    }
  }
  return dp[m][n];
}

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
    const diagnostic = body.diagnostic === true;

    const results = {
      zelty_products_total: 0,
      zelty_products_with_photos: 0,
      recettes_matched: 0,
      matched_by_id: 0,
      matched_by_name: 0,
      synced: 0,
      skipped_already_has_photo: 0,
      skipped_no_zelty_photo: 0,
      unmatched: 0,
      errors: 0,
      dry_run: dryRun,
      details: [],
    };

    // 1. Fetch all dishes from Zelty (paginated)
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

    // 2. Build lookup maps for Zelty dishes with photos
    // Map by: dish.id (string), dish.sku (string), and normalized name
    const zeltyById = new Map();      // String(dish.id) → entry
    const zeltyBySku = new Map();     // String(dish.sku) → entry
    const zeltyByName = new Map();    // normalizeName(dish.name) → entry

    for (const dish of allDishes) {
      const photoUrl = dish.image || dish.thumb || null;

      if (photoUrl && typeof photoUrl === 'string' && photoUrl.startsWith('http')) {
        const entry = {
          url: photoUrl,
          thumb: dish.thumb || photoUrl,
          name: dish.name || '',
          zeltyId: String(dish.id),
        };

        zeltyById.set(String(dish.id), entry);

        if (dish.sku) {
          zeltyBySku.set(String(dish.sku), entry);
        }

        const normalized = normalizeName(dish.name);
        if (normalized) {
          zeltyByName.set(normalized, entry);
        }

        results.zelty_products_with_photos++;
      }
    }

    // 3. Fetch all recettes from Supabase (with or without zelty_product_id)
    const recettesResp = await fetch(
      `${SUPABASE_URL}/rest/v1/recettes?select=id,nom,zelty_product_id,photo_url&actif=eq.true`,
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
      const zeltyId = recette.zelty_product_id ? String(recette.zelty_product_id) : null;
      let zeltyPhoto = null;
      let matchMethod = null;

      // Try matching by zelty_product_id first (could be ID or SKU)
      if (zeltyId) {
        zeltyPhoto = zeltyById.get(zeltyId) || zeltyBySku.get(zeltyId);
        if (zeltyPhoto) matchMethod = 'id_or_sku';
      }

      // Fallback: match by normalized name
      if (!zeltyPhoto && recette.nom) {
        const normalizedRecette = normalizeName(recette.nom);
        zeltyPhoto = zeltyByName.get(normalizedRecette);
        if (zeltyPhoto) matchMethod = 'name';
      }

      if (!zeltyPhoto) {
        results.skipped_no_zelty_photo++;
        // In diagnostic mode, find closest Zelty name suggestions
        if (diagnostic && recette.nom) {
          const normalizedRecette = normalizeName(recette.nom);
          const allZeltyNames = [...zeltyByName.entries()];
          const suggestions = allZeltyNames
            .map(([zName, entry]) => ({
              zelty_name: entry.name,
              distance: levenshtein(normalizedRecette, zName),
              has_photo: true,
            }))
            .sort((a, b) => a.distance - b.distance)
            .slice(0, 3);
          results.details.push({
            recette: recette.nom,
            zelty_product_id: recette.zelty_product_id || null,
            status: 'unmatched',
            suggestions,
          });
        }
        continue;
      }

      results.recettes_matched++;
      if (matchMethod === 'id_or_sku') results.matched_by_id++;
      if (matchMethod === 'name') results.matched_by_name++;

      // Skip if recette already has a photo (unless forceOverwrite)
      if (recette.photo_url && !forceOverwrite) {
        results.skipped_already_has_photo++;
        results.details.push({
          recette: recette.nom,
          zelty_name: zeltyPhoto.name,
          match: matchMethod,
          status: 'skipped_has_photo',
        });
        continue;
      }

      if (!dryRun) {
        // Update recette photo_url (and zelty_product_id if matched by name and not set)
        const updateData = { photo_url: zeltyPhoto.url };
        if (matchMethod === 'name' && !recette.zelty_product_id) {
          updateData.zelty_product_id = zeltyPhoto.zeltyId;
        }

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
            body: JSON.stringify(updateData),
          }
        );

        if (updateResp.ok) {
          results.synced++;
          results.details.push({
            recette: recette.nom,
            zelty_name: zeltyPhoto.name,
            match: matchMethod,
            photo_url: zeltyPhoto.url,
            status: 'synced',
          });
        } else {
          results.errors++;
          results.details.push({
            recette: recette.nom,
            match: matchMethod,
            status: 'error',
            error: await updateResp.text(),
          });
        }
      } else {
        results.synced++;
        results.details.push({
          recette: recette.nom,
          zelty_name: zeltyPhoto.name,
          match: matchMethod,
          photo_url: zeltyPhoto.url,
          status: 'would_sync',
        });
      }
    }

    results.unmatched = recettes.length - results.recettes_matched - results.skipped_no_zelty_photo;

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
