/**
 * Backfill nb_tickets in ventes_historique from Zelty /orders endpoint.
 * Run: node scripts/backfill-tickets.cjs
 */
require('dotenv').config();

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Missing env vars');
  process.exit(1);
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function main() {
  // Get all dates with nb_tickets = 0
  const listResp = await fetch(
    `${SUPABASE_URL}/rest/v1/ventes_historique?select=date&nb_tickets=eq.0&order=date.asc`,
    {
      headers: {
        'apikey': SUPABASE_KEY,
        'Authorization': `Bearer ${SUPABASE_KEY}`,
      },
    }
  );
  const dates = (await listResp.json()).map(r => r.date);
  console.log(`Found ${dates.length} dates with nb_tickets=0`);

  let updated = 0;
  let errors = 0;

  for (let i = 0; i < dates.length; i++) {
    const dateStr = dates[i];
    try {
      const ordersResp = await fetch(
        `${ZELTY_BASE_URL}/orders?from=${dateStr}T00:00:00&to=${dateStr}T23:59:59&limit=200`,
        {
          headers: {
            'Authorization': `Bearer ${ZELTY_API_KEY}`,
            'Accept': 'application/json',
          },
        }
      );

      if (ordersResp.status === 429) {
        console.log(`  Rate limited at ${dateStr}, waiting 3s...`);
        await sleep(3000);
        // Retry
        const retryResp = await fetch(
          `${ZELTY_BASE_URL}/orders?from=${dateStr}T00:00:00&to=${dateStr}T23:59:59&limit=200`,
          {
            headers: {
              'Authorization': `Bearer ${ZELTY_API_KEY}`,
              'Accept': 'application/json',
            },
          }
        );
        if (!retryResp.ok) {
          console.error(`  ${dateStr}: Zelty ${retryResp.status} after retry`);
          errors++;
          continue;
        }
        var ordersData = await retryResp.json();
      } else if (!ordersResp.ok) {
        console.error(`  ${dateStr}: Zelty ${ordersResp.status}`);
        errors++;
        continue;
      } else {
        var ordersData = await ordersResp.json();
      }

      const orders = ordersData.orders || [];
      const nbTickets = orders.filter(o => (o.price?.final_amount_inc_tax || 0) > 0).length;

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
        process.stdout.write(`\r  [${i + 1}/${dates.length}] ${dateStr}: ${nbTickets} tickets`);
      } else {
        console.error(`\n  ${dateStr}: Supabase update ${updateResp.status}`);
        errors++;
      }

      // Delay to avoid Zelty rate limits
      await sleep(250);
    } catch (err) {
      console.error(`\n  ${dateStr}: ${err.message}`);
      errors++;
    }
  }

  console.log(`\n\nDone! Updated: ${updated}, Errors: ${errors}`);
}

main().catch(console.error);
