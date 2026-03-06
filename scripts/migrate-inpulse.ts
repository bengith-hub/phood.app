/**
 * Migration script: inpulse_export_phood_actifs.json → Supabase tables
 *
 * Usage: npx tsx scripts/migrate-inpulse.ts
 *
 * This script reads the inpulse export and generates SQL INSERT statements
 * that can be run against the Supabase database.
 * It can also be adapted to use the Supabase JS client directly.
 */

import { readFileSync, writeFileSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)

// ── Types for inpulse export ──
interface InpulsePackaging {
  id: string
  name: string
  unit: string | null
  quantity: number
  isUsedInOrder: boolean
  isUsedInStock: boolean
  isUsedInInvoice: boolean
}

interface InpulseSupplierProduct {
  id: string
  entityId: string
  supplierId: string
  supplierName: string
  sku: string | null
  name: string
  price: number
  vatRate: number | null
  active: boolean
  isUsedForCost: boolean
  category: string | null
  packagings: InpulsePackaging[]
  loss: number | null
  allergens: { name: string }[]
}

interface InpulseIngredient {
  id: string
  name: string
  unit: string
  category: string | null
  allergens: { name: string }[]
  supplierProducts: InpulseSupplierProduct[]
  cost: number | null
  active: boolean
}

interface InpulseMapping {
  id: string
  parentEntityId: string
  childEntityId: string
  childEntityQuantity: number
  lnkEntityEntitymappingrel?: {
    isIngredient: boolean
    name: string
    unit: string
  }
  channels?: { name: string; distributionChannels: string[] }[]
}

interface InpulseProduct {
  id: string
  entityId: string
  sku: string | null
  name: string
  priceWithTaxes: number | null
  vatRate: number | null
  deliveryPriceWithTaxes: number | null
  active: boolean
}

interface InpulseRecipe {
  id: string
  name: string
  unit: string
  category: string | null
  isIngredient: boolean
  cost: number | null
  active: boolean
  mappings: InpulseMapping[]
  product: InpulseProduct | null
}

interface InpulseSupplier {
  id: string
  name: string
  category: string | null
  adress: string | null
  postCode: string | null
  city: string | null
  contactName: string | null
  email: string | null
  telephone: string | null
  active: boolean
}

interface InpulseExport {
  summary: Record<string, unknown>
  suppliers: InpulseSupplier[]
  ingredients: InpulseIngredient[]
  recipes: InpulseRecipe[]
  categories: { id: string; name: string }[]
}

// ── Load data ──
const exportPath = join(__dirname, '..', 'inpulse_export_phood_actifs.json')
const data: InpulseExport = JSON.parse(readFileSync(exportPath, 'utf-8'))

console.log(`Loaded: ${data.suppliers.length} suppliers, ${data.ingredients.length} ingredients, ${data.recipes.length} recipes`)

// ── Allergen mapping (inpulse name → PhoodApp code) ──
const ALLERGEN_MAP: Record<string, string> = {
  'Gluten': 'gluten',
  'Crustacés': 'crustaces',
  'Oeufs': 'oeufs',
  'Œufs': 'oeufs',
  'Poissons': 'poissons',
  'Poisson': 'poissons',
  'Arachides': 'arachides',
  'Arachide': 'arachides',
  'Soja': 'soja',
  'Lait': 'lait',
  'Fruits à coque': 'fruits_a_coque',
  'Fruits à coques': 'fruits_a_coque',
  'Céleri': 'celeri',
  'Moutarde': 'moutarde',
  'Sésame': 'sesame',
  'Sulfites': 'sulfites',
  'Lupin': 'lupin',
  'Mollusques': 'mollusques',
}

// ── Unit mapping (inpulse → PhoodApp) ──
function mapUnit(unit: string): string {
  const unitMap: Record<string, string> = {
    'g': 'kg', // we store in kg, will convert quantity
    'mL': 'L', // we store in L
    'unit': 'unite',
    'kg': 'kg',
    'L': 'L',
    'cl': 'L',
    'l': 'L',
    'piece': 'piece',
    'botte': 'botte',
  }
  return unitMap[unit] || 'unite'
}

function escSql(val: string | null | undefined): string {
  if (val == null) return 'NULL'
  return `'${val.replace(/'/g, "''")}'`
}

function escArr(arr: string[]): string {
  if (arr.length === 0) return "'{}'::text[]"
  return `ARRAY[${arr.map(a => escSql(a)).join(', ')}]::text[]`
}

function escIntArr(arr: number[]): string {
  if (arr.length === 0) return "'{}'::integer[]"
  return `ARRAY[${arr.join(', ')}]::integer[]`
}

// ── Generate SQL ──
const sql: string[] = []
sql.push('-- Auto-generated migration from inpulse_export_phood_actifs.json')
sql.push(`-- Generated: ${new Date().toISOString()}`)
sql.push('BEGIN;')
sql.push('')

// ── 1. Categories ──
sql.push('-- Categories')
const catSet = new Set<string>()
const rawCats = (data.categories as unknown as { categories: { name: string | null }[] }).categories || []
rawCats.forEach((c: { name: string | null }) => { if (c.name) catSet.add(c.name) })
data.ingredients.forEach(i => { if (i.category) catSet.add(i.category) })
data.recipes.forEach(r => { if (r.category) catSet.add(r.category) })

let catOrder = 0
for (const cat of catSet) {
  const type = rawCats.find((c: { name: string | null }) => c.name === cat) ? 'recette' : 'ingredient'
  sql.push(`INSERT INTO categories (nom, type, ordre) VALUES (${escSql(cat)}, ${escSql(type)}, ${catOrder++}) ON CONFLICT (nom) DO NOTHING;`)
}
sql.push('')

// ── 2. Fournisseurs ──
sql.push('-- Fournisseurs')
for (const s of data.suppliers) {
  const adresse = [s.adress, s.postCode, s.city].filter(Boolean).join(', ') || null
  sql.push(`INSERT INTO fournisseurs (id, nom, contact_nom, email_commande, telephone, adresse, actif)
VALUES (${escSql(s.id)}, ${escSql(s.name)}, ${escSql(s.contactName)}, ${escSql(s.email)}, ${escSql(s.telephone)}, ${escSql(adresse)}, ${s.active});`)
}
sql.push('')

// ── 3. Ingredients Restaurant ──
sql.push('-- Ingredients Restaurant')
for (const ing of data.ingredients) {
  // Filter test ingredients
  if (ing.category?.toLowerCase() === 'test') continue

  const allergenes = ing.allergens
    .map(a => ALLERGEN_MAP[a.name])
    .filter(Boolean)

  const phoodUnit = mapUnit(ing.unit)

  sql.push(`INSERT INTO ingredients_restaurant (id, nom, unite_stock, categorie, allergenes, cout_unitaire, actif)
VALUES (${escSql(ing.id)}, ${escSql(ing.name)}, ${escSql(phoodUnit)}, ${escSql(ing.category)}, ${escArr(allergenes)}, ${ing.cost || 0}, ${ing.active});`)
}
sql.push('')

// ── 4. Mercuriale (supplier products) ──
sql.push('-- Mercuriale (supplier products)')
for (const ing of data.ingredients) {
  if (ing.category?.toLowerCase() === 'test') continue

  for (const sp of ing.supplierProducts) {
    const conditionnements = sp.packagings.map(p => ({
      nom: p.name,
      quantite: p.quantity,
      unite: mapUnit(p.unit || ing.unit),
      utilise_commande: p.isUsedInOrder,
      utilise_stock: p.isUsedInStock,
    }))

    const phoodUnit = mapUnit(ing.unit)
    const condIdx = sp.packagings.findIndex(p => p.isUsedInOrder)

    sql.push(`INSERT INTO mercuriale (id, fournisseur_id, ingredient_restaurant_id, designation, ref_fournisseur, categorie, conditionnements, conditionnement_commande_idx, prix_unitaire_ht, tva, unite_stock, pertes_pct, actif)
VALUES (${escSql(sp.id)}, ${escSql(sp.supplierId)}, ${escSql(ing.id)}, ${escSql(sp.name)}, ${escSql(sp.sku)}, ${escSql(sp.category)}, ${escSql(JSON.stringify(conditionnements))}, ${Math.max(condIdx, 0)}, ${sp.price}, ${sp.vatRate || 5.5}, ${escSql(phoodUnit)}, ${sp.loss || 0}, ${sp.active});`)

    // Set preferred supplier
    if (sp.isUsedForCost) {
      sql.push(`UPDATE ingredients_restaurant SET fournisseur_prefere_id = ${escSql(sp.id)} WHERE id = ${escSql(ing.id)};`)
    }
  }
}
sql.push('')

// ── 5. Recettes & Sous-recettes ──
sql.push('-- Recettes & Sous-recettes')
for (const r of data.recipes) {
  if (r.category?.toLowerCase() === 'test') continue

  const type = r.isIngredient ? 'sous_recette' : 'recette'

  // Extract prix_vente from product
  let prixVente: string = 'NULL'
  if (r.product) {
    const pv: Record<string, { ttc: number | null; tva: number | null }> = {}
    if (r.product.priceWithTaxes != null) {
      pv.sur_place = { ttc: r.product.priceWithTaxes, tva: r.product.vatRate }
      pv.emporter = { ttc: r.product.priceWithTaxes, tva: r.product.vatRate }
    }
    if (r.product.deliveryPriceWithTaxes != null) {
      pv.livraison = { ttc: r.product.deliveryPriceWithTaxes, tva: r.product.vatRate }
    }
    if (Object.keys(pv).length > 0) {
      prixVente = escSql(JSON.stringify(pv))
    }
  }

  const zeltyId = r.product?.sku || null

  sql.push(`INSERT INTO recettes (id, nom, type, categorie, cout_matiere, prix_vente, zelty_product_id, actif)
VALUES (${escSql(r.id)}, ${escSql(r.name)}, ${escSql(type)}, ${escSql(r.category)}, ${r.cost || 0}, ${prixVente}::jsonb, ${escSql(zeltyId)}, ${r.active});`)
}
sql.push('')

// ── 6. Recette Ingredients (mappings) ──
// Build sets of excluded IDs (test category) to skip orphan references
const excludedRecipeIds = new Set(data.recipes.filter(r => r.category?.toLowerCase() === 'test').map(r => r.id))
const excludedIngredientIds = new Set(data.ingredients.filter(i => i.category?.toLowerCase() === 'test').map(i => i.id))

sql.push('-- Recette Ingredients (mappings)')
for (const r of data.recipes) {
  if (r.category?.toLowerCase() === 'test') continue

  for (const m of r.mappings) {
    const isIngredient = m.lnkEntityEntitymappingrel?.isIngredient ?? true
    const childUnit = m.lnkEntityEntitymappingrel?.unit || 'unit'
    const phoodUnit = mapUnit(childUnit)

    // Skip mappings referencing excluded (test) items
    if (isIngredient && excludedIngredientIds.has(m.childEntityId)) continue
    if (!isIngredient && excludedRecipeIds.has(m.childEntityId)) continue

    if (isIngredient) {
      sql.push(`INSERT INTO recette_ingredients (id, recette_id, ingredient_id, quantite, unite)
VALUES (${escSql(m.id)}, ${escSql(r.id)}, ${escSql(m.childEntityId)}, ${m.childEntityQuantity}, ${escSql(phoodUnit)});`)
    } else {
      sql.push(`INSERT INTO recette_ingredients (id, recette_id, sous_recette_id, quantite, unite)
VALUES (${escSql(m.id)}, ${escSql(r.id)}, ${escSql(m.childEntityId)}, ${m.childEntityQuantity}, ${escSql(phoodUnit)});`)
    }
  }
}
sql.push('')

// ── 7. Initialize stocks ──
sql.push('-- Initialize stocks (all at 0)')
for (const ing of data.ingredients) {
  if (ing.category?.toLowerCase() === 'test') continue
  sql.push(`INSERT INTO stocks (ingredient_id, quantite, source_maj) VALUES (${escSql(ing.id)}, 0, 'manuel');`)
}
sql.push('')

sql.push('COMMIT;')

// ── Write output ──
const outputPath = join(__dirname, '..', 'supabase', 'migrations', '002_seed_inpulse_data.sql')
writeFileSync(outputPath, sql.join('\n'), 'utf-8')
console.log(`\nGenerated: ${outputPath}`)
console.log(`  Categories: ${catSet.size}`)
console.log(`  Fournisseurs: ${data.suppliers.length}`)
console.log(`  Ingrédients: ${data.ingredients.filter(i => i.category?.toLowerCase() !== 'test').length}`)
console.log(`  Mercuriale entries: ${data.ingredients.reduce((acc, i) => acc + (i.category?.toLowerCase() !== 'test' ? i.supplierProducts.length : 0), 0)}`)
console.log(`  Recettes: ${data.recipes.filter(r => r.category?.toLowerCase() !== 'test').length}`)
console.log(`  Mappings: ${data.recipes.reduce((acc, r) => acc + (r.category?.toLowerCase() !== 'test' ? r.mappings.length : 0), 0)}`)
