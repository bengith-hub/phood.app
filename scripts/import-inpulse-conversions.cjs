#!/usr/bin/env node
/**
 * Import conversion data from inpulse export into mercuriale.
 *
 * Reads `conversions[]` from inpulse supplier products and populates
 * `conversion_quantite` and `conversion_unite` on matching mercuriale rows.
 *
 * Inpulse conversions come in pairs, e.g.:
 *   [{ convertedUnit: "kg", convertedQuantity: 5 }, { convertedUnit: "unit", convertedQuantity: 1000 }]
 *   → means "5 kg = 1000 unit"
 *
 * We need to figure out which conversion entry corresponds to the colis dimension
 * (matching coefficient_conversion) and which is the target conversion.
 *
 * Usage:
 *   node scripts/import-inpulse-conversions.cjs --dry-run
 *   node scripts/import-inpulse-conversions.cjs --live
 */
const fs = require('fs')
const { createClient } = require('@supabase/supabase-js')

const DRY_RUN = process.argv.includes('--dry-run')
const LIVE = process.argv.includes('--live')
if (!DRY_RUN && !LIVE) {
  console.log('Usage: node scripts/import-inpulse-conversions.cjs --dry-run|--live')
  process.exit(1)
}

const supabase = createClient(
  'https://pfcvtpavwjchwdarhixc.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'
)

// Normalize unit name to PhoodApp conventions
function normalizeUnit(u) {
  const lower = (u || '').toLowerCase().trim()
  if (lower === 'unit' || lower === 'unité' || lower === 'unités' || lower === 'unite' || lower === 'pce' || lower === 'piece') return 'unite'
  if (lower === 'kg') return 'kg'
  if (lower === 'g') return 'g'
  if (lower === 'l' || lower === 'litre') return 'L'
  if (lower === 'ml') return 'mL'
  if (lower === 'cl') return 'cl'
  return lower
}

function isWeightVolume(u) {
  return ['kg', 'g', 'l', 'ml', 'cl'].includes((u || '').toLowerCase())
}

async function main() {
  console.log(`Mode: ${DRY_RUN ? 'DRY RUN' : 'LIVE'}`)
  console.log('---')

  // 1. Load inpulse export
  const exportPath = '/Users/ben/Library/CloudStorage/GoogleDrive-benjamin.fetu@phood-restaurant.fr/My Drive/Projet/PhoodApp/inpulse_export_phood_actifs.json'
  const raw = fs.readFileSync(exportPath, 'utf-8')
  const data = JSON.parse(raw)

  // Collect all supplier products with conversions
  const ingredients = data.ingredients || data
  const withConversions = []
  for (const ing of (Array.isArray(ingredients) ? ingredients : Object.values(ingredients))) {
    for (const sp of (ing.supplierProducts || [])) {
      if (sp.conversions && sp.conversions.length > 0) {
        withConversions.push({
          inpulseIngredient: ing.name,
          inpulseIngredientUnit: ing.unit,
          sku: sp.sku,
          name: sp.name,
          supplierId: sp.supplierId,
          supplierName: sp.supplierName,
          packagingUnit: sp.packagingUnit,
          packagingValue: sp.packagingValue,
          conversions: sp.conversions,
        })
      }
    }
  }

  console.log(`Found ${withConversions.length} inpulse products with conversion data\n`)

  // 2. Fetch all mercuriale products + linked ingredients
  const { data: mercuriale, error: mercErr } = await supabase
    .from('mercuriale')
    .select('id, designation, ref_fournisseur, coefficient_conversion, unite_facturation, unite_commande, conversion_quantite, conversion_unite, fournisseur_id, ingredient_restaurant_id')

  const { data: ingredientsDB } = await supabase
    .from('ingredients_restaurant')
    .select('id, nom, unite_stock')
  const ingMap = new Map()
  for (const ing of (ingredientsDB || [])) {
    ingMap.set(ing.id, ing)
  }

  if (mercErr) {
    console.error('Error fetching mercuriale:', mercErr.message)
    process.exit(1)
  }

  // Build lookup by SKU
  const bySku = new Map()
  for (const m of mercuriale) {
    if (m.ref_fournisseur) {
      bySku.set(m.ref_fournisseur.trim(), m)
    }
  }

  // Build lookup by designation (normalized)
  const byName = new Map()
  for (const m of mercuriale) {
    byName.set(m.designation.toLowerCase().trim(), m)
  }

  let matched = 0
  let updated = 0
  let skipped = 0
  let alreadySet = 0

  for (const sp of withConversions) {
    // Try to match by SKU first, then by designation
    let merc = sp.sku ? bySku.get(sp.sku.trim()) : null
    if (!merc) {
      merc = byName.get(sp.name.toLowerCase().trim())
    }

    if (!merc) {
      console.log(`  SKIP (no match): ${sp.name} [SKU: ${sp.sku}]`)
      skipped++
      continue
    }

    matched++

    // Already has conversion data?
    if (merc.conversion_quantite && merc.conversion_unite) {
      console.log(`  ALREADY SET: ${merc.designation} → ${merc.conversion_quantite} ${merc.conversion_unite}`)
      alreadySet++
      continue
    }

    // Parse conversions — inpulse gives pairs: e.g. [5 kg, 1000 unite]
    // We need: conversion_quantite = total ingredient units in one COLIS
    // COLIS = coefficient_conversion × unite_facturation
    // E.g. Sucre dose: colis = 5 kg, inpulse says 5 kg = 1000 unite → store 1000 unite
    const convs = sp.conversions
    if (convs.length < 2) {
      console.log(`  SKIP (only 1 conversion): ${sp.name}`)
      skipped++
      continue
    }

    // Determine facturation unit
    const uf = normalizeUnit(merc.unite_facturation || merc.unite_commande || sp.packagingUnit || '')
    const isUfWeight = isWeightVolume(uf)
    const coeff = merc.coefficient_conversion || 1

    // sourceConv = entry in same dimension as facturation (the "colis side")
    // targetConv = entry in the other dimension (the "stock/ingredient side")
    let sourceConv = null
    let targetConv = null

    for (const c of convs) {
      const cu = normalizeUnit(c.convertedUnit)
      const isCWeight = isWeightVolume(cu)
      if (isCWeight === isUfWeight) {
        sourceConv = c
      } else {
        targetConv = c
      }
    }

    // Both in same dimension (density: L→kg or kg→L) — use different unit as target
    if (!targetConv || !sourceConv) {
      for (const c of convs) {
        const cu = normalizeUnit(c.convertedUnit)
        if (cu !== uf) {
          targetConv = c
        } else {
          sourceConv = c
        }
      }
    }

    if (!targetConv || !sourceConv) {
      console.log(`  SKIP (can't determine pair): ${sp.name} → ${JSON.stringify(convs.map(c => `${c.convertedQuantity} ${c.convertedUnit}`))}`)
      skipped++
      continue
    }

    // Check if conversion is meaningful: target must be in the ingredient's stock unit dimension
    const linkedIng = merc.ingredient_restaurant_id ? ingMap.get(merc.ingredient_restaurant_id) : null
    const ingStockUnit = linkedIng ? normalizeUnit(linkedIng.unite_stock) : normalizeUnit(sp.inpulseIngredientUnit)
    const targetUnit = normalizeUnit(targetConv.convertedUnit)
    const isTargetWeight = isWeightVolume(targetUnit)
    const isIngWeight = isWeightVolume(ingStockUnit)

    // Skip if target dimension doesn't match ingredient stock dimension
    // (e.g. don't store kg→unite conversion when ingredient stock is in g)
    if (isTargetWeight !== isIngWeight) {
      // The inpulse conversion is backwards relative to our needs — swap source/target
      const tmp = sourceConv
      sourceConv = targetConv
      targetConv = tmp
    }

    // Re-check after potential swap
    const finalTargetUnit = normalizeUnit(targetConv.convertedUnit)
    const isFinalTargetWeight = isWeightVolume(finalTargetUnit)

    // Skip density conversions (both same dimension, e.g. L→kg) — the existing system handles these
    if (isFinalTargetWeight === isUfWeight && isFinalTargetWeight === isIngWeight) {
      console.log(`  SKIP (density): ${merc.designation.substring(0, 50)} → ${sourceConv.convertedQuantity} ${normalizeUnit(sourceConv.convertedUnit)} = ${targetConv.convertedQuantity} ${normalizeUnit(targetConv.convertedUnit)}`)
      skipped++
      continue
    }

    // Skip if facturation and ingredient stock are already in same dimension (no bridge needed)
    if (isUfWeight === isIngWeight) {
      console.log(`  SKIP (same dimension): ${merc.designation.substring(0, 50)} [uf=${uf}, stock=${ingStockUnit}]`)
      skipped++
      continue
    }

    // Scale to match the actual colis:
    // inpulse says: sourceConv.qty sourceUnit = targetConv.qty targetUnit
    // colis = coeff × uf
    // conversion_quantite = targetConv.qty × (coeff / sourceConv.qty)
    const scaleFactor = sourceConv.convertedQuantity > 0 ? coeff / sourceConv.convertedQuantity : 1
    const convQuantite = Math.round(targetConv.convertedQuantity * scaleFactor * 100) / 100
    const convUnite = normalizeUnit(targetConv.convertedUnit)

    console.log(`  ${merc.designation.substring(0, 50).padEnd(50)} → ${coeff} ${uf} = ${convQuantite} ${convUnite}  (inpulse: ${sourceConv.convertedQuantity} ${normalizeUnit(sourceConv.convertedUnit)} = ${targetConv.convertedQuantity} ${normalizeUnit(targetConv.convertedUnit)}, stock=${ingStockUnit})`)

    if (LIVE) {
      const { error } = await supabase
        .from('mercuriale')
        .update({
          conversion_quantite: convQuantite,
          conversion_unite: convUnite,
        })
        .eq('id', merc.id)

      if (error) {
        console.error(`    ERROR: ${error.message}`)
      }
    }
    updated++
  }

  console.log('\n---')
  console.log(`Inpulse products with conversions: ${withConversions.length}`)
  console.log(`Matched in mercuriale: ${matched}`)
  console.log(`Updated: ${updated}`)
  console.log(`Already set: ${alreadySet}`)
  console.log(`Skipped: ${skipped}`)

  if (DRY_RUN && updated > 0) {
    console.log('\nRe-run with --live to apply.')
  }
}

main().catch(e => { console.error(e); process.exit(1) })
