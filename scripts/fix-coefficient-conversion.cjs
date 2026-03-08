#!/usr/bin/env node
/**
 * Fix coefficient_conversion in mercuriale table
 *
 * The original inpulse import set coefficient_conversion = 1 for ALL products.
 * It should reflect the quantity in the order packaging (e.g., 24 for "24 canettes").
 *
 * Usage:
 *   node scripts/fix-coefficient-conversion.cjs --dry-run
 *   node scripts/fix-coefficient-conversion.cjs --live
 */

const { createClient } = require('@supabase/supabase-js')
const path = require('path')

const DRY_RUN = process.argv.includes('--dry-run')
const LIVE = process.argv.includes('--live')

if (!DRY_RUN && !LIVE) {
  console.log('Usage: node scripts/fix-coefficient-conversion.cjs --dry-run|--live')
  process.exit(1)
}

const supabase = createClient(
  'https://pfcvtpavwjchwdarhixc.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'
)

async function main() {
  console.log(`Mode: ${DRY_RUN ? 'DRY RUN' : 'LIVE'}`)
  console.log('---')

  // Load inpulse export
  const inpulse = require(path.resolve(__dirname, '../inpulse_export_phood_actifs.json'))
  console.log(`Loaded ${inpulse.ingredients.length} ingredients from inpulse export`)

  // Build map: supplierProduct ID → order packaging quantity
  const spCoefficients = new Map()
  let totalSps = 0

  for (const ing of inpulse.ingredients) {
    if (!ing.supplierProducts) continue
    const sps = Array.isArray(ing.supplierProducts) ? ing.supplierProducts : [ing.supplierProducts]
    for (const sp of sps) {
      totalSps++
      if (!sp.packagings || sp.packagings.length === 0) continue

      // Find the order packaging (isUsedInOrder = true)
      const orderPkg = sp.packagings.find(p => p.isUsedInOrder)
      if (orderPkg && orderPkg.quantity && orderPkg.quantity > 1) {
        spCoefficients.set(sp.id, {
          name: sp.name,
          quantity: orderPkg.quantity,
          pkgName: orderPkg.name,
        })
      }
    }
  }

  console.log(`Found ${spCoefficients.size} supplier products with coefficient > 1 (out of ${totalSps} total)`)
  console.log('---')

  // Fetch current mercuriale
  const { data: mercuriale, error: err } = await supabase
    .from('mercuriale')
    .select('id, designation, coefficient_conversion, conditionnements')
  if (err) { console.error('Error fetching mercuriale:', err); process.exit(1) }

  console.log(`Loaded ${mercuriale.length} mercuriale records from Supabase`)

  const fixes = []

  for (const merc of mercuriale) {
    // Strategy 1: Match by inpulse supplier product ID
    const spData = spCoefficients.get(merc.id)
    if (spData && merc.coefficient_conversion !== spData.quantity) {
      fixes.push({
        id: merc.id,
        designation: merc.designation,
        oldCoeff: merc.coefficient_conversion,
        newCoeff: spData.quantity,
        source: `inpulse: ${spData.pkgName}`,
      })
      continue
    }

    // Strategy 2: If no inpulse match, check conditionnements JSONB
    if (merc.coefficient_conversion === 1 && merc.conditionnements) {
      const conds = Array.isArray(merc.conditionnements) ? merc.conditionnements : []
      const orderCond = conds.find(c => c.utilise_commande)
      if (orderCond && orderCond.quantite && orderCond.quantite > 1) {
        fixes.push({
          id: merc.id,
          designation: merc.designation,
          oldCoeff: 1,
          newCoeff: orderCond.quantite,
          source: `conditionnement: ${orderCond.nom}`,
        })
      }
    }
  }

  console.log(`\n${fixes.length} products need coefficient_conversion update:`)
  console.log('---')

  // Show first 20 for review
  for (const fix of fixes.slice(0, 20)) {
    console.log(`  ${fix.designation}: ${fix.oldCoeff} → ${fix.newCoeff} (${fix.source})`)
  }
  if (fixes.length > 20) {
    console.log(`  ... and ${fixes.length - 20} more`)
  }

  if (DRY_RUN) {
    console.log('\n[DRY RUN] No changes applied. Use --live to apply.')
    return
  }

  // Apply fixes
  let success = 0
  let errors = 0

  for (const fix of fixes) {
    const { error: updateErr } = await supabase
      .from('mercuriale')
      .update({ coefficient_conversion: fix.newCoeff })
      .eq('id', fix.id)

    if (updateErr) {
      console.error(`  ERROR updating ${fix.designation}:`, updateErr.message)
      errors++
    } else {
      success++
    }
  }

  console.log(`\nDone: ${success} updated, ${errors} errors`)
}

main().catch(console.error)
