/**
 * Backfill prix_vente for existing Zelty recipes that have no prices set.
 * Fetches price data from Zelty API and updates Supabase.
 *
 * Usage: node scripts/backfill-zelty-prices.cjs [--dry-run|--live]
 */
const ZELTY_API_KEY = process.env.ZELTY_API_KEY;
const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!ZELTY_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Missing env vars: ZELTY_API_KEY, VITE_SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const dryRun = !process.argv.includes('--live');
if (dryRun) console.log('=== DRY RUN (use --live to apply) ===\n');

const supaHeaders = {
  'apikey': SUPABASE_KEY,
  'Authorization': `Bearer ${SUPABASE_KEY}`,
  'Content-Type': 'application/json',
};

async function main() {
  // 1. Fetch all Zelty dishes
  console.log('Fetching Zelty dishes...');
  const dishResp = await fetch('https://api.zelty.fr/2.10/catalog/dishes?limit=500&show_all=true', {
    headers: { 'Authorization': `Bearer ${ZELTY_API_KEY}`, 'Accept': 'application/json' },
  });
  if (!dishResp.ok) throw new Error(`Zelty API error: ${dishResp.status}`);
  const dishData = await dishResp.json();
  const dishes = dishData.dishes || [];
  console.log(`  → ${dishes.length} dishes from Zelty`);

  // Build price map: zelty_id → { prix_vente }
  const priceMap = new Map();
  for (const d of dishes) {
    if (!d.price || d.price <= 0) continue;
    const ttcSP = d.price / 100;
    const tvaSP = (d.tax || d.tva || 1000) / 100;
    const ttcEMP = d.price_togo ? d.price_togo / 100 : ttcSP;
    const tvaEMP = d.tax_takeaway ? d.tax_takeaway / 100 : (d.tvat ? d.tvat / 100 : tvaSP);
    const ttcLIV = d.price_delivery ? d.price_delivery / 100 : ttcSP;
    const tvaLIV = d.tax_delivery ? d.tax_delivery / 100 : (d.tvad ? d.tvad / 100 : tvaSP);
    priceMap.set(String(d.id), {
      sur_place: { ttc: ttcSP, tva: tvaSP },
      emporter: { ttc: ttcEMP, tva: tvaEMP },
      livraison: { ttc: ttcLIV, tva: tvaLIV },
    });
  }

  // 2. Fetch recipes with zelty_product_id
  console.log('Fetching recipes from Supabase...');
  const recResp = await fetch(
    `${SUPABASE_URL}/rest/v1/recettes?select=id,nom,zelty_product_id,prix_vente&zelty_product_id=not.is.null`,
    { headers: supaHeaders },
  );
  if (!recResp.ok) throw new Error(`Supabase error: ${recResp.status}`);
  const recettes = await recResp.json();
  console.log(`  → ${recettes.length} recipes linked to Zelty\n`);

  // 3. Update recipes missing prix_vente
  let updated = 0;
  let alreadySet = 0;
  let noZeltyPrice = 0;

  for (const r of recettes) {
    const zeltyPrice = priceMap.get(r.zelty_product_id);
    if (!zeltyPrice) {
      noZeltyPrice++;
      continue;
    }

    // Check if prix_vente is already set with real values
    const existing = r.prix_vente;
    if (existing && existing.sur_place && existing.sur_place.ttc > 0) {
      alreadySet++;
      continue;
    }

    console.log(`  ${r.nom} → SP: ${zeltyPrice.sur_place.ttc}€ TTC (TVA ${zeltyPrice.sur_place.tva}%), EMP: ${zeltyPrice.emporter.ttc}€, LIV: ${zeltyPrice.livraison.ttc}€`);

    if (!dryRun) {
      const patchResp = await fetch(
        `${SUPABASE_URL}/rest/v1/recettes?id=eq.${r.id}`,
        {
          method: 'PATCH',
          headers: supaHeaders,
          body: JSON.stringify({ prix_vente: zeltyPrice }),
        },
      );
      if (!patchResp.ok) {
        console.error(`    ✗ PATCH failed: ${await patchResp.text()}`);
      } else {
        console.log(`    ✓ Updated`);
      }
    }
    updated++;
  }

  console.log(`\n=== Summary ===`);
  console.log(`Total recipes: ${recettes.length}`);
  console.log(`Already had prices: ${alreadySet}`);
  console.log(`No Zelty price found: ${noZeltyPrice}`);
  console.log(`${dryRun ? 'Would update' : 'Updated'}: ${updated}`);
}

main().catch(err => { console.error('FATAL:', err); process.exit(1); });
