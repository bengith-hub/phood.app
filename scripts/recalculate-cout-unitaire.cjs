#!/usr/bin/env node
/**
 * Bulk recalculate cout_unitaire for all ingredients from their preferred mercuriale.
 *
 * Formula: cout_unitaire = prix_unitaire_ht / (coefficient_conversion × unitFactor)
 * Where unitFactor converts conditioning unit to ingredient stock unit (e.g. kg→g = 1000)
 *
 * Usage:
 *   node scripts/recalculate-cout-unitaire.cjs --dry-run
 *   node scripts/recalculate-cout-unitaire.cjs --live
 */

const { createClient } = require('@supabase/supabase-js')

const DRY_RUN = process.argv.includes('--dry-run')
const LIVE = process.argv.includes('--live')

if (!DRY_RUN && !LIVE) {
  console.log('Usage: node scripts/recalculate-cout-unitaire.cjs --dry-run|--live')
  process.exit(1)
}

const supabase = createClient(
  'https://pfcvtpavwjchwdarhixc.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'
)

function getUnitFactor(condUnite, stockUnite) {
  const cu = condUnite.toLowerCase()
  const su = stockUnite.toLowerCase()
  if (cu === 'kg' && su === 'g') return 1000
  if (cu === 'g' && su === 'kg') return 0.001
  if (cu === 'l' && su === 'ml') return 1000
  if (cu === 'ml' && su === 'l') return 0.001
  if (cu === 'l' && su === 'cl') return 100
  if (cu === 'cl' && su === 'l') return 0.01
  // Cross-dimension: volume ↔ weight (assume density ≈ 1)
  if (cu === 'l' && su === 'g') return 1000
  if (cu === 'g' && su === 'l') return 0.001
  if (cu === 'l' && su === 'kg') return 1
  if (cu === 'kg' && su === 'l') return 1
  if (cu === 'ml' && su === 'g') return 1
  if (cu === 'g' && su === 'ml') return 1
  if (cu === 'kg' && su === 'ml') return 1000
  if (cu === 'ml' && su === 'kg') return 0.001
  if (cu === 'cl' && su === 'g') return 10
  if (cu === 'g' && su === 'cl') return 0.1
  if (cu === 'kg' && su === 'cl') return 100
  if (cu === 'cl' && su === 'kg') return 0.01
  return 1
}

function getFacturationConditioning(merc) {
  // 1. Explicit unite_facturation field
  if (merc.unite_facturation) return { quantite: 1, unite: merc.unite_facturation }
  const conds = merc.conditionnements || []
  // 2. For weight/volume: prix is per base unit (kg or L)
  const su = (merc.unite_stock || '').toLowerCase()
  const isWeightVolume = ['g', 'kg', 'ml', 'cl', 'l'].includes(su)
  if (isWeightVolume) {
    const baseCond = conds.find(c => c.quantite <= 1 && !c.utilise_commande)
    if (baseCond) return { quantite: baseCond.quantite, unite: baseCond.unite }
    const baseUnit = ['g', 'kg'].includes(su) ? 'kg' : 'l'
    return { quantite: 1, unite: baseUnit }
  }
  // 3. Count products: facturation = commande conditioning
  const cmdCond = conds.find(c => c.utilise_commande)
  if (cmdCond) return { quantite: cmdCond.quantite, unite: cmdCond.unite }
  return { quantite: merc.coefficient_conversion || 1, unite: merc.unite_stock }
}

function calculateCoutUnitaire(merc, ingredientUniteStock) {
  if (!merc.prix_unitaire_ht || merc.prix_unitaire_ht <= 0) return 0

  // Explicit conversion: e.g. 5 kg = 1000 unite
  if (merc.conversion_quantite && merc.conversion_quantite > 0 && merc.conversion_unite) {
    const convUnite = merc.conversion_unite.toLowerCase()
    const isu = ingredientUniteStock.toLowerCase()
    const coeff = merc.coefficient_conversion || 1
    const prixColis = merc.prix_unitaire_ht * coeff
    const coutParConvUnit = prixColis / merc.conversion_quantite
    if (convUnite === isu) return coutParConvUnit
    const factor = getUnitFactor(convUnite, isu)
    return factor > 0 ? coutParConvUnit / factor : 0
  }

  const fact = getFacturationConditioning(merc)
  const fu = fact.unite.toLowerCase()
  const isu = ingredientUniteStock.toLowerCase()
  const isFactCount = !['g', 'kg', 'ml', 'cl', 'l'].includes(fu)
  const isIngWeightVolume = ['g', 'kg', 'ml', 'cl', 'l'].includes(isu)
  // Bridge: facturation in count but ingredient in weight/volume
  if (isFactCount && isIngWeightVolume) {
    const coeff = merc.coefficient_conversion || 1
    const bridgeUnit = (merc.unite_commande || merc.unite_stock || 'kg').toLowerCase()
    const factor = getUnitFactor(bridgeUnit, isu)
    const divisor = fact.quantite * coeff * factor
    return divisor > 0 ? merc.prix_unitaire_ht / divisor : 0
  }
  const factor = getUnitFactor(fu, isu)
  const divisor = fact.quantite * factor
  if (divisor <= 0) return 0
  return merc.prix_unitaire_ht / divisor
}

async function main() {
  console.log(`Mode: ${DRY_RUN ? 'DRY RUN' : 'LIVE'}`)
  console.log('---')

  // Fetch all ingredients with a preferred supplier
  const { data: ingredients, error: ingErr } = await supabase
    .from('ingredients_restaurant')
    .select('id, nom, unite_stock, fournisseur_prefere_id, cout_unitaire')
    .not('fournisseur_prefere_id', 'is', null)

  if (ingErr) {
    console.error('Error fetching ingredients:', ingErr.message)
    process.exit(1)
  }

  console.log(`Found ${ingredients.length} ingredients with a preferred supplier`)

  // Fetch all mercuriale products
  const { data: mercuriale, error: mercErr } = await supabase
    .from('mercuriale')
    .select('id, prix_unitaire_ht, coefficient_conversion, conditionnements, unite_stock, unite_facturation, unite_commande, conversion_quantite, conversion_unite, designation')

  if (mercErr) {
    console.error('Error fetching mercuriale:', mercErr.message)
    process.exit(1)
  }

  const mercMap = new Map()
  for (const m of mercuriale) {
    mercMap.set(m.id, m)
  }

  let updated = 0
  let skipped = 0
  let noMerc = 0
  let unchanged = 0

  for (const ing of ingredients) {
    const merc = mercMap.get(ing.fournisseur_prefere_id)
    if (!merc) {
      noMerc++
      console.log(`  SKIP ${ing.nom}: preferred mercuriale ${ing.fournisseur_prefere_id} not found`)
      continue
    }

    const newCout = calculateCoutUnitaire(merc, ing.unite_stock)

    if (newCout <= 0) {
      skipped++
      console.log(`  SKIP ${ing.nom}: calculated cout = 0 (prix=${merc.prix_unitaire_ht}, coeff=${merc.coefficient_conversion})`)
      continue
    }

    // Check if it actually changed (within rounding tolerance)
    if (Math.abs(newCout - (ing.cout_unitaire || 0)) < 0.000001) {
      unchanged++
      continue
    }

    const oldCout = ing.cout_unitaire || 0
    const fact = getFacturationConditioning(merc)
    const factor = getUnitFactor(fact.unite, ing.unite_stock)

    console.log(
      `  ${ing.nom}: ${oldCout.toFixed(6)} → ${newCout.toFixed(6)} €/${ing.unite_stock}` +
      ` (${merc.designation}: ${merc.prix_unitaire_ht}€/${fact.unite} / (${fact.quantite} × ${factor}))`
    )

    if (LIVE) {
      const { error: upErr } = await supabase
        .from('ingredients_restaurant')
        .update({
          cout_unitaire: newCout,
          cout_source: 'mercuriale',
          cout_maj_date: new Date().toISOString(),
        })
        .eq('id', ing.id)

      if (upErr) {
        console.error(`    ERROR updating ${ing.nom}:`, upErr.message)
      }
    }

    updated++
  }

  console.log('\n---')
  console.log(`Total ingredients with preferred supplier: ${ingredients.length}`)
  console.log(`Updated: ${updated}`)
  console.log(`Unchanged: ${unchanged}`)
  console.log(`Skipped (zero cost): ${skipped}`)
  console.log(`Missing mercuriale: ${noMerc}`)

  if (DRY_RUN && updated > 0) {
    console.log('\nRe-run with --live to apply changes.')
  }
}

main().catch(e => {
  console.error(e)
  process.exit(1)
})
