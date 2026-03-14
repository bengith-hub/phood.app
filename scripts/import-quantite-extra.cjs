#!/usr/bin/env node
/**
 * Import default extra quantities per ingredient.
 * Data sourced from inpulse supplement recipes.
 *
 * Usage: node scripts/import-quantite-extra.cjs [--dry-run|--live]
 */
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const env = fs.readFileSync(__dirname + '/../.env', 'utf8');
const url = env.match(/VITE_SUPABASE_URL=(.+)/)[1].trim();
const skey = (env.match(/SUPABASE_SERVICE_ROLE_KEY=(.+)/) || [])[1]?.trim();
const c = createClient(url, skey);

const dryRun = !process.argv.includes('--live');

// Inpulse supplement data: ingredient name -> { quantite, unite }
// From inpulse_export_phood_actifs.json supplement recipes
const EXTRA_DEFAULTS = [
  // Protéines
  { match: 'Filet poulet', quantite: 60, unite: 'g' },
  { match: 'Boeuf', quantite: 60, unite: 'g', exact: true },
  { match: 'Tofu nature', quantite: 120, unite: 'g' },
  { match: 'Crevettes', quantite: 67, unite: 'g' },
  { match: 'Oeufs entiers liquide', quantite: 50, unite: 'g' },
  { match: 'Boulettes boeuf halal', quantite: 2, unite: 'unite' },
  { match: 'Echine de porc', quantite: 90, unite: 'g' },
  // Légumes / garnitures
  { match: 'Pousses de Soja', quantite: 40, unite: 'g' },
  { match: 'Poivron rouge', quantite: 20, unite: 'g' },
  { match: 'Oignons Jaunes', quantite: 20, unite: 'g' },
  // Herbes / condiments
  { match: 'Coriandre', quantite: 10, unite: 'g' },
  { match: 'Ciboulette', quantite: 10, unite: 'g' },
  { match: 'Menthe', quantite: 10, unite: 'g' },
  { match: 'Citron vert', quantite: 20, unite: 'g' },
  { match: 'Cacahuetes', quantite: 10, unite: 'g' },
  { match: 'Oignons frits', quantite: 5, unite: 'g' },
  { match: 'Piment entier', quantite: 5, unite: 'g' },
  { match: 'Poudre 5 epices', quantite: 1, unite: 'g' },
  // Nems
  { match: 'Nem poulet', quantite: 4, unite: 'unite' },
  { match: 'Nem legumes', quantite: 2, unite: 'unite' },
  // Sauces
  { match: 'Sauce soja base', quantite: 10, unite: 'mL' },
  { match: 'Sauce Nuoc Mam', quantite: 10, unite: 'mL' },
  // Chicken wings (sous-recette, qty = portions)
  { match: 'Chicken Wings', quantite: 1, unite: 'unite' },
];

function normalize(s) {
  return s.toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').trim();
}

async function main() {
  console.log(dryRun ? '=== DRY RUN ===' : '=== LIVE MODE ===');

  const { data: ingredients, error } = await c.from('ingredients_restaurant')
    .select('id, nom, unite_stock, quantite_extra')
    .eq('actif', true);

  if (error) {
    console.error('Error fetching ingredients:', error.message);
    return;
  }

  console.log(`Found ${ingredients.length} active ingredients`);
  let matched = 0;
  let skipped = 0;

  for (const def of EXTRA_DEFAULTS) {
    const defNorm = normalize(def.match);
    let ing;
    if (def.exact) {
      // Exact match only (for ambiguous names like "boeuf")
      ing = ingredients.find(i => normalize(i.nom) === defNorm);
    } else {
      // Prefer exact, then includes
      ing = ingredients.find(i => normalize(i.nom) === defNorm)
        || ingredients.find(i => normalize(i.nom).includes(defNorm))
        || ingredients.find(i => defNorm.includes(normalize(i.nom)));
    }

    if (!ing) {
      console.log(`  SKIP: "${def.match}" - no matching ingredient found`);
      skipped++;
      continue;
    }

    if (ing.quantite_extra != null) {
      console.log(`  KEEP: ${ing.nom} already has quantite_extra=${ing.quantite_extra}`);
      continue;
    }

    console.log(`  SET: ${ing.nom} -> quantite_extra=${def.quantite} ${def.unite}`);
    matched++;

    if (!dryRun) {
      const { error: patchErr } = await c.from('ingredients_restaurant')
        .update({ quantite_extra: def.quantite, unite_extra: def.unite })
        .eq('id', ing.id);
      if (patchErr) console.log(`    ERROR: ${patchErr.message}`);
      else console.log('    OK');
    }
  }

  console.log(`\nSummary: ${matched} to set, ${skipped} not found`);
  if (dryRun) console.log('Run with --live to apply changes');
}

main().catch(console.error);
