#!/usr/bin/env node
/**
 * Fix recipe ingredient quantities that were imported with normalized units
 * but unconverted quantities.
 *
 * The migrate-inpulse.ts script mapped g→kg, mL→L, cl→L for the unit field
 * but left the quantity as-is from inpulse. This script fixes that.
 *
 * Example: 19g was stored as 19 kg → should be 0.019 kg
 *
 * Usage: node scripts/fix-recipe-quantities.cjs [--dry-run]
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
  console.log('=== Fix Recipe Ingredient Quantities ===')
  console.log(DRY_RUN ? '>>> DRY RUN <<<' : '>>> LIVE MODE <<<')
  console.log('')

  // 1. Read inpulse export to get original units for each ingredient & recipe
  console.log('Reading inpulse export...')
  const raw = fs.readFileSync(INPULSE_FILE, 'utf-8')
  const data = JSON.parse(raw)

  // Build map: ingredient ID → original unit
  const ingredientUnitMap = {}
  for (const ing of data.ingredients) {
    ingredientUnitMap[ing.id] = ing.unit // 'g', 'mL', 'unit', 'kg', etc.
  }

  // Build map: recipe ID → original unit
  const recipeUnitMap = {}
  for (const r of data.recipes) {
    recipeUnitMap[r.id] = r.unit
  }

  // Build map of mapping ID → { childEntityQuantity, childUnit }
  // The childUnit comes from the mapping's lnkEntityEntitymappingrel.unit
  const mappingMap = {}
  for (const r of data.recipes) {
    for (const m of r.mappings) {
      const childUnit = m.lnkEntityEntitymappingrel?.unit || 'unit'
      mappingMap[m.id] = {
        quantity: m.childEntityQuantity,
        originalUnit: childUnit,
      }
    }
  }

  // Conversion factors: original unit → normalized unit
  // g → kg: divide by 1000
  // mL/ml → L: divide by 1000
  // cl → L: divide by 100
  function getConversionFactor(originalUnit) {
    const map = { 'g': 0.001, 'mL': 0.001, 'ml': 0.001, 'cl': 0.01 }
    return map[originalUnit] || 1
  }

  function normalizeUnit(unit) {
    const map = { 'g': 'kg', 'mL': 'L', 'ml': 'L', 'cl': 'L', 'unit': 'unite', 'pcs': 'unite', 'kg': 'kg', 'L': 'L', 'l': 'L', 'piece': 'piece', 'botte': 'botte' }
    return map[unit] || 'unite'
  }

  // 2. Fetch all recette_ingredients from Supabase
  console.log('Fetching recette_ingredients...')
  const { data: recetteIngs, error: riErr } = await supabase
    .from('recette_ingredients')
    .select('id, recette_id, ingredient_id, sous_recette_id, quantite, unite')
  if (riErr) throw riErr
  console.log(`  ${recetteIngs.length} recette_ingredients found`)

  // 3. Check each one and fix if needed
  let fixCount = 0
  let skipCount = 0
  let noMatchCount = 0
  const fixes = []

  for (const ri of recetteIngs) {
    // Try to find this mapping in inpulse data
    const mapping = mappingMap[ri.id]

    if (mapping) {
      // We have the original mapping data
      const factor = getConversionFactor(mapping.originalUnit)
      const expectedUnit = normalizeUnit(mapping.originalUnit)

      if (factor !== 1 && ri.unite === expectedUnit) {
        // Quantity needs conversion
        const correctQty = Math.round(mapping.quantity * factor * 10000) / 10000
        if (Math.abs(ri.quantite - correctQty) > 0.0001) {
          fixes.push({
            id: ri.id,
            oldQty: ri.quantite,
            newQty: correctQty,
            unite: ri.unite,
            originalUnit: mapping.originalUnit,
            originalQty: mapping.quantity,
          })
          fixCount++
        } else {
          skipCount++ // Already correct
        }
      } else {
        skipCount++ // No conversion needed (unit is already 'unite', 'kg', etc.)
      }
    } else {
      // No mapping in inpulse (could be manually created)
      // Try to infer from ingredient original unit
      const childId = ri.ingredient_id || ri.sous_recette_id
      const originalUnit = ingredientUnitMap[childId] || recipeUnitMap[childId]

      if (originalUnit) {
        const factor = getConversionFactor(originalUnit)
        const expectedUnit = normalizeUnit(originalUnit)

        if (factor !== 1 && ri.unite === expectedUnit) {
          // The quantity was likely not converted
          const correctQty = Math.round(ri.quantite * factor * 10000) / 10000
          fixes.push({
            id: ri.id,
            oldQty: ri.quantite,
            newQty: correctQty,
            unite: ri.unite,
            originalUnit: originalUnit,
            originalQty: ri.quantite,
          })
          fixCount++
        } else {
          skipCount++
        }
      } else {
        noMatchCount++
      }
    }
  }

  console.log('')
  console.log(`Analysis:`)
  console.log(`  ${fixCount} quantities to fix`)
  console.log(`  ${skipCount} already correct or no conversion needed`)
  console.log(`  ${noMatchCount} no match in inpulse data`)
  console.log('')

  // Show samples
  if (fixes.length > 0) {
    console.log('Sample fixes (first 20):')
    for (const f of fixes.slice(0, 20)) {
      console.log(`  ${f.originalQty} ${f.originalUnit} → ${f.oldQty} ${f.unite} (stored) → ${f.newQty} ${f.unite} (corrected)`)
    }
    console.log('')
  }

  // 4. Apply fixes
  if (!DRY_RUN && fixes.length > 0) {
    console.log('Applying fixes...')
    let applied = 0
    let errors = 0

    for (const f of fixes) {
      const { error: updateErr } = await supabase
        .from('recette_ingredients')
        .update({ quantite: f.newQty })
        .eq('id', f.id)
      if (updateErr) {
        console.error(`  Error updating ${f.id}:`, updateErr.message)
        errors++
      } else {
        applied++
      }
    }
    console.log(`  ${applied} fixed, ${errors} errors`)
  }

  // 5. Also fix ingredient cout_unitaire if cost was not converted properly
  // (migrate-inpulse.ts stored ing.cost directly without conversion)
  // inpulse cost is actually per base unit (kg/L), so this should be correct
  // But let's verify a few
  console.log('')
  console.log('Verifying ingredient costs...')
  const { data: ingredients, error: ingErr } = await supabase
    .from('ingredients_restaurant')
    .select('id, nom, cout_unitaire, unite_stock')
    .order('nom')
  if (ingErr) throw ingErr

  let costIssues = 0
  for (const dbIng of ingredients) {
    const inpIng = data.ingredients.find(i => i.id === dbIng.id)
    if (!inpIng) continue

    // inpulse cost is per base unit (kg, L, unit)
    // If unite_stock matches the base unit, cost should be correct
    const expectedCost = inpIng.cost || 0
    if (Math.abs(dbIng.cout_unitaire - expectedCost) > 0.01) {
      if (costIssues < 10) {
        console.log(`  Cost mismatch: ${dbIng.nom} — DB: ${dbIng.cout_unitaire} ${dbIng.unite_stock}, inpulse: ${expectedCost} (unit: ${inpIng.unit})`)
      }
      costIssues++
    }
  }
  if (costIssues === 0) {
    console.log('  All ingredient costs match inpulse data.')
  } else {
    console.log(`  ${costIssues} cost mismatches found`)
  }

  console.log('')
  console.log('=== Done ===')
}

main().catch(err => {
  console.error('Fatal error:', err)
  process.exit(1)
})
