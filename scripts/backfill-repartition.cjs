#!/usr/bin/env node
/**
 * Local script: Backfill repartition_horaire from Zelty orders
 * Run: node scripts/backfill-repartition.cjs
 *
 * Fetches orders from Zelty for the last 8 weeks,
 * calculates hourly CA distribution by day-of-week + contexte,
 * and upserts into repartition_horaire table.
 */

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10';
const PAGE_SIZE = 200;

// Config from .env
require('dotenv').config();
const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Missing env vars: ZELTY_API_KEY, VITE_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const WEEKS = parseInt(process.argv[2] || '8', 10);
const JOURS = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];

async function main() {
  console.log(`\n=== Backfill repartition_horaire (${WEEKS} semaines) ===\n`);

  // 1. Fetch evenements (vacances) from Supabase
  console.log('Fetching evenements vacances...');
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
  console.log(`  ${evenements.length} periodes de vacances trouvees`);

  function isVacances(dateStr) {
    return evenements.some(e => dateStr >= e.date_debut && dateStr <= e.date_fin);
  }

  // 2. Fetch orders day by day
  const dayData = {};
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const startDate = new Date(today);
  startDate.setDate(startDate.getDate() - (WEEKS * 7));

  let totalOrders = 0;
  let daysProcessed = 0;
  let daysSkipped = 0;

  const totalDays = WEEKS * 7;
  for (let i = 0; i < totalDays; i++) {
    const d = new Date(startDate);
    d.setDate(startDate.getDate() + i);
    const dateStr = d.getFullYear() + '-' + String(d.getMonth()+1).padStart(2,'0') + '-' + String(d.getDate()).padStart(2,'0');
    const dayOfWeek = d.getDay();

    // Progress
    process.stdout.write(`\r  [${i + 1}/${totalDays}] ${dateStr} (${JOURS[dayOfWeek]})...`);

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

    // Fetch orders with pagination
    const orders = await fetchDayOrders(dateStr);

    if (orders.length === 0) {
      daysSkipped++;
      await sleep(100);
      continue;
    }

    // Initialize data structures
    if (!dayData[contexte]) dayData[contexte] = {};
    if (!dayData[contexte][dayOfWeek]) {
      dayData[contexte][dayOfWeek] = { dayTotals: [], hourTotals: {} };
    }

    let dayTotal = 0;
    const hourTotals = {};

    for (const order of orders) {
      const priceCentimes = order.price?.final_amount_inc_tax || 0;
      if (priceCentimes <= 0) continue;
      const totalEuros = priceCentimes / 100;

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

    await sleep(500);
  }

  console.log(`\n\n  ${daysProcessed} jours avec donnees, ${daysSkipped} jours sans commandes, ${totalOrders} commandes total`);

  // 3. Calculate percentages
  console.log('\nCalcul des pourcentages...');
  const rows = [];

  for (const [contexte, daysMap] of Object.entries(dayData)) {
    for (const [dayOfWeek, data] of Object.entries(daysMap)) {
      if (data.dayTotals.length === 0) continue;

      const sumDayTotals = data.dayTotals.reduce((a, b) => a + b, 0);

      console.log(`  ${contexte} / ${JOURS[dayOfWeek]} : ${data.dayTotals.length} jours, CA total ${Math.round(sumDayTotals)}€`);

      for (let heure = 10; heure <= 21; heure++) {
        const hourValues = data.hourTotals[heure] || [];
        const sumHourCA = hourValues.reduce((a, b) => a + b, 0);
        const pourcentage = sumDayTotals > 0
          ? Math.round((sumHourCA / sumDayTotals) * 10000) / 100
          : 0;

        if (pourcentage > 0) {
          process.stdout.write(`    ${heure}h: ${pourcentage}%  `);
        }

        rows.push({
          jour_semaine: parseInt(dayOfWeek),
          creneau_heure: heure,
          pourcentage,
          contexte,
          updated_at: new Date().toISOString(),
        });
      }
      console.log('');
    }
  }

  // 4. Upsert
  console.log(`\nUpsert de ${rows.length} lignes dans repartition_horaire...`);
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
      console.error(`  ERREUR Supabase: ${errText}`);
      process.exit(1);
    }

    console.log(`  OK ! ${rows.length} lignes inserees/mises a jour.`);
  }

  console.log('\n=== Backfill termine ===\n');
}

async function fetchDayOrders(dateStr) {
  const allOrders = [];
  let offset = 0;
  const MAX_PAGES = 10;

  for (let page = 0; page < MAX_PAGES; page++) {
    const url = `${ZELTY_BASE_URL}/orders?from=${dateStr}T00:00:00&to=${dateStr}T23:59:59&limit=${PAGE_SIZE}&offset=${offset}`;
    const resp = await fetch(url, {
      headers: {
        'Authorization': `Bearer ${ZELTY_API_KEY}`,
        'Accept': 'application/json',
      },
    });

    if (!resp.ok) {
      console.warn(`\n  Zelty API error for ${dateStr}: ${resp.status}`);
      break;
    }

    const data = await resp.json();
    const orders = data.orders || [];
    allOrders.push(...orders);

    if (orders.length < PAGE_SIZE) break;
    offset += PAGE_SIZE;
    await sleep(100);
  }

  return allOrders;
}

function extractLocalHour(timestamp) {
  if (!timestamp) return null;
  const match = timestamp.match(/T(\d{2}):/);
  if (match) return parseInt(match[1], 10);
  return null;
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

main().catch(err => {
  console.error('FATAL:', err);
  process.exit(1);
});
