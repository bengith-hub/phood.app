/**
 * Netlify Function: Backfill historical Zelty closures into ventes_historique
 *
 * POST /.netlify/functions/backfill-zelty-ca
 * Body: { date_from?: "YYYY-MM-DD", date_to?: "YYYY-MM-DD" }
 *
 * Fetches closures from Zelty API for the given date range
 * and upserts into ventes_historique table in Supabase.
 *
 * Uses parallel fetches (10 concurrent) for speed within Netlify's timeout.
 * Called by the UI in monthly chunks.
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const CONCURRENCY = 10; // Fetch 10 dates in parallel

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
      d.setMonth(d.getMonth() - 1); // Default: 1 month (called in chunks by UI)
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

    // Fetch a single date from Zelty
    async function fetchDate(dateStr) {
      try {
        const resp = await fetch(`${ZELTY_BASE_URL}/closures?date=${dateStr}`, {
          headers: {
            'Authorization': `Bearer ${ZELTY_API_KEY}`,
            'Accept': 'application/json',
          },
        });

        if (!resp.ok) {
          if (resp.status === 404) return { date: dateStr, rows: [], skipped: true };
          const errBody = await resp.text().catch(() => '');
          return { date: dateStr, rows: [], error: true, errorDetail: `HTTP ${resp.status}: ${errBody.slice(0, 200)}` };
        }

        const data = await resp.json();
        const closures = data.closures || [];

        if (closures.length === 0) {
          return { date: dateStr, rows: [], skipped: true };
        }

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

        return { date: dateStr, rows };
      } catch {
        return { date: dateStr, rows: [], error: true };
      }
    }

    // Process dates in parallel batches of CONCURRENCY
    const allRows = [];
    for (let i = 0; i < dates.length; i += CONCURRENCY) {
      const batch = dates.slice(i, i + CONCURRENCY);
      const batchResults = await Promise.all(batch.map(d => fetchDate(d)));

      for (const r of batchResults) {
        if (r.error) {
          results.errors++;
          if (!results.first_error && r.errorDetail) results.first_error = r.errorDetail;
        }
        else if (r.skipped) results.skipped++;
        if (r.rows.length > 0) allRows.push(...r.rows);
      }
    }

    // Bulk upsert all collected rows to Supabase (in batches of 200)
    if (allRows.length > 0) {
      for (let i = 0; i < allRows.length; i += 200) {
        const batch = allRows.slice(i, i + 200);
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
