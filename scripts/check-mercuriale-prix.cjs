#!/usr/bin/env node
/**
 * Check mercuriale products for potentially incorrect prix_unitaire_ht values.
 *
 * Some products may have prix_unitaire_ht set to the price per carton/colis
 * instead of the price per individual unit of stock. This script identifies
 * products where the conditionnement de commande has quantite > 1 and shows
 * both the current prix_unitaire_ht and the calculated unit price.
 *
 * Usage:
 *   node scripts/check-mercuriale-prix.cjs
 *   node scripts/check-mercuriale-prix.cjs --csv   # Export as CSV to stdout
 *
 * Prerequisites:
 *   npm install dotenv   (if not already installed)
 */

const path = require('path')
const fs = require('fs')
const { createClient } = require('@supabase/supabase-js')

// ── Load .env ────────────────────────────────────────────────────────────────
// Try dotenv first; fall back to manual parse if not installed
try {
  require('dotenv').config({ path: path.resolve(__dirname, '../.env') })
} catch {
  // dotenv not installed — parse .env manually
  const envPath = path.resolve(__dirname, '../.env')
  if (fs.existsSync(envPath)) {
    const lines = fs.readFileSync(envPath, 'utf-8').split('\n')
    for (const line of lines) {
      const trimmed = line.trim()
      if (!trimmed || trimmed.startsWith('#')) continue
      const eqIdx = trimmed.indexOf('=')
      if (eqIdx === -1) continue
      const key = trimmed.slice(0, eqIdx).trim()
      const val = trimmed.slice(eqIdx + 1).trim()
      if (!process.env[key]) {
        process.env[key] = val
      }
    }
  }
}

// ── Supabase client ──────────────────────────────────────────────────────────
const SUPABASE_URL = process.env.VITE_SUPABASE_URL
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('ERROR: Missing VITE_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.')
  console.error('Make sure .env is present in the project root.')
  process.exit(1)
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)

const CSV_MODE = process.argv.includes('--csv')

// ── Helpers ──────────────────────────────────────────────────────────────────

/**
 * Find the conditionnement used for ordering (utilise_commande = true)
 * that has quantite > 1.
 */
function findCondCommande(conditionnements) {
  if (!Array.isArray(conditionnements) || conditionnements.length === 0) {
    return null
  }
  return conditionnements.find(c => c.utilise_commande === true && c.quantite > 1) || null
}

/**
 * Format a number as euros with 4 decimals for precision.
 */
function formatEur(value) {
  return value.toFixed(4) + ' EUR'
}

/**
 * Pad or truncate a string to a fixed width.
 */
function pad(str, width) {
  if (str.length > width) return str.slice(0, width - 1) + '\u2026'
  return str.padEnd(width)
}

function padLeft(str, width) {
  if (str.length > width) return str.slice(0, width - 1) + '\u2026'
  return str.padStart(width)
}

// ── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  console.error('=== Vérification prix_unitaire_ht mercuriale ===')
  console.error('')

  // 1. Fetch all active mercuriale products
  console.error('Fetching active mercuriale products...')
  const { data: products, error: prodErr } = await supabase
    .from('mercuriale')
    .select('id, designation, fournisseur_id, prix_unitaire_ht, unite_stock, coefficient_conversion, conditionnements, ref_fournisseur')
    .eq('actif', true)
    .order('designation')

  if (prodErr) {
    console.error('Supabase error:', prodErr.message)
    process.exit(1)
  }

  console.error(`  ${products.length} active products found.`)

  // 2. Fetch fournisseurs for display names
  const { data: fournisseurs, error: fournErr } = await supabase
    .from('fournisseurs')
    .select('id, nom')

  if (fournErr) {
    console.error('Supabase error (fournisseurs):', fournErr.message)
    process.exit(1)
  }

  const fournisseurMap = new Map(fournisseurs.map(f => [f.id, f.nom]))

  // 3. Filter: only products with a conditionnement de commande with quantite > 1
  const suspects = []

  for (const p of products) {
    const cond = findCondCommande(p.conditionnements)
    if (!cond) continue

    const calculatedUnitPrice = p.prix_unitaire_ht / cond.quantite

    suspects.push({
      designation: p.designation,
      fournisseur: fournisseurMap.get(p.fournisseur_id) || p.fournisseur_id,
      ref: p.ref_fournisseur || '',
      prix_unitaire_ht: p.prix_unitaire_ht,
      unite_stock: p.unite_stock,
      coefficient_conversion: p.coefficient_conversion,
      cond_nom: cond.nom,
      cond_quantite: cond.quantite,
      calculated_unit_price: calculatedUnitPrice,
      ratio: cond.quantite,
    })
  }

  console.error(`  ${suspects.length} products with conditionnement de commande quantite > 1`)
  console.error('')

  if (suspects.length === 0) {
    console.error('No products to review. All clear!')
    return
  }

  // 4. Output results
  if (CSV_MODE) {
    outputCSV(suspects)
  } else {
    outputTable(suspects)
  }

  // 5. Summary stats
  console.error('')
  console.error('=== Résumé ===')
  console.error(`  Total produits actifs:            ${products.length}`)
  console.error(`  Avec cond. commande qty > 1:      ${suspects.length}`)
  console.error(`  Produits sans conditionnements:    ${products.filter(p => !Array.isArray(p.conditionnements) || p.conditionnements.length === 0).length}`)
  console.error('')
  console.error('ACTION: Pour chaque ligne, vérifier si prix_unitaire_ht est le prix')
  console.error('  par UNITE de stock ou par COLIS de commande.')
  console.error('  Si c\'est par colis, le prix correct = prix_calculé_unité.')
}

function outputTable(suspects) {
  // Group by fournisseur for readability
  const byFournisseur = new Map()
  for (const s of suspects) {
    if (!byFournisseur.has(s.fournisseur)) {
      byFournisseur.set(s.fournisseur, [])
    }
    byFournisseur.get(s.fournisseur).push(s)
  }

  for (const [fournisseur, items] of byFournisseur) {
    console.log('')
    console.log(`\u2500\u2500\u2500 ${fournisseur} (${items.length} produits) \u2500\u2500\u2500`)
    console.log('')

    // Table header
    const hDesig = pad('Désignation', 40)
    const hPrix = padLeft('Prix HT', 12)
    const hCond = pad('Conditionnement', 25)
    const hQty = padLeft('Qty', 5)
    const hCalc = padLeft('Prix/unité', 12)
    const hUnite = pad('Unité', 8)
    const hCoeff = padLeft('Coeff', 6)

    console.log(`  ${hDesig} ${hPrix}  ${hCond} ${hQty}  ${hCalc}  ${hUnite} ${hCoeff}`)
    console.log(`  ${'─'.repeat(40)} ${'─'.repeat(12)}  ${'─'.repeat(25)} ${'─'.repeat(5)}  ${'─'.repeat(12)}  ${'─'.repeat(8)} ${'─'.repeat(6)}`)

    for (const s of items) {
      const desig = pad(s.designation, 40)
      const prix = padLeft(s.prix_unitaire_ht.toFixed(2) + '€', 12)
      const cond = pad(s.cond_nom, 25)
      const qty = padLeft(String(s.cond_quantite), 5)
      const calc = padLeft(s.calculated_unit_price.toFixed(4) + '€', 12)
      const unite = pad(s.unite_stock, 8)
      const coeff = padLeft(String(s.coefficient_conversion), 6)

      // Flag suspicious: if prix_unitaire_ht seems too high (could be per colis)
      // Heuristic: if prix > 5 and qty >= 6, it's more likely a colis price
      const flag = (s.prix_unitaire_ht > 5 && s.cond_quantite >= 6) ? ' ⚠' : ''

      console.log(`  ${desig} ${prix}  ${cond} ${qty}  ${calc}  ${unite} ${coeff}${flag}`)
    }
  }

  console.log('')
  console.log('Note: les lignes marquées d\'un avertissement ont un prix > 5 EUR')
  console.log('  et un conditionnement >= 6 unités (plus probablement un prix colis).')
}

function outputCSV(suspects) {
  // CSV header
  console.log('fournisseur,designation,ref_fournisseur,prix_unitaire_ht,unite_stock,coefficient_conversion,cond_nom,cond_quantite,prix_calcule_unite')

  for (const s of suspects) {
    const fields = [
      `"${s.fournisseur.replace(/"/g, '""')}"`,
      `"${s.designation.replace(/"/g, '""')}"`,
      `"${s.ref.replace(/"/g, '""')}"`,
      s.prix_unitaire_ht.toFixed(4),
      s.unite_stock,
      s.coefficient_conversion,
      `"${s.cond_nom.replace(/"/g, '""')}"`,
      s.cond_quantite,
      s.calculated_unit_price.toFixed(4),
    ]
    console.log(fields.join(','))
  }
}

main().catch(err => {
  console.error('Fatal:', err)
  process.exit(1)
})
