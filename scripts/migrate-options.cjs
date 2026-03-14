/**
 * Migration: Merge variantes + modificateurs → options (single JSONB column)
 *
 * Steps:
 * 1. ALTER TABLE recettes ADD COLUMN IF NOT EXISTS options JSONB
 * 2. Fetch all recettes with variantes or modificateurs
 * 3. Merge into unified RecetteOption[] format
 * 4. PATCH each recette with new options column
 * 5. (After verification) DROP old columns
 *
 * Usage:
 *   node scripts/migrate-options.cjs --dry-run   # preview
 *   node scripts/migrate-options.cjs --live       # apply
 *   node scripts/migrate-options.cjs --drop       # drop old columns after verification
 */
const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('Missing VITE_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const mode = process.argv.includes('--live') ? 'live'
  : process.argv.includes('--drop') ? 'drop'
  : 'dry-run';

const supaHeaders = {
  'apikey': SUPABASE_KEY,
  'Authorization': `Bearer ${SUPABASE_KEY}`,
  'Content-Type': 'application/json',
};

function normalize(s) {
  return s.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').trim();
}

/**
 * Convert a variante to RecetteOption
 */
function varianteToOption(v) {
  const nameLower = normalize(v.nom || '');
  const isTaille = (v.coefficient && v.coefficient !== 1.0)
    || nameLower === 'normal' || nameLower === 'grand'
    || nameLower === 'petit';

  const opt = {
    nom: v.nom,
    type: isTaille ? 'taille' : 'choix',
  };
  if (v.zelty_option_value_id) opt.zelty_option_value_id = v.zelty_option_value_id;
  if (isTaille) opt.coefficient = v.coefficient || 1.0;
  return opt;
}

/**
 * Convert a modificateur to RecetteOption
 */
function modificateurToOption(m) {
  const opt = {
    nom: m.nom,
    type: m.type || 'extra', // 'extra' or 'sans'
  };
  if (m.zelty_option_value_id) opt.zelty_option_value_id = m.zelty_option_value_id;
  if (m.prix_supplement && m.prix_supplement > 0) opt.prix_supplement = m.prix_supplement;
  if (m.impact_stock && m.impact_stock.length > 0) opt.impact_stock = m.impact_stock;
  return opt;
}

async function main() {
  if (mode === 'drop') {
    console.log('=== DROP old columns ===');
    console.log('Dropping variantes and modificateurs columns from recettes table...');

    // Use Supabase RPC or raw SQL via PostgREST — we can use the rpc endpoint
    // Since we can't run raw SQL via PostgREST, we'll need to do this manually in Supabase dashboard
    console.log('\nPlease run these SQL commands in Supabase SQL Editor:');
    console.log('  ALTER TABLE recettes DROP COLUMN IF EXISTS variantes;');
    console.log('  ALTER TABLE recettes DROP COLUMN IF EXISTS modificateurs;');
    console.log('\nOr run them via supabase CLI migration.');
    return;
  }

  if (mode === 'dry-run') console.log('=== DRY RUN (use --live to apply) ===\n');

  // Step 1: Add options column if needed
  // We can't run DDL via PostgREST, so check if column exists by trying to fetch it
  console.log('Step 1: Checking if options column exists...');
  const testResp = await fetch(
    `${SUPABASE_URL}/rest/v1/recettes?select=options&limit=1`,
    { headers: supaHeaders },
  );
  if (!testResp.ok) {
    const err = await testResp.text();
    if (err.includes('options')) {
      console.error('  ✗ "options" column does not exist yet.');
      console.error('  Please run in Supabase SQL Editor:');
      console.error('    ALTER TABLE recettes ADD COLUMN IF NOT EXISTS options JSONB;');
      process.exit(1);
    }
    throw new Error(`Supabase error: ${err}`);
  }
  console.log('  ✓ "options" column exists');

  // Step 2: Fetch all recettes with variantes or modificateurs
  console.log('\nStep 2: Fetching recettes with variantes/modificateurs...');
  const resp = await fetch(
    `${SUPABASE_URL}/rest/v1/recettes?select=id,nom,variantes,modificateurs,options&or=(variantes.not.is.null,modificateurs.not.is.null)`,
    { headers: supaHeaders },
  );
  if (!resp.ok) throw new Error(`Fetch error: ${await resp.text()}`);
  const recettes = await resp.json();
  console.log(`  → ${recettes.length} recettes to migrate`);

  // Step 3 + 4: Merge and update
  let migrated = 0;
  let skipped = 0;

  for (const r of recettes) {
    // If options already populated, skip (already migrated)
    if (r.options && r.options.length > 0) {
      skipped++;
      continue;
    }

    const merged = [];

    // Convert variantes
    for (const v of (r.variantes || [])) {
      merged.push(varianteToOption(v));
    }

    // Convert modificateurs
    for (const m of (r.modificateurs || [])) {
      merged.push(modificateurToOption(m));
    }

    if (merged.length === 0) {
      skipped++;
      continue;
    }

    const types = {};
    for (const o of merged) types[o.type] = (types[o.type] || 0) + 1;
    const desc = Object.entries(types).map(([t, c]) => `${c} ${t}`).join(', ');
    console.log(`  ${r.nom} → ${merged.length} options (${desc})`);

    if (mode === 'live') {
      const patchResp = await fetch(
        `${SUPABASE_URL}/rest/v1/recettes?id=eq.${r.id}`,
        {
          method: 'PATCH',
          headers: supaHeaders,
          body: JSON.stringify({ options: merged }),
        },
      );
      if (!patchResp.ok) {
        console.error(`    ✗ PATCH failed: ${await patchResp.text()}`);
      } else {
        console.log(`    ✓ Updated`);
      }
    }
    migrated++;
  }

  console.log(`\n=== Summary ===`);
  console.log(`Total: ${recettes.length}`);
  console.log(`${mode === 'live' ? 'Migrated' : 'Would migrate'}: ${migrated}`);
  console.log(`Skipped (already done or empty): ${skipped}`);

  if (mode === 'live') {
    console.log('\n✅ Migration complete! Next steps:');
    console.log('  1. Verify in the app that options display correctly');
    console.log('  2. Run: node scripts/migrate-options.cjs --drop (instructions to drop old columns)');
  }
}

main().catch(err => { console.error('FATAL:', err); process.exit(1); });
