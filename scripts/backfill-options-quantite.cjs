#!/usr/bin/env node
/**
 * Backfill existing option impact_stock quantities from ingredient quantite_extra.
 * Fixes options that were linked before quantite_extra was added (stuck at qty 0).
 *
 * Usage: node scripts/backfill-options-quantite.cjs [--dry-run|--live]
 */
const { createClient } = require('@supabase/supabase-js');
const fs = require('fs');
const env = fs.readFileSync(__dirname + '/../.env', 'utf8');
const url = env.match(/VITE_SUPABASE_URL=(.+)/)[1].trim();
const skey = (env.match(/SUPABASE_SERVICE_ROLE_KEY=(.+)/) || [])[1]?.trim();
const c = createClient(url, skey);

const dryRun = !process.argv.includes('--live');

async function main() {
  console.log(dryRun ? '=== DRY RUN ===' : '=== LIVE MODE ===');

  // Fetch all ingredients with quantite_extra
  const { data: ingredients } = await c.from('ingredients_restaurant')
    .select('id, nom, quantite_extra, unite_extra, unite_stock')
    .not('quantite_extra', 'is', null);

  const ingMap = new Map(ingredients.map(i => [i.id, i]));
  console.log(`${ingredients.length} ingredients with quantite_extra configured`);

  // Fetch all recettes with options
  const { data: recettes } = await c.from('recettes')
    .select('id, nom, options')
    .not('options', 'is', null);

  console.log(`${recettes.length} recettes with options`);

  let totalFixed = 0;

  for (const recette of recettes) {
    if (!recette.options || recette.options.length === 0) continue;

    let modified = false;
    for (const opt of recette.options) {
      if (opt.type !== 'extra') continue;
      if (!opt.impact_stock || opt.impact_stock.length === 0) continue;

      const stock = opt.impact_stock[0];
      if (stock.quantite > 0) continue; // Already has a quantity

      const ing = ingMap.get(stock.ingredient_restaurant_id);
      if (!ing || !ing.quantite_extra) continue;

      console.log(`  ${recette.nom} > ${opt.nom}: 0 -> ${ing.quantite_extra} ${ing.unite_extra || ing.unite_stock}`);
      stock.quantite = ing.quantite_extra;
      stock.unite = ing.unite_extra || ing.unite_stock;
      modified = true;
      totalFixed++;
    }

    if (modified && !dryRun) {
      const { error } = await c.from('recettes')
        .update({ options: recette.options })
        .eq('id', recette.id);
      if (error) console.log(`    ERROR: ${error.message}`);
      else console.log('    -> saved');
    }
  }

  console.log(`\nTotal fixed: ${totalFixed}`);
  if (dryRun) console.log('Run with --live to apply');
}

main().catch(console.error);
