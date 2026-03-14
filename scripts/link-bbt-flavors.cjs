#!/usr/bin/env node
/**
 * Link BBT Fruity flavor options to their sirop ingredients.
 * Data from inpulse: each flavor = BBT Fruity Base + X mL of sirop.
 *
 * Usage: node scripts/link-bbt-flavors.cjs [--dry-run|--live]
 */
const fs = require('fs');
const env = fs.readFileSync(__dirname + '/../.env', 'utf8');
const url = env.match(/VITE_SUPABASE_URL=(.+)/)[1].trim();
const skey = (env.match(/SUPABASE_SERVICE_ROLE_KEY=(.+)/) || [])[1]?.trim();

const dryRun = !process.argv.includes('--live');

// Mapping: option name -> { sirop ingredient name (exact match), quantite, unite }
// From inpulse BBT sous-recettes
const FLAVOR_MAP = [
  // === BBT Fruity flavors ===
  { option: 'Fraise', sirop: 'Sirop fraise', quantite: 24, unite: 'mL' },
  { option: 'Passion', sirop: 'Sirop passion', quantite: 24, unite: 'mL' },
  { option: 'Grenade', sirop: 'Sirop grenade', quantite: 24, unite: 'mL' },
  { option: 'Hibiscus', sirop: 'Sirop hibiscus', quantite: 24, unite: 'mL' },
  { option: 'Pêche Blanche', sirop: 'Sirop peche', quantite: 24, unite: 'mL' },
  { option: 'Yuzu / Citron', sirop: 'Sirop yuzu / citron', quantite: 32, unite: 'mL' },
  { option: 'Concombre', sirop: 'Concombre', quantite: 20, unite: 'g' },
  { option: 'Chamallow Grillé', sirop: null, quantite: 0, unite: 'g' },  // nouveau parfum, pas dans inpulse
  // === BBT Milky flavors ===
  { option: 'Original', sirop: 'Sirop de canne', quantite: 10, unite: 'mL' },
  { option: 'Taro', sirop: 'Poudre Taro', quantite: 30, unite: 'g' },
  { option: 'Lait Thai', sirop: 'Poudre thé au lait thai', quantite: 32, unite: 'g' },
];

async function apiFetch(path, opts = {}) {
  const r = await fetch(url + '/rest/v1/' + path, {
    ...opts,
    headers: {
      apikey: skey,
      Authorization: 'Bearer ' + skey,
      'Content-Type': 'application/json',
      ...(opts.headers || {}),
    },
  });
  return r.json();
}

async function main() {
  console.log(dryRun ? '=== DRY RUN ===' : '=== LIVE MODE ===');

  // 1. Get all BBT Fruity recipes (main + milky)
  const recettes = await apiFetch('recettes?or=(nom.ilike.*bubble*tea*fruity*,nom.ilike.*bubble*tea*milky*)&type=eq.recette&actif=eq.true&select=id,nom,options');
  console.log(`Found ${recettes.length} BBT recettes:`);
  for (const r of recettes) {
    console.log(`  ${r.nom} — ${(r.options || []).length} options`);
  }

  // 2. Get sirop ingredients
  const ingredients = await apiFetch('ingredients_restaurant?actif=eq.true&select=id,nom,unite_stock');
  const ingMap = {};
  for (const i of ingredients) {
    ingMap[i.nom.toLowerCase().trim()] = i;
  }
  // Build reverse lookup for FLAVOR_MAP sirops
  const neededSirops = FLAVOR_MAP.filter(m => m.sirop).map(m => m.sirop);
  const foundSirops = neededSirops.filter(s => ingMap[s.toLowerCase().trim()]);
  console.log(`\nIngredients loaded: ${ingredients.length}, needed sirops found: ${foundSirops.length}/${neededSirops.length}`);

  // 3. Process each recipe
  let totalLinked = 0;
  for (const recette of recettes) {
    if (!recette.options || recette.options.length === 0) continue;

    let modified = false;
    for (const opt of recette.options) {
      // Only process choix options without existing ingredient link
      if (opt.type !== 'choix') continue;

      const mapping = FLAVOR_MAP.find(m => m.option === opt.nom);
      if (!mapping) {
        console.log(`  ${recette.nom} > ${opt.nom}: pas de mapping connu`);
        continue;
      }
      if (!mapping.sirop) {
        console.log(`  ${recette.nom} > ${opt.nom}: pas d'ingrédient dans inpulse (skip)`);
        continue;
      }

      // Already linked?
      if (opt.impact_stock && opt.impact_stock.length > 0 && opt.impact_stock[0]) {
        console.log(`  ${recette.nom} > ${opt.nom}: déjà lié (skip)`);
        continue;
      }

      // Find ingredient
      const ing = ingMap[mapping.sirop.toLowerCase()];
      if (!ing) {
        console.log(`  ${recette.nom} > ${opt.nom}: ingrédient "${mapping.sirop}" non trouvé !`);
        continue;
      }

      console.log(`  ${recette.nom} > ${opt.nom} → ${ing.nom} ${mapping.quantite}${mapping.unite}`);
      opt.impact_stock = [{
        ingredient_restaurant_id: ing.id,
        quantite: mapping.quantite,
        unite: mapping.unite,
      }];
      modified = true;
      totalLinked++;
    }

    if (modified && !dryRun) {
      const r = await fetch(url + '/rest/v1/recettes?id=eq.' + recette.id, {
        method: 'PATCH',
        headers: {
          apikey: skey,
          Authorization: 'Bearer ' + skey,
          'Content-Type': 'application/json',
          Prefer: 'return=minimal',
        },
        body: JSON.stringify({ options: recette.options }),
      });
      console.log('    -> saved (' + r.status + ')');
    }
  }

  console.log(`\nTotal linked: ${totalLinked}`);
  if (dryRun) console.log('Run with --live to apply');
}

main().catch(console.error);
