/**
 * Netlify Function: Backfill historical Zelty closures into ventes_historique
 *
 * POST /.netlify/functions/backfill-zelty-ca
 * Body: { date_from?: "YYYY-MM-DD", date_to?: "YYYY-MM-DD" }
 *
 * Fetches ALL closures from Zelty API in a single call, filters by date range,
 * and upserts into ventes_historique table in Supabase.
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

    // Debug mode: return Zelty API response analysis
    if (body.debug) {
      const debugResp = await fetch(`${ZELTY_BASE_URL}/closures`, {
        headers: { 'Authorization': `Bearer ${ZELTY_API_KEY}`, 'Accept': 'application/json' },
      });
      const debugData = await debugResp.json();
      const closures = debugData.closures || [];
      const dates = closures.map(c => c.date).filter(Boolean).sort();
      // Check for pagination fields
      const topLevelKeys = Object.keys(debugData);
      return {
        statusCode: 200,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          debug: true,
          status: debugResp.status,
          total_closures: closures.length,
          first_date: dates[0] || null,
          last_date: dates[dates.length - 1] || null,
          top_level_keys: topLevelKeys,
          has_pagination: !!(debugData.next || debugData.pagination || debugData.meta || debugData.total),
          pagination_info: { next: debugData.next, pagination: debugData.pagination, meta: debugData.meta, total: debugData.total },
          sample_first: closures.slice(0, 2),
          sample_last: closures.slice(-2),
        }),
      };
    }

    // Default date range: last 7 days
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const dateTo = body.date_to || yesterday.toISOString().slice(0, 10);

    let dateFrom = body.date_from;
    if (!dateFrom) {
      const d = new Date(dateTo);
      d.setDate(d.getDate() - 6);
      dateFrom = d.toISOString().slice(0, 10);
    }

    const results = { imported: 0, skipped: 0, errors: 0, date_from: dateFrom, date_to: dateTo, first_error: null };

    // Fetch all closures in a single call (Zelty returns all closures regardless of ?date param)
    const resp = await fetch(`${ZELTY_BASE_URL}/closures`, {
      headers: {
        'Authorization': `Bearer ${ZELTY_API_KEY}`,
        'Accept': 'application/json',
      },
    });

    if (!resp.ok) {
      const errBody = await resp.text().catch(() => '');
      return {
        statusCode: 200,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          ...results,
          errors: 1,
          first_error: `Zelty API HTTP ${resp.status}: ${errBody.slice(0, 200)}`,
        }),
      };
    }

    const data = await resp.json();
    const closures = data.closures || [];

    // Filter to requested date range and map fields
    // Zelty closure fields: id, date, turnover (centimes), taxes (centimes)
    const allRows = [];
    for (const c of closures) {
      if (!c.date) continue;
      if (c.date < dateFrom || c.date > dateTo) continue;
      allRows.push({
        date: c.date,
        ca_ttc: (c.turnover || 0) / 100, // centimes → euros
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

    // Deduplicate by date (Zelty can return multiple closures per date — e.g. one with turnover=0)
    const byDate = {};
    for (const row of allRows) {
      const existing = byDate[row.date];
      if (existing) {
        // Keep the one with higher turnover (the real closure, not the empty midnight one)
        if (row.ca_ttc > existing.ca_ttc) {
          byDate[row.date] = row;
        }
      } else {
        byDate[row.date] = { ...row };
      }
    }
    const uniqueRows = Object.values(byDate);

    // Bulk upsert to Supabase
    if (uniqueRows.length > 0) {
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
          body: JSON.stringify(uniqueRows),
        }
      );

      if (upsertResp.ok) {
        results.imported = uniqueRows.length;
      } else {
        results.errors = uniqueRows.length;
        const errText = await upsertResp.text().catch(() => '');
        results.first_error = `Supabase: ${errText.slice(0, 200)}`;
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
