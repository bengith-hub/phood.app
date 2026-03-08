#!/usr/bin/env node
/**
 * Import inpulse ingredients + supplier products into PhoodApp Supabase.
 *
 * Prerequisites:
 *   1. Fournisseurs must already exist in Supabase (user adds them manually)
 *   2. The script matches inpulse supplier names to existing fournisseurs
 *
 * Usage:
 *   node scripts/import-inpulse.js [--dry-run]
 *
 * Reads: /Projet/PhoodApp/inpulse_export_phood_actifs.json
 * Writes to: ingredients_restaurant, mercuriale tables
 */

const fs = require('fs')
const path = require('path')
const { createClient } = require('@supabase/supabase-js')

// ---------- Config ----------
const SUPABASE_URL = 'https://pfcvtpavwjchwdarhixc.supabase.co'
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
  || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'

const INPULSE_FILE = path.resolve(
  __dirname,
  '../../Library/CloudStorage/GoogleDrive-benjamin.fetu@phood-restaurant.fr/My Drive/Projet/PhoodApp/inpulse_export_phood_actifs.json'
)

const DRY_RUN = process.argv.includes('--dry-run')

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)

// ---------- Allergen mapping ----------
const ALLERGEN_MAP = {
  'Gluten': 'gluten',
  'Crustacés': 'crustaces',
  'Crustaceans': 'crustaces',
  'Oeufs': 'oeufs',
  'Eggs': 'oeufs',
  'Poissons': 'poissons',
  'Fish': 'poissons',
  'Arachides': 'arachides',
  'Peanuts': 'arachides',
  'Soja': 'soja',
  'Soy': 'soja',
  'Soybeans': 'soja',
  'Lait': 'lait',
  'Milk': 'lait',
  'Fruits à coque': 'fruits_a_coque',
  'Tree nuts': 'fruits_a_coque',
  'Nuts': 'fruits_a_coque',
  'Céleri': 'celeri',
  'Celery': 'celeri',
  'Moutarde': 'moutarde',
  'Mustard': 'moutarde',
  'Sésame': 'sesame',
  'Sesame': 'sesame',
  'Sulfites': 'sulfites',
  'Sulphites': 'sulfites',
  'Lupin': 'lupin',
  'Mollusques': 'mollusques',
  'Molluscs': 'mollusques',
}

// ---------- Unit normalization ----------
function normalizeUnit(unit) {
  const map = {
    'g': 'kg',
    'mL': 'L',
    'ml': 'L',
    'cl': 'L',
    'unit': 'unite',
    'pcs': 'unite',
    'piece': 'piece',
    'pièce': 'piece',
    'botte': 'botte',
    'kg': 'kg',
    'L': 'L',
    'l': 'L',
  }
  return map[unit] || unit
}

function unitConversionFactor(fromUnit) {
  // Returns factor to convert from fromUnit to normalized unit
  const map = { 'g': 0.001, 'mL': 0.001, 'ml': 0.001, 'cl': 0.01 }
  return map[fromUnit] || 1
}

// ---------- Main ----------
async function main() {
  console.log('=== PhoodApp Inpulse Import ===')
  console.log(DRY_RUN ? '>>> DRY RUN — no data will be written <<<' : '>>> LIVE MODE <<<')
  console.log('')

  // 1. Read inpulse export
  console.log('Reading inpulse export...')
  const raw = fs.readFileSync(INPULSE_FILE, 'utf-8')
  const data = JSON.parse(raw)

  const ingredients = data.ingredients.filter(i => i.active)
  const suppliers = data.suppliers
  console.log(`  ${ingredients.length} active ingredients`)
  console.log(`  ${suppliers.length} suppliers in export`)
  console.log('')

  // 2. Fetch existing fournisseurs from Supabase
  console.log('Fetching existing fournisseurs from Supabase...')
  const { data: fournisseurs, error: fErr } = await supabase
    .from('fournisseurs')
    .select('id, nom')
    .order('nom')
  if (fErr) throw fErr
  console.log(`  ${fournisseurs.length} fournisseurs found in PhoodApp`)
  console.log('')

  // 3. Match inpulse suppliers to PhoodApp fournisseurs
  const supplierNames = new Set()
  for (const ing of ingredients) {
    for (const sp of ing.supplierProducts || []) {
      if (sp.active !== false) supplierNames.add(sp.supplierName)
    }
  }

  console.log('Supplier name matching:')
  const supplierIdMap = {} // inpulse supplierId -> supabase fournisseur id

  for (const inpSupplier of suppliers) {
    const match = fournisseurs.find(f => {
      const a = f.nom.toLowerCase().trim()
      const b = inpSupplier.name.toLowerCase().trim()
      return a === b || a.includes(b) || b.includes(a)
    })
    if (match) {
      supplierIdMap[inpSupplier.id] = match.id
      if (supplierNames.has(inpSupplier.name)) {
        console.log(`  ✓ "${inpSupplier.name}" → "${match.nom}" (${match.id})`)
      }
    } else if (supplierNames.has(inpSupplier.name)) {
      console.log(`  ✗ "${inpSupplier.name}" — NO MATCH (ingredients from this supplier will be skipped)`)
    }
  }
  console.log('')

  // 4. Check existing ingredients to avoid duplicates
  const { data: existingIngs, error: ingErr } = await supabase
    .from('ingredients_restaurant')
    .select('id, nom')
  if (ingErr) throw ingErr
  const existingNames = new Set(existingIngs.map(i => i.nom.toLowerCase().trim()))
  console.log(`  ${existingIngs.length} existing ingredients in PhoodApp`)

  // 5. Prepare ingredient records
  const ingredientRecords = []
  const ingredientIdMap = {} // inpulse id -> supabase record (will be filled after insert)

  for (const ing of ingredients) {
    if (existingNames.has(ing.name.toLowerCase().trim())) {
      // Map existing ingredient
      const existing = existingIngs.find(e => e.nom.toLowerCase().trim() === ing.name.toLowerCase().trim())
      if (existing) ingredientIdMap[ing.id] = existing.id
      continue
    }

    const allergenes = (ing.allergens || [])
      .map(a => ALLERGEN_MAP[a.name])
      .filter(Boolean)

    const convFactor = unitConversionFactor(ing.unit)
    const normalizedUnit = normalizeUnit(ing.unit)
    const cost = ing.cost != null ? ing.cost * (convFactor !== 1 ? 1 / convFactor : 1) : 0

    ingredientRecords.push({
      _inpulse_id: ing.id, // temporary, removed before insert
      nom: ing.name,
      unite_stock: normalizedUnit,
      categorie: ing.category || null,
      allergenes: allergenes,
      contient: null,
      cout_unitaire: Math.round(cost * 10000) / 10000,
      cout_source: 'mercuriale',
      stock_tampon: 0,
      actif: true,
    })
  }

  console.log(`  ${ingredientRecords.length} new ingredients to import`)
  console.log(`  ${Object.keys(ingredientIdMap).length} ingredients already exist (will be linked)`)
  console.log('')

  // 6. Insert ingredients
  if (!DRY_RUN && ingredientRecords.length > 0) {
    console.log('Inserting ingredients...')
    // Insert in batches of 50
    for (let i = 0; i < ingredientRecords.length; i += 50) {
      const batch = ingredientRecords.slice(i, i + 50).map(r => {
        const { _inpulse_id, ...record } = r
        return record
      })
      const { data: inserted, error: insertErr } = await supabase
        .from('ingredients_restaurant')
        .insert(batch)
        .select('id, nom')
      if (insertErr) {
        console.error(`  Error at batch ${i}:`, insertErr.message)
        continue
      }
      // Map back to inpulse ids
      for (const rec of inserted) {
        const original = ingredientRecords.find(r => r.nom === rec.nom)
        if (original) {
          ingredientIdMap[original._inpulse_id] = rec.id
        }
      }
      process.stdout.write(`  Batch ${Math.floor(i / 50) + 1}: ${inserted.length} inserted\r`)
    }
    console.log('')
  }

  // 7. Check existing mercuriale to avoid duplicates
  const { data: existingMerc, error: mercErr } = await supabase
    .from('mercuriale')
    .select('id, designation, fournisseur_id')
  if (mercErr) throw mercErr
  const existingMercKeys = new Set(
    existingMerc.map(m => `${m.fournisseur_id}|${m.designation.toLowerCase().trim()}`)
  )

  // 8. Prepare mercuriale records
  const mercurialeRecords = []
  let skippedNoFournisseur = 0
  let skippedNoIngredient = 0
  let skippedDuplicate = 0

  for (const ing of ingredients) {
    const ingredientId = ingredientIdMap[ing.id]
    if (!ingredientId) {
      // Ingredient not imported and not found in existing
      continue
    }

    for (const sp of (ing.supplierProducts || [])) {
      const fournisseurId = supplierIdMap[sp.supplierId]
      if (!fournisseurId) {
        skippedNoFournisseur++
        continue
      }

      const key = `${fournisseurId}|${sp.name.toLowerCase().trim()}`
      if (existingMercKeys.has(key)) {
        skippedDuplicate++
        continue
      }

      // Build conditionnements from packagings
      const conditionnements = (sp.packagings || [])
        .filter(p => p.isActive)
        .map(p => ({
          nom: p.name,
          quantite: p.quantity,
          unite: p.unit || normalizeUnit(ing.unit),
          utilise_commande: p.isUsedInOrder || false,
        }))

      // Determine order unit from packaging
      const orderPkg = (sp.packagings || []).find(p => p.isUsedInOrder)
      const stockPkg = (sp.packagings || []).find(p => p.isUsedInStock)
      const masterPkg = (sp.packagings || []).find(p => !p.parentSupplierProductPackagingId)

      const uniteCommande = orderPkg?.name || stockPkg?.name || masterPkg?.unit || normalizeUnit(ing.unit)
      const coeffConversion = orderPkg?.quantity || stockPkg?.quantity || 1

      mercurialeRecords.push({
        fournisseur_id: fournisseurId,
        ingredient_restaurant_id: ingredientId,
        designation: sp.name,
        ref_fournisseur: sp.sku || null,
        categorie: sp.category || ing.category || null,
        unite_commande: uniteCommande,
        conditionnements: conditionnements,
        prix_unitaire_ht: sp.price || 0,
        tva: sp.vatRate || 5.5,
        prix_modifiable_reception: true,
        pertes_pct: sp.loss || null,
        unite_stock: normalizeUnit(ing.unit),
        coefficient_conversion: coeffConversion,
        photo_url: sp.img || null,
        actif: sp.active !== false,
      })
    }
  }

  console.log(`Mercuriale:`)
  console.log(`  ${mercurialeRecords.length} new products to import`)
  console.log(`  ${skippedNoFournisseur} skipped (fournisseur not matched)`)
  console.log(`  ${skippedDuplicate} skipped (already exist)`)
  console.log('')

  // 9. Insert mercuriale
  if (!DRY_RUN && mercurialeRecords.length > 0) {
    console.log('Inserting mercuriale records...')
    let firstIngredientLinked = null
    for (let i = 0; i < mercurialeRecords.length; i += 50) {
      const batch = mercurialeRecords.slice(i, i + 50)
      const { data: inserted, error: insertErr } = await supabase
        .from('mercuriale')
        .insert(batch)
        .select('id, ingredient_restaurant_id')
      if (insertErr) {
        console.error(`  Error at batch ${i}:`, insertErr.message)
        continue
      }
      // Link first mercuriale as fournisseur_prefere_id for each ingredient
      for (const rec of inserted) {
        if (rec.ingredient_restaurant_id && !firstIngredientLinked) {
          // We could set fournisseur_prefere_id here but that's a separate step
        }
      }
      process.stdout.write(`  Batch ${Math.floor(i / 50) + 1}: ${inserted.length} inserted\r`)
    }
    console.log('')
  }

  // 10. Set fournisseur_prefere_id for ingredients
  if (!DRY_RUN) {
    console.log('Setting preferred supplier links...')
    let linked = 0
    for (const ing of ingredients) {
      const ingredientId = ingredientIdMap[ing.id]
      if (!ingredientId) continue

      // Find the supplierProduct marked as isUsedForCost
      const preferredSp = (ing.supplierProducts || []).find(sp => sp.isUsedForCost)
      if (!preferredSp) continue

      const fournisseurId = supplierIdMap[preferredSp.supplierId]
      if (!fournisseurId) continue

      // Find the mercuriale record for this supplier product
      const { data: mercRecords } = await supabase
        .from('mercuriale')
        .select('id')
        .eq('ingredient_restaurant_id', ingredientId)
        .eq('fournisseur_id', fournisseurId)
        .limit(1)

      if (mercRecords && mercRecords.length > 0) {
        await supabase
          .from('ingredients_restaurant')
          .update({ fournisseur_prefere_id: mercRecords[0].id })
          .eq('id', ingredientId)
        linked++
      }
    }
    console.log(`  ${linked} ingredients linked to preferred supplier`)
  }

  console.log('')
  console.log('=== Import complete ===')
  if (DRY_RUN) {
    console.log('This was a dry run. Run without --dry-run to actually import.')
  }
}

main().catch(err => {
  console.error('Fatal error:', err)
  process.exit(1)
})
