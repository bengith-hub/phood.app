/**
 * Netlify Function: Backfill/recalculate repartition_horaire from Zelty orders
 *
 * POST /.netlify/functions/backfill-repartition-horaire
 * Body: { weeks?: number } (default: 8)
 *
 * Fetches orders from Zelty for the last N weeks,
 * calculates hourly CA distribution by day-of-week + contexte,
 * and upserts into repartition_horaire table.
 *
 * Zelty order structure:
 *   created_at: "2026-03-07T19:50:44+01:00" (local timezone)
 *   price.final_amount_inc_tax: 2700 (centimes TTC)
 *   mode: "takeaway" | "delivery" | "eat_in" | ...
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 200;

exports.handler = async function (event) {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
  const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
  const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: 'Configuration manquante (ZELTY_API_KEY, VITE_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)' }),
    };
  }

  try {
    const body = JSON.parse(event.body || '{}');
    const weeks = body.weeks || 8;

    // 1. Fetch evenements from Supabase to determine "vacances" contexte
    const evtsResp = await fetch(
      `${SUPABASE_URL}/rest/v1/evenements?select=date_debut,date_fin,type&type=eq.vacances`,
      {
        headers: {
          'apikey': SUPABASE_KEY,
          'Authorization': `Bearer ${SUPABASE_KEY}`,
        },
      }
    );
    const evenements = evtsResp.ok ? await evtsResp.json() : [];

    function isVacances(dateStr) {
      return evenements.some(e => dateStr >= e.date_debut && dateStr <= e.date_fin);
    }

    // 2. Fetch orders day by day and aggregate hourly data
    // Structure: dayData[contexte][jourSemaine] = { dayTotals: number[], hourTotals: { [heure]: number[] } }
    const dayData = {};

    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const startDate = new Date(today);
    startDate.setDate(startDate.getDate() - (weeks * 7));

    let totalOrders = 0;
    let daysProcessed = 0;
    let apiCalls = 0;

    for (let d = new Date(startDate); d < today; d.setDate(d.getDate() + 1)) {
      // Use local date formatting to avoid UTC timezone shift
      const dateStr = localDateStr(d);
      const dayOfWeek = d.getDay(); // 0=Sun, 1=Mon, ...

      // Determine contexte
      let contexte;
      if (isVacances(dateStr)) {
        contexte = 'vacances';
      } else if (dayOfWeek === 6) {
        contexte = 'samedi';
      } else if (dayOfWeek === 0) {
        contexte = 'dimanche';
      } else {
        contexte = 'standard';
      }

      // Fetch ALL orders for this day (with pagination)
      const orders = await fetchDayOrders(ZELTY_API_KEY, dateStr);
      apiCalls++;

      if (orders.length === 0) continue;

      // Initialize data structures
      if (!dayData[contexte]) dayData[contexte] = {};
      if (!dayData[contexte][dayOfWeek]) {
        dayData[contexte][dayOfWeek] = { dayTotals: [], hourTotals: {} };
      }

      let dayTotal = 0;
      const hourTotals = {};

      for (const order of orders) {
        // Extract total TTC in euros (centimes -> euros)
        const priceCentimes = order.price?.final_amount_inc_tax || 0;
        if (priceCentimes <= 0) continue;
        const totalEuros = priceCentimes / 100;

        // Extract local hour from created_at (ISO with timezone offset)
        const hour = extractLocalHour(order.created_at);
        if (hour === null || hour < 10 || hour > 21) continue;

        dayTotal += totalEuros;
        hourTotals[hour] = (hourTotals[hour] || 0) + totalEuros;
        totalOrders++;
      }

      if (dayTotal > 0) {
        dayData[contexte][dayOfWeek].dayTotals.push(dayTotal);
        for (const [hour, total] of Object.entries(hourTotals)) {
          if (!dayData[contexte][dayOfWeek].hourTotals[hour]) {
            dayData[contexte][dayOfWeek].hourTotals[hour] = [];
          }
          dayData[contexte][dayOfWeek].hourTotals[hour].push(total);
        }
        daysProcessed++;
      }

      // Small delay to avoid Zelty rate limiting (~10 req/s triggers 429)
      await sleep(150);
    }

    // 3. Calculate percentages
    const rows = [];

    for (const [contexte, daysMap] of Object.entries(dayData)) {
      for (const [dayOfWeek, data] of Object.entries(daysMap)) {
        if (data.dayTotals.length === 0) continue;

        // Total CA across all days for this context+day combination
        const sumDayTotals = data.dayTotals.reduce((a, b) => a + b, 0);
        const nbDays = data.dayTotals.length;

        for (let heure = 10; heure <= 21; heure++) {
          const hourValues = data.hourTotals[heure] || [];
          // Sum of all CA for this hour across all days
          const sumHourCA = hourValues.reduce((a, b) => a + b, 0);
          // Percentage = (total CA this hour) / (total CA all hours) * 100
          const pourcentage = sumDayTotals > 0
            ? Math.round((sumHourCA / sumDayTotals) * 10000) / 100
            : 0;

          rows.push({
            jour_semaine: parseInt(dayOfWeek),
            creneau_heure: heure,
            pourcentage,
            contexte,
            updated_at: new Date().toISOString(),
          });
        }
      }
    }

    // 4. Upsert into repartition_horaire
    let upserted = 0;
    if (rows.length > 0) {
      const upsertResp = await fetch(
        `${SUPABASE_URL}/rest/v1/repartition_horaire?on_conflict=jour_semaine,creneau_heure,contexte`,
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
        throw new Error(`Supabase upsert error: ${errText}`);
      }
      upserted = rows.length;
    }

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        success: true,
        weeks,
        daysProcessed,
        totalOrders,
        rowsUpserted: upserted,
        apiCalls,
        contextes: Object.keys(dayData),
        details: Object.fromEntries(
          Object.entries(dayData).map(([ctx, days]) => [
            ctx,
            Object.fromEntries(
              Object.entries(days).map(([dow, data]) => [dow, `${data.dayTotals.length} jours`])
            ),
          ])
        ),
      }),
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
 * Fetch all orders for a given day from Zelty API (with pagination).
 * Uses `from` and `to` params (not date_min/date_max).
 */
async function fetchDayOrders(apiKey, dateStr) {
  const allOrders = [];
  let offset = 0;
  const MAX_PAGES = 10;

  for (let page = 0; page < MAX_PAGES; page++) {
    const url = `${ZELTY_BASE_URL}/orders?from=${dateStr}T00:00:00&to=${dateStr}T23:59:59&limit=${PAGE_SIZE}&offset=${offset}`;
    const resp = await fetch(url, {
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Accept': 'application/json',
      },
    });

    if (!resp.ok) {
      console.warn(`Zelty API error for ${dateStr} offset ${offset}: ${resp.status}`);
      break;
    }

    const data = await resp.json();
    const orders = data.orders || [];
    allOrders.push(...orders);

    // Stop if we got fewer than page size (last page)
    if (orders.length < PAGE_SIZE) break;

    offset += PAGE_SIZE;
    await sleep(100); // Rate limit protection
  }

  return allOrders;
}

/**
 * Extract local hour from a Zelty ISO timestamp.
 * Zelty returns timestamps with timezone offset: "2026-03-07T19:50:44+01:00"
 * The hour in the string IS the local hour.
 */
function extractLocalHour(timestamp) {
  if (!timestamp) return null;
  const match = timestamp.match(/T(\d{2}):/);
  if (match) return parseInt(match[1], 10);
  return null;
}

/**
 * Format a Date as YYYY-MM-DD using local timezone (not UTC).
 * Avoids off-by-one day shift when local timezone is ahead of UTC.
 */
function localDateStr(d) {
  return d.getFullYear() + '-' +
    String(d.getMonth() + 1).padStart(2, '0') + '-' +
    String(d.getDate()).padStart(2, '0');
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
