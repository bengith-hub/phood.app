/**
 * Netlify Function: Backfill historical Zelty closures into ventes_historique
 *
 * POST /.netlify/functions/backfill-zelty-ca
 * Body: { date_from?: "YYYY-MM-DD", date_to?: "YYYY-MM-DD" }
 *
 * Fetches closures from Zelty API for the given date range
 * and upserts into ventes_historique table in Supabase.
 *
 * Sequential fetches with minimal delay. Called by the UI in weekly chunks
 * (7 days) to stay within Netlify's 10-second free-tier timeout.
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

    // Default: yesterday
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const dateTo = body.date_to || yesterday.toISOString().slice(0, 10);

    let dateFrom = body.date_from;
    if (!dateFrom) {
      const d = new Date(dateTo);
      d.setDate(d.getDate() - 6); // Default: 7 days (called in weekly chunks by UI)
      dateFrom = d.toISOString().slice(0, 10);
    }

    const results = { imported: 0, skipped: 0, errors: 0, date_from: dateFrom, date_to: dateTo, first_error: null };

    // Build list of dates to fetch
    const dates = [];
    const start = new Date(dateFrom);
    const end = new Date(dateTo);
    for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
      dates.push(d.toISOString().slice(0, 10));
    }

    // Fetch dates sequentially (safest for rate limits, 7 days = ~3-4s)
    const allRows = [];
    for (const dateStr of dates) {
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
          // On 429 rate limit, wait 1s and retry once
          if (resp.status === 429) {
            await new Promise(r => setTimeout(r, 1000));
            const retry = await fetch(`${ZELTY_BASE_URL}/closures?date=${dateStr}`, {
              headers: {
                'Authorization': `Bearer ${ZELTY_API_KEY}`,
                'Accept': 'application/json',
              },
            });
            if (retry.ok) {
              const retryData = await retry.json();
              const closures = retryData.closures || [];
              for (const c of closures) {
                if (!c.date) continue;
                allRows.push({
                  date: c.date,
                  ca_ttc: c.total_ttc || 0,
                  nb_tickets: c.nb_tickets || 0,
                  nb_couverts: c.nb_covers ?? null,
                  cloture_validee: c.validated ?? true,
                  zelty_closure_id: c.id || null,
                });
              }
              if (closures.length === 0) results.skipped++;
              continue;
            }
          }
          const errBody = await resp.text().catch(() => '');
          results.errors++;
          if (!results.first_error) results.first_error = `HTTP ${resp.status}: ${errBody.slice(0, 200)}`;
          continue;
        }

        const data = await resp.json();
        const closures = data.closures || [];

        if (closures.length === 0) {
          results.skipped++;
          continue;
        }

        for (const c of closures) {
          if (!c.date) continue;
          allRows.push({
            date: c.date,
            ca_ttc: c.total_ttc || 0,
            nb_tickets: c.nb_tickets || 0,
            nb_couverts: c.nb_covers ?? null,
            cloture_validee: c.validated ?? true,
            zelty_closure_id: c.id || null,
          });
        }

        // Tiny delay to be gentle with Zelty
        await new Promise(r => setTimeout(r, 100));
      } catch {
        results.errors++;
      }
    }

    // Bulk upsert all collected rows to Supabase
    if (allRows.length > 0) {
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
          body: JSON.stringify(allRows),
        }
      );

      if (upsertResp.ok) {
        results.imported += allRows.length;
      } else {
        results.errors += allRows.length;
        const errText = await upsertResp.text().catch(() => '');
        if (!results.first_error) results.first_error = `Supabase: ${errText.slice(0, 200)}`;
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
