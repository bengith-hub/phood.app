#!/usr/bin/env node
/**
 * Revert ingredient units to their original inpulse values (g, mL, cl instead of kg, L).
 *
 * Updates:
 *   1. ingredients_restaurant.unite_stock + cout_unitaire
 *   2. mercuriale.unite_stock
 *   3. recette_ingredients.quantite + unite
 *
 * Usage: node scripts/revert-original-units.cjs [--dry-run]
 */

const fs = require('fs')
const path = require('path')
const { createClient } = require('@supabase/supabase-js')

const SUPABASE_URL = 'https://pfcvtpavwjchwdarhixc.supabase.co'
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
  || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'

const INPULSE_FILE = path.resolve(
  __dirname,
  '../../Library/CloudStorage/GoogleDrive-benjamin.fetu@phood-restaurant.fr/My Drive/Projet/PhoodApp/inpulse_export_phood_actifs.json'
)

const DRY_RUN = process.argv.includes('--dry-run')

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)

async function main() {
  console.log('=== Revert to Original Inpulse Units ===')
  console.log(DRY_RUN ? '>>> DRY RUN <<<' : '>>> LIVE MODE <<<')
  console.log('')

  // 1. Read inpulse export
  console.log('Reading inpulse export...')
  const raw = fs.readFileSync(INPULSE_FILE, 'utf-8')
  const data = JSON.parse(raw)

  // Build map: ingredient ID → original unit
  const ingredientOriginalUnit = {}
  for (const ing of data.ingredients) {
    ingredientOriginalUnit[ing.id] = ing.unit // 'g', 'mL', 'unit', 'kg', etc.
  }

  // Build map: recipe ID → original unit
  const recipeOriginalUnit = {}
  for (const r of data.recipes) {
    recipeOriginalUnit[r.id] = r.unit
  }

  // Build map: mapping ID → original data
  const mappingOriginal = {}
  for (const r of data.recipes) {
    for (const m of r.mappings) {
      mappingOriginal[m.id] = {
        quantity: m.childEntityQuantity,
        unit: m.lnkEntityEntitymappingrel?.unit || 'unit',
      }
    }
  }

  // Conversion: original unit → factor to convert cost FROM kg/L back TO original
  // cost_per_kg * 0.001 = cost_per_g
  function costConvFactor(originalUnit) {
    const map = { 'g': 0.001, 'mL': 0.001, 'ml': 0.001, 'cl': 0.01 }
    return map[originalUnit] || 1
  }

  // Treat 'unite' and 'unit' as equivalent
  function unitsEquivalent(a, b) {
    if (a === b) return true
    if ((a === 'unite' && b === 'unit') || (a === 'unit' && b === 'unite')) return true
    return false
  }

  // ═══════════════════════════════════════════════════════════
  // 2. Fix ingredients_restaurant
  // ═══════════════════════════════════════════════════════════
  console.log('\n--- ingredients_restaurant ---')
  const { data: dbIngs, error: ingErr } = await supabase
    .from('ingredients_restaurant')
    .select('id, nom, unite_stock, cout_unitaire')
  if (ingErr) throw ingErr

  let ingFixed = 0
  let ingSkipped = 0
  const ingUpdates = []

  for (const dbIng of dbIngs) {
    const originalUnit = ingredientOriginalUnit[dbIng.id]
    if (!originalUnit) { ingSkipped++; continue }

    // Only fix if the unit was normalized (g→kg, mL→L, cl→L)
    const needsFix =
      (originalUnit === 'g' && dbIng.unite_stock === 'kg') ||
      (originalUnit === 'mL' && dbIng.unite_stock === 'L') ||
      (originalUnit === 'ml' && dbIng.unite_stock === 'L') ||
      (originalUnit === 'cl' && dbIng.unite_stock === 'L')

    if (!needsFix) { ingSkipped++; continue }

    const factor = costConvFactor(originalUnit)
    const newCost = Math.round(dbIng.cout_unitaire * factor * 1000000) / 1000000

    ingUpdates.push({
      id: dbIng.id,
      nom: dbIng.nom,
      oldUnit: dbIng.unite_stock,
      newUnit: originalUnit,
      oldCost: dbIng.cout_unitaire,
      newCost: newCost,
    })
    ingFixed++
  }

  console.log(`  ${ingFixed} to fix, ${ingSkipped} already OK or not in inpulse`)
  if (ingUpdates.length > 0) {
    console.log('  Samples:')
    for (const u of ingUpdates.slice(0, 5)) {
      console.log(`    ${u.nom}: ${u.oldUnit}→${u.newUnit}, cost ${u.oldCost}→${u.newCost}`)
    }
  }

  if (!DRY_RUN && ingUpdates.length > 0) {
    console.log('  Applying...')
    let ok = 0, err = 0
    for (const u of ingUpdates) {
      const { error } = await supabase
        .from('ingredients_restaurant')
        .update({ unite_stock: u.newUnit, cout_unitaire: u.newCost })
        .eq('id', u.id)
      if (error) { console.error(`    Error ${u.nom}:`, error.message); err++ }
      else ok++
    }
    console.log(`  ${ok} fixed, ${err} errors`)
  }

  // ═══════════════════════════════════════════════════════════
  // 3. Fix mercuriale
  // ═══════════════════════════════════════════════════════════
  console.log('\n--- mercuriale ---')
  const { data: dbMerc, error: mercErr } = await supabase
    .from('mercuriale')
    .select('id, designation, unite_stock, ingredient_restaurant_id')
  if (mercErr) throw mercErr

  let mercFixed = 0
  let mercSkipped = 0
  const mercUpdates = []

  for (const m of dbMerc) {
    const originalUnit = ingredientOriginalUnit[m.ingredient_restaurant_id]
    if (!originalUnit) { mercSkipped++; continue }

    const needsFix =
      (originalUnit === 'g' && m.unite_stock === 'kg') ||
      (originalUnit === 'mL' && m.unite_stock === 'L') ||
      (originalUnit === 'ml' && m.unite_stock === 'L') ||
      (originalUnit === 'cl' && m.unite_stock === 'L')

    if (!needsFix) { mercSkipped++; continue }

    mercUpdates.push({
      id: m.id,
      designation: m.designation,
      oldUnit: m.unite_stock,
      newUnit: originalUnit,
    })
    mercFixed++
  }

  console.log(`  ${mercFixed} to fix, ${mercSkipped} already OK or not in inpulse`)

  if (!DRY_RUN && mercUpdates.length > 0) {
    console.log('  Applying...')
    let ok = 0, err = 0
    for (const u of mercUpdates) {
      const { error } = await supabase
        .from('mercuriale')
        .update({ unite_stock: u.newUnit })
        .eq('id', u.id)
      if (error) { console.error(`    Error ${u.designation}:`, error.message); err++ }
      else ok++
    }
    console.log(`  ${ok} fixed, ${err} errors`)
  }

  // ═══════════════════════════════════════════════════════════
  // 4. Fix recette_ingredients
  // ═══════════════════════════════════════════════════════════
  console.log('\n--- recette_ingredients ---')
  const { data: dbRI, error: riErr } = await supabase
    .from('recette_ingredients')
    .select('id, ingredient_id, sous_recette_id, quantite, unite')
  if (riErr) throw riErr

  let riFixed = 0
  let riSkipped = 0
  const riUpdates = []

  for (const ri of dbRI) {
    // Try mapping-level data first (most accurate)
    const mapping = mappingOriginal[ri.id]

    if (mapping) {
      // We have exact original data from inpulse
      const originalUnit = mapping.unit
      const originalQty = mapping.quantity

      // Check if quantity or unit actually differs (treating unite/unit as equivalent)
      const qtyDiffers = Math.abs(ri.quantite - originalQty) > 0.00001
      const unitDiffers = !unitsEquivalent(ri.unite, originalUnit)

      if (qtyDiffers || unitDiffers) {
        riUpdates.push({
          id: ri.id,
          oldQty: ri.quantite,
          oldUnit: ri.unite,
          newQty: originalQty,
          newUnit: originalUnit,
        })
        riFixed++
      } else {
        riSkipped++
      }
    } else {
      // No mapping match — try by ingredient original unit
      const childId = ri.ingredient_id || ri.sous_recette_id
      const originalUnit = ingredientOriginalUnit[childId] || recipeOriginalUnit[childId]

      if (!originalUnit || unitsEquivalent(originalUnit, ri.unite)) {
        riSkipped++
        continue
      }

      // Need to revert unit and quantity
      let factor = 1
      if ((originalUnit === 'g' && ri.unite === 'kg') ||
          (originalUnit === 'mL' && ri.unite === 'L') ||
          (originalUnit === 'ml' && ri.unite === 'L')) {
        factor = 1000
      } else if (originalUnit === 'cl' && ri.unite === 'L') {
        factor = 100
      }

      if (factor !== 1) {
        const newQty = Math.round(ri.quantite * factor * 10000) / 10000
        riUpdates.push({
          id: ri.id,
          oldQty: ri.quantite,
          oldUnit: ri.unite,
          newQty: newQty,
          newUnit: originalUnit,
        })
        riFixed++
      } else {
        riSkipped++
      }
    }
  }

  console.log(`  ${riFixed} to fix, ${riSkipped} already OK or not in inpulse`)
  if (riUpdates.length > 0) {
    console.log('  Samples:')
    for (const u of riUpdates.slice(0, 10)) {
      console.log(`    ${u.oldQty} ${u.oldUnit} → ${u.newQty} ${u.newUnit}`)
    }
  }

  if (!DRY_RUN && riUpdates.length > 0) {
    console.log('  Applying...')
    let ok = 0, err = 0
    for (const u of riUpdates) {
      const { error } = await supabase
        .from('recette_ingredients')
        .update({ quantite: u.newQty, unite: u.newUnit })
        .eq('id', u.id)
      if (error) { console.error(`    Error ${u.id}:`, error.message); err++ }
      else ok++
    }
    console.log(`  ${ok} fixed, ${err} errors`)
  }

  console.log('\n=== Done ===')
}

main().catch(err => {
  console.error('Fatal error:', err)
  process.exit(1)
})
