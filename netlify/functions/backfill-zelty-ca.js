/**
 * Netlify Function: Backfill historical Zelty closures into ventes_historique
 *
 * POST /.netlify/functions/backfill-zelty-ca
 * Body: { date_from?: "YYYY-MM-DD", date_to?: "YYYY-MM-DD" }
 *
 * Fetches closures from Zelty API for the given date range (default: 18 months)
 * and upserts into ventes_historique table in Supabase.
 *
 * Uses paginated endpoint first, falls back to day-by-day if needed.
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';

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

    // Default: 18 months ago to yesterday
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const dateTo = body.date_to || yesterday.toISOString().slice(0, 10);

    let dateFrom = body.date_from;
    if (!dateFrom) {
      const d = new Date(dateTo);
      d.setMonth(d.getMonth() - 18);
      dateFrom = d.toISOString().slice(0, 10);
    }

    const results = { imported: 0, skipped: 0, errors: 0, date_from: dateFrom, date_to: dateTo };

    // Strategy 1: Try paginated endpoint with date range
    let useFallback = false;
    try {
      let page = 1;
      let hasMore = true;

      while (hasMore) {
        const url = `${ZELTY_BASE_URL}/closures?date_from=${dateFrom}&date_to=${dateTo}&page=${page}&size=100`;
        const resp = await fetch(url, {
          headers: {
            'Authorization': `Bearer ${ZELTY_API_KEY}`,
            'Accept': 'application/json',
          },
        });

        if (!resp.ok) {
          if (resp.status === 400 || resp.status === 404) {
            // Endpoint doesn't support date range — use fallback
            useFallback = true;
            break;
          }
          throw new Error(`Zelty API error: ${resp.status}`);
        }

        const data = await resp.json();
        const closures = data.closures || [];

        if (closures.length === 0) {
          hasMore = false;
          break;
        }

        // Bulk upsert to Supabase via REST API
        const rows = closures
          .filter(c => c.date)
          .map(c => ({
            date: c.date,
            ca_ttc: c.total_ttc || 0,
            nb_tickets: c.nb_tickets || 0,
            nb_couverts: c.nb_covers ?? null,
            cloture_validee: c.validated ?? true,
            zelty_closure_id: c.id || null,
          }));

        if (rows.length > 0) {
          const upsertResp = await fetch(
            `${SUPABASE_URL}/rest/v1/ventes_historique`,
            {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`,
                'Prefer': 'resolution=merge-duplicates',
              },
              body: JSON.stringify(rows),
            }
          );

          if (!upsertResp.ok) {
            const errText = await upsertResp.text();
            throw new Error(`Supabase upsert error: ${upsertResp.status} — ${errText}`);
          }

          results.imported += rows.length;
        }

        page++;
        if (closures.length < 100) hasMore = false;
      }
    } catch (batchErr) {
      if (!useFallback) {
        console.error('Batch approach failed:', batchErr.message);
        useFallback = true;
      }
    }

    // Strategy 2: Day-by-day fallback
    if (useFallback) {
      results.imported = 0; // Reset
      const start = new Date(dateFrom);
      const end = new Date(dateTo);
      const batchRows = [];

      for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
        const dateStr = d.toISOString().slice(0, 10);

        try {
          const resp = await fetch(`${ZELTY_BASE_URL}/closures?date=${dateStr}`, {
            headers: {
              'Authorization': `Bearer ${ZELTY_API_KEY}`,
              'Accept': 'application/json',
            },
          });

          if (!resp.ok) {
            if (resp.status === 404) {
              results.skipped++;
              continue;
            }
            results.errors++;
            continue;
          }

          const data = await resp.json();
          const closures = data.closures || [];

          for (const c of closures) {
            if (!c.date) continue;
            batchRows.push({
              date: c.date,
              ca_ttc: c.total_ttc || 0,
              nb_tickets: c.nb_tickets || 0,
              nb_couverts: c.nb_covers ?? null,
              cloture_validee: c.validated ?? true,
              zelty_closure_id: c.id || null,
            });
          }

          if (closures.length === 0) {
            results.skipped++;
          }

          // Small delay to avoid rate limiting
          await new Promise(r => setTimeout(r, 50));
        } catch {
          results.errors++;
        }
      }

      // Bulk upsert all collected rows
      if (batchRows.length > 0) {
        // Upsert in batches of 100
        for (let i = 0; i < batchRows.length; i += 100) {
          const batch = batchRows.slice(i, i + 100);
          const upsertResp = await fetch(
            `${SUPABASE_URL}/rest/v1/ventes_historique`,
            {
              method: 'POST',
              headers: {
                'Content-Type': 'application/json',
                'apikey': SUPABASE_KEY,
                'Authorization': `Bearer ${SUPABASE_KEY}`,
                'Prefer': 'resolution=merge-duplicates',
              },
              body: JSON.stringify(batch),
            }
          );

          if (upsertResp.ok) {
            results.imported += batch.length;
          } else {
            results.errors += batch.length;
          }
        }
      }
    }

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
