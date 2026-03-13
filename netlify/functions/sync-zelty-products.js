/**
 * Netlify Scheduled Function: Auto-detect new Zelty products
 * Runs every day at 06:00 UTC (07:00 Paris winter / 08:00 Paris summer)
 *
 * - Fetches all dishes from Zelty API
 * - Compares against existing recettes with zelty_product_id
 * - Creates new recettes for unmatched Zelty dishes
 * - Sends email notification via Gmail if new products found
 *
 * Also callable manually via POST (from Paramètres > Zelty)
 *
 * Schedule configured in netlify.toml
 */

const { sendEmail } = require('./lib/gmail');

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 500;

exports.handler = async function (event) {
  const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
    console.error('Missing env vars');
    return { statusCode: 500, body: JSON.stringify({ error: 'Missing configuration' }) };
  }

  const supaHeaders = {
    'apikey': SUPABASE_KEY,
    'Authorization': `Bearer ${SUPABASE_KEY}`,
    'Content-Type': 'application/json',
  };

  const startTime = Date.now();
  let logId = null;

  try {
    // 1. Log job start
    const logResp = await fetch(
      `${SUPABASE_URL}/rest/v1/cron_logs`,
      {
        method: 'POST',
        headers: { ...supaHeaders, 'Prefer': 'return=representation' },
        body: JSON.stringify({ job_name: 'sync-zelty-products', status: 'running' }),
      }
    );
    if (logResp.ok) {
      const logs = await logResp.json();
      logId = logs[0]?.id;
    }

    // 2. Fetch all Zelty dishes (paginated)
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

    // 3. Fetch all existing zelty_product_id from recettes
    const recettesResp = await fetch(
      `${SUPABASE_URL}/rest/v1/recettes?select=zelty_product_id&zelty_product_id=not.is.null`,
      { headers: supaHeaders },
    );
    if (!recettesResp.ok) {
      throw new Error(`Supabase fetch error: ${recettesResp.status}`);
    }
    const recettes = await recettesResp.json();
    const existingZeltyIds = new Set(recettes.map(r => String(r.zelty_product_id)));

    // 4. Find NEW dishes
    const newDishes = allDishes.filter(d => !existingZeltyIds.has(String(d.id)));

    // 5. Create new recipes
    const created = [];
    for (const dish of newDishes) {
      const recetteData = {
        nom: dish.name,
        type: 'recette',
        zelty_product_id: String(dish.id),
        actif: true,
        nb_portions: 1,
        photo_url: dish.image || dish.thumb || null,
      };

      const insertResp = await fetch(
        `${SUPABASE_URL}/rest/v1/recettes`,
        {
          method: 'POST',
          headers: { ...supaHeaders, 'Prefer': 'return=representation' },
          body: JSON.stringify(recetteData),
        }
      );

      if (insertResp.ok) {
        const rows = await insertResp.json();
        created.push({ id: rows[0]?.id, nom: dish.name, zelty_id: String(dish.id) });
      } else {
        const errText = await insertResp.text();
        console.error(`Failed to create recipe for "${dish.name}": ${errText}`);
      }
    }

    // 6. Send email notification if new dishes were created
    if (created.length > 0) {
      const configResp = await fetch(
        `${SUPABASE_URL}/rest/v1/config?select=destinataires_email_alertes&limit=1`,
        { headers: { ...supaHeaders, 'Accept': 'application/vnd.pgrst.object+json' } },
      );
      const config = configResp.ok ? await configResp.json() : {};
      const recipients = config.destinataires_email_alertes || [];

      if (recipients.length > 0) {
        const rows = created.map(c =>
          `<tr>` +
          `<td style="padding:8px 12px;border-bottom:1px solid #eee;">${c.nom}</td>` +
          `<td style="padding:8px 12px;border-bottom:1px solid #eee;">` +
          `<a href="https://app.phood.fr/recettes/${c.id}" style="color:#E85D2C;text-decoration:none;font-weight:600;">Compléter</a>` +
          `</td>` +
          `</tr>`
        ).join('');

        await sendEmail({
          to: recipients,
          subject: `[Phood] ${created.length} nouveau(x) produit(s) Zelty détecté(s)`,
          html: `
            <div style="font-family:sans-serif;max-width:600px;margin:0 auto;">
              <h2 style="color:#E85D2C;">Nouveaux produits Zelty</h2>
              <p>${created.length} nouveau(x) produit(s) ont été détectés dans la caisse Zelty et automatiquement créés comme recettes dans PhoodApp.</p>
              <p style="color:#666;font-size:14px;">Pensez à ajouter les ingrédients et les prix de vente pour chaque recette.</p>
              <table style="width:100%;border-collapse:collapse;margin:16px 0;">
                <thead><tr style="background:#f9f9f9;">
                  <th style="padding:8px 12px;text-align:left;">Produit</th>
                  <th style="padding:8px 12px;text-align:left;">Action</th>
                </tr></thead>
                <tbody>${rows}</tbody>
              </table>
              <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
              <p style="color:#888;font-size:13px;">
                <a href="https://app.phood.fr/recettes" style="color:#E85D2C;">Voir toutes les recettes</a>
              </p>
            </div>
          `,
        });
      }
    }

    // 7. Log job success
    const durationMs = Date.now() - startTime;
    if (logId) {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`,
        {
          method: 'PATCH',
          headers: supaHeaders,
          body: JSON.stringify({
            status: 'success',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
          }),
        }
      );
    }

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        zelty_dishes_total: allDishes.length,
        existing_recipes: existingZeltyIds.size,
        new_created: created.length,
        created: created.map(c => c.nom),
      }),
    };
  } catch (err) {
    console.error('sync-zelty-products error:', err);

    const durationMs = Date.now() - startTime;
    if (logId) {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs?id=eq.${logId}`,
        {
          method: 'PATCH',
          headers: supaHeaders,
          body: JSON.stringify({
            status: 'error',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
            error_message: err.message,
          }),
        }
      );
    } else {
      await fetch(
        `${SUPABASE_URL}/rest/v1/cron_logs`,
        {
          method: 'POST',
          headers: supaHeaders,
          body: JSON.stringify({
            job_name: 'sync-zelty-products',
            status: 'error',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
            error_message: err.message,
          }),
        }
      ).catch(() => {});
    }

    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
