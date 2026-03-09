#!/usr/bin/env node
/**
 * Fix mercuriale products where prix_unitaire_ht is stored as per-unit
 * instead of per-colis (conditionnement de commande).
 *
 * For each product listed below, the script multiplies prix_unitaire_ht
 * by the conditionnement de commande quantity to get the correct colis price.
 *
 * Convention: prix_unitaire_ht = price per COLIS (not per unit of stock)
 *
 * Usage:
 *   node scripts/fix-mercuriale-prix-colis.cjs          # Dry run (shows changes)
 *   node scripts/fix-mercuriale-prix-colis.cjs --apply   # Apply changes to Supabase
 */

const path = require('path')
const fs = require('fs')
const { createClient } = require('@supabase/supabase-js')

// ── Load .env ────────────────────────────────────────────────────────────────
try {
  require('dotenv').config({ path: path.resolve(__dirname, '../.env') })
} catch {
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
      if (!process.env[key]) process.env[key] = val
    }
  }
}

const SUPABASE_URL = process.env.VITE_SUPABASE_URL
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('ERROR: Missing VITE_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.')
  process.exit(1)
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)
const APPLY = process.argv.includes('--apply')

// ── Products to fix ──────────────────────────────────────────────────────────
// Each entry: { designation (substring match), fournisseur (substring match) }
// The script will find the matching product, check its conditionnement de commande,
// and multiply prix_unitaire_ht by cond.quantite.

const PRODUCTS_TO_FIX = [
  // Transgourmet (14 + 1 ambiguous = 15)
  { designation: 'Carottes enti', fournisseur: 'Transgourmet' },          // Carottes entières
  { designation: 'Coca Cola Slim', fournisseur: 'Transgourmet' },
  { designation: 'Coca Cola Zero Slim', fournisseur: 'Transgourmet' },
  { designation: 'Concombre', fournisseur: 'Transgourmet' },
  { designation: 'Crevettes d', fournisseur: 'Transgourmet' },             // Crevettes décortiquées
  { designation: 'Farine De Bl', fournisseur: 'Transgourmet' },            // Farine De Blé
  { designation: 'Jus Detox Pomme Carotte', fournisseur: 'Transgourmet' },
  { designation: 'Jus Detox Pomme Fruits Rouges', fournisseur: 'Transgourmet' },
  { designation: 'Jus Detox Pomme Mangue', fournisseur: 'Transgourmet' },
  { designation: 'Jus Detox Pomme Menthe Citron', fournisseur: 'Transgourmet' },
  { designation: 'Limonade Steff', fournisseur: 'Transgourmet' },
  { designation: 'Oignon Rouge', fournisseur: 'Transgourmet' },
  { designation: 'Roti Echine', fournisseur: 'Transgourmet' },
  { designation: 'Salade Iceberg', fournisseur: 'Transgourmet' },
  { designation: 'Sorbet Framboise Litchi', fournisseur: 'Transgourmet' },
  { designation: 'Sucre en Poudre', fournisseur: 'Transgourmet' },
  { designation: 'Filet de Poulet Halal', fournisseur: 'Transgourmet' },   // confirmed per-kg → ×10

  // Promocash (9)
  { designation: 'Heineken', fournisseur: 'Promocash' },                   // Bière Heineken sans alcool 0%
  { designation: 'Carottes enti', fournisseur: 'Promocash' },              // Carottes entières
  { designation: 'Coca Cola Slim', fournisseur: 'Promocash' },
  { designation: 'Coca Cola Z', fournisseur: 'Promocash' },                // Coca Cola Zéro Slim
  { designation: 'Cristalline p', fournisseur: 'Promocash' },              // Cristalline pétillante
  { designation: 'Farine Ble', fournisseur: 'Promocash' },
  { designation: 'Oignons jaune', fournisseur: 'Promocash' },
  { designation: 'Oignons Rouges', fournisseur: 'Promocash' },
  { designation: 'Tiramisu', fournisseur: 'Promocash' },

  // Delidrinks (3)
  { designation: 'Eau min', fournisseur: 'DELIDRINKS' },                   // Eau minérale pétillante
  { designation: 'Eau neuve plate', fournisseur: 'DELIDRINKS' },
  { designation: 'Jus litchi Maya', fournisseur: 'DELIDRINKS' },

  // TT Foods (2)
  { designation: 'Lait de coco', fournisseur: 'TT Foods' },
  { designation: 'Poudre soupe pho', fournisseur: 'TT Foods' },

  // Khadispal (3)
  { designation: 'Coca Cola Slim', fournisseur: 'Khadispal' },
  { designation: 'Coca Cola Zero Slim', fournisseur: 'Khadispal' },
  { designation: 'Wings Tex Mex', fournisseur: 'Khadispal' },

  // Mungoo (1)
  { designation: 'Pousses haricot mungo', fournisseur: 'Mungoo' },

  // Franchise Autres (1)
  { designation: 'Lait concentr', fournisseur: 'Franchise' },              // Lait concentré
]

// ── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  console.log(`=== Fix mercuriale prix_unitaire_ht (per-unit → per-colis) ===`)
  console.log(`Mode: ${APPLY ? '🔧 APPLY (écriture en base)' : '👁  DRY RUN (lecture seule)'}`)
  console.log('')

  // 1. Fetch all active mercuriale products
  const { data: products, error: prodErr } = await supabase
    .from('mercuriale')
    .select('id, designation, fournisseur_id, prix_unitaire_ht, unite_stock, coefficient_conversion, conditionnements')
    .eq('actif', true)
    .order('designation')

  if (prodErr) {
    console.error('Supabase error:', prodErr.message)
    process.exit(1)
  }

  // 2. Fetch fournisseurs
  const { data: fournisseurs, error: fournErr } = await supabase
    .from('fournisseurs')
    .select('id, nom')

  if (fournErr) {
    console.error('Supabase error (fournisseurs):', fournErr.message)
    process.exit(1)
  }

  const fournisseurMap = new Map(fournisseurs.map(f => [f.id, f.nom]))
  const fournisseurByName = new Map(fournisseurs.map(f => [f.nom.toLowerCase(), f.id]))

  // 3. Match and prepare updates
  let fixed = 0
  let skipped = 0
  let notFound = 0
  const updates = []

  for (const target of PRODUCTS_TO_FIX) {
    // Find matching product
    const match = products.find(p => {
      const fournNom = fournisseurMap.get(p.fournisseur_id) || ''
      const designMatch = p.designation.toLowerCase().includes(target.designation.toLowerCase())
      const fournMatch = fournNom.toLowerCase().includes(target.fournisseur.toLowerCase())
      return designMatch && fournMatch
    })

    if (!match) {
      console.log(`  ❌ NOT FOUND: "${target.designation}" (${target.fournisseur})`)
      notFound++
      continue
    }

    // Find conditionnement de commande
    const conds = match.conditionnements || []
    const condCommande = conds.find(c => c.utilise_commande === true && c.quantite > 1)

    if (!condCommande) {
      console.log(`  ⏭  NO COND: "${match.designation}" — pas de conditionnement commande avec quantite > 1`)
      skipped++
      continue
    }

    const oldPrix = match.prix_unitaire_ht
    const newPrix = Math.round(oldPrix * condCommande.quantite * 100) / 100 // Round to 2 decimals
    const fournNom = fournisseurMap.get(match.fournisseur_id) || '?'

    console.log(`  ✅ ${match.designation} (${fournNom})`)
    console.log(`     ${oldPrix.toFixed(2)}€ × ${condCommande.quantite} (${condCommande.nom}) → ${newPrix.toFixed(2)}€`)

    updates.push({
      id: match.id,
      designation: match.designation,
      fournisseur: fournNom,
      oldPrix,
      newPrix,
      condQuantite: condCommande.quantite,
      condNom: condCommande.nom,
    })
    fixed++
  }

  console.log('')
  console.log(`=== Résumé ===`)
  console.log(`  À corriger:  ${fixed}`)
  console.log(`  Non trouvés: ${notFound}`)
  console.log(`  Ignorés:     ${skipped}`)
  console.log('')

  // 4. Apply if --apply flag
  if (APPLY && updates.length > 0) {
    console.log('Applying updates to Supabase...')
    let successCount = 0
    let errorCount = 0

    for (const u of updates) {
      const { error } = await supabase
        .from('mercuriale')
        .update({ prix_unitaire_ht: u.newPrix })
        .eq('id', u.id)

      if (error) {
        console.error(`  ❌ Error updating ${u.designation}: ${error.message}`)
        errorCount++
      } else {
        console.log(`  ✅ ${u.designation}: ${u.oldPrix.toFixed(2)}€ → ${u.newPrix.toFixed(2)}€`)
        successCount++
      }
    }

    console.log('')
    console.log(`Done! ${successCount} updated, ${errorCount} errors.`)
  } else if (!APPLY && updates.length > 0) {
    console.log('⚠  DRY RUN — aucun changement appliqué.')
    console.log('   Relancer avec --apply pour appliquer les corrections.')
  }
}

main().catch(err => {
  console.error('Fatal:', err)
  process.exit(1)
})
