/**
 * Netlify Function: Backfill nb_tickets in ventes_historique from Zelty orders
 *
 * POST /.netlify/functions/backfill-zelty-tickets
 * Body: { date_from?: "YYYY-MM-DD", date_to?: "YYYY-MM-DD", batch_size?: number }
 *
 * For each date in ventes_historique where nb_tickets=0,
 * fetches orders from Zelty and counts them.
 *
 * Note: Zelty /closures does NOT include ticket counts.
 * We must use /orders endpoint to count individual orders per day.
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
    return { statusCode: 500, body: JSON.stringify({ error: 'Configuration manquante' }) };
  }

  try {
    const body = JSON.parse(event.body || '{}');
    const batchSize = body.batch_size || 30; // Process N dates per invocation to avoid timeout

    // Fetch dates with nb_tickets = 0 from ventes_historique
    const queryParams = new URLSearchParams({
      select: 'date',
      nb_tickets: 'eq.0',
      order: 'date.asc',
      limit: String(batchSize),
    });

    if (body.date_from) queryParams.append('date', `gte.${body.date_from}`);
    if (body.date_to) queryParams.append('date', `lte.${body.date_to}`);

    const listResp = await fetch(`${SUPABASE_URL}/rest/v1/ventes_historique?${queryParams}`, {
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
      },
    });

    if (!listResp.ok) {
      throw new Error(`Supabase list error: ${listResp.status}`);
    }

    const dates = (await listResp.json()).map(r => r.date);

    if (dates.length === 0) {
      return {
        statusCode: 200,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: 'Aucune date avec nb_tickets=0', updated: 0, remaining: 0 }),
      };
    }

    let updated = 0;
    let errors = 0;
    const details = [];

    for (const dateStr of dates) {
      try {
        // Fetch orders for this date from Zelty
        const ordersUrl = `${ZELTY_BASE_URL}/orders?from=${dateStr}T00:00:00&to=${dateStr}T23:59:59&limit=200`;
        const ordersResp = await fetch(ordersUrl, {
          headers: {
            'Authorization': `Bearer ${ZELTY_API_KEY}`,
            'Accept': 'application/json',
          },
        });

        if (!ordersResp.ok) {
          // Rate limit — wait and retry once
          if (ordersResp.status === 429) {
            await sleep(2000);
            const retryResp = await fetch(ordersUrl, {
              headers: {
                'Authorization': `Bearer ${ZELTY_API_KEY}`,
                'Accept': 'application/json',
              },
            });
            if (!retryResp.ok) {
              errors++;
              details.push({ date: dateStr, error: `Zelty ${retryResp.status} after retry` });
              continue;
            }
            var ordersData = await retryResp.json();
          } else {
            errors++;
            details.push({ date: dateStr, error: `Zelty ${ordersResp.status}` });
            continue;
          }
        } else {
          var ordersData = await ordersResp.json();
        }

        const orders = ordersData.orders || [];
        // Count orders with positive amount
        const nbTickets = orders.filter(o => {
          const amount = o.price?.final_amount_inc_tax || 0;
          return amount > 0;
        }).length;

        // Update ventes_historique
        const updateResp = await fetch(
          `${SUPABASE_URL}/rest/v1/ventes_historique?date=eq.${dateStr}`,
          {
            method: 'PATCH',
            headers: {
              'Content-Type': 'application/json',
              'apikey': SUPABASE_KEY,
              'Authorization': `Bearer ${SUPABASE_KEY}`,
            },
            body: JSON.stringify({ nb_tickets: nbTickets }),
          }
        );

        if (updateResp.ok) {
          updated++;
          details.push({ date: dateStr, nb_tickets: nbTickets });
        } else {
          errors++;
          details.push({ date: dateStr, error: `Supabase update ${updateResp.status}` });
        }

        // Small delay to respect Zelty rate limits
        await sleep(200);
      } catch (err) {
        errors++;
        details.push({ date: dateStr, error: err.message });
      }
    }

    // Check remaining
    const remainingResp = await fetch(
      `${SUPABASE_URL}/rest/v1/ventes_historique?select=date&nb_tickets=eq.0&limit=1`,
      {
        headers: {
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
          'Prefer': 'count=exact',
        },
      }
    );
    const remainingCount = parseInt(remainingResp.headers.get('content-range')?.split('/')[1] || '0');

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        processed: dates.length,
        updated,
        errors,
        remaining: remainingCount,
        details,
      }),
    };
  } catch (err) {
    return {
      statusCode: 500,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ error: err.message }),
    };
  }
};

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
