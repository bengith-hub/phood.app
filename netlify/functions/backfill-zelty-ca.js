/**
 * Netlify Function: Backfill historical Zelty closures into ventes_historique
 *
 * POST /.netlify/functions/backfill-zelty-ca
 * Body: { date_from?: "YYYY-MM-DD", date_to?: "YYYY-MM-DD" }
 *
 * Fetches ALL closures from Zelty API with pagination (limit=200 + offset),
 * filters by date range, deduplicates, and upserts into ventes_historique.
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const ZELTY_PAGE_SIZE = 200; // max tested working value (500 returns 0)

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

    // Debug mode: show pagination analysis
    if (body.debug) {
      const allClosures = await fetchAllClosures(ZELTY_API_KEY);
      const dates = allClosures.map(c => c.date).filter(Boolean).sort();
      return {
        statusCode: 200,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          debug: true,
          total_closures: allClosures.length,
          unique_dates: new Set(dates).size,
          first_date: dates[0] || null,
          last_date: dates[dates.length - 1] || null,
        }),
      };
    }

    // Default date range: last 18 months
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const dateTo = body.date_to || yesterday.toISOString().slice(0, 10);

    let dateFrom = body.date_from;
    if (!dateFrom) {
      const d = new Date(dateTo);
      d.setMonth(d.getMonth() - 18);
      dateFrom = d.toISOString().slice(0, 10);
    }

    const results = { imported: 0, skipped: 0, errors: 0, date_from: dateFrom, date_to: dateTo, pages_fetched: 0, total_closures_fetched: 0, first_error: null };

    // Fetch ALL closures with pagination
    const closures = await fetchAllClosures(ZELTY_API_KEY);
    results.total_closures_fetched = closures.length;

    // Filter to requested date range and map fields
    const allRows = [];
    for (const c of closures) {
      if (!c.date) continue;
      if (c.date < dateFrom || c.date > dateTo) continue;
      allRows.push({
        date: c.date,
        ca_ttc: (c.turnover || 0) / 100,
        nb_tickets: 0,
        nb_couverts: null,
        cloture_validee: true,
        zelty_closure_id: String(c.id),
      });
    }

    if (allRows.length === 0) {
      results.skipped = 1;
      return {
        statusCode: 200,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(results),
      };
    }

    // Deduplicate by date (keep highest turnover per date)
    const byDate = {};
    for (const row of allRows) {
      const existing = byDate[row.date];
      if (existing) {
        if (row.ca_ttc > existing.ca_ttc) {
          byDate[row.date] = row;
        }
      } else {
        byDate[row.date] = { ...row };
      }
    }
    const uniqueRows = Object.values(byDate);

    // Bulk upsert to Supabase (batch in chunks of 500 to avoid payload limits)
    const BATCH_SIZE = 500;
    let totalImported = 0;
    let batchError = null;

    for (let i = 0; i < uniqueRows.length; i += BATCH_SIZE) {
      const batch = uniqueRows.slice(i, i + BATCH_SIZE);
      const upsertResp = await fetch(
        `${SUPABASE_URL}/rest/v1/ventes_historique?on_conflict=date`,
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
        totalImported += batch.length;
      } else {
        const errText = await upsertResp.text().catch(() => '');
        batchError = `Supabase batch ${Math.floor(i / BATCH_SIZE) + 1}: ${errText.slice(0, 200)}`;
        results.errors += batch.length;
      }
    }

    results.imported = totalImported;
    if (batchError) results.first_error = batchError;

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

/**
 * Fetch ALL closures from Zelty API with pagination.
 * Uses limit=200 + offset, stops when a page returns fewer results.
 */
async function fetchAllClosures(apiKey) {
  const allClosures = [];
  let offset = 0;
  const MAX_PAGES = 20; // safety limit (20 × 200 = 4000 closures max)

  for (let page = 0; page < MAX_PAGES; page++) {
    const url = `${ZELTY_BASE_URL}/closures?limit=${ZELTY_PAGE_SIZE}&offset=${offset}`;
    const resp = await fetch(url, {
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Accept': 'application/json',
      },
    });

    if (!resp.ok) {
      throw new Error(`Zelty API HTTP ${resp.status} at offset ${offset}`);
    }

    const data = await resp.json();
    const closures = data.closures || [];
    allClosures.push(...closures);

    // Stop if we got fewer than the page size (last page)
    if (closures.length < ZELTY_PAGE_SIZE) break;

    offset += ZELTY_PAGE_SIZE;
  }

  return allClosures;
}
