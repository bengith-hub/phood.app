#!/usr/bin/env node
/**
 * Fix conditionnements for Pak Emballages products
 *
 * Problem: The base conditionnement (quantite=1) has bad names like
 * "unit", "unité", "1", or the product name itself. Should be "pièce".
 *
 * Usage:
 *   node scripts/fix-pak-emballages-conditionnements.cjs --dry-run
 *   node scripts/fix-pak-emballages-conditionnements.cjs --live
 */

const { createClient } = require('@supabase/supabase-js')

const DRY_RUN = process.argv.includes('--dry-run')
const LIVE = process.argv.includes('--live')

if (!DRY_RUN && !LIVE) {
  console.log('Usage: node scripts/fix-pak-emballages-conditionnements.cjs --dry-run|--live')
  process.exit(1)
}

const supabase = createClient(
  'https://pfcvtpavwjchwdarhixc.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'
)

const PAK_FOURNISSEUR_ID = '60bb1420-c0a6-11ec-959c-5b5037aeef23'

async function main() {
  console.log(`Mode: ${DRY_RUN ? 'DRY RUN' : 'LIVE'}`)
  console.log('---')

  // Fetch all Pak Emballages products
  const { data: products, error } = await supabase
    .from('mercuriale')
    .select('id, designation, conditionnements')
    .eq('fournisseur_id', PAK_FOURNISSEUR_ID)
    .order('designation')

  if (error) { console.error('Fetch error:', error); process.exit(1) }

  console.log(`Found ${products.length} Pak Emballages products\n`)

  let fixCount = 0

  for (const p of products) {
    const conds = p.conditionnements || []
    let changed = false
    const newConds = conds.map(c => {
      // Fix base conditionnement (quantite=1) with bad names
      if (c.quantite === 1 && !c.utilise_commande) {
        const nomLower = (c.nom || '').toLowerCase().trim()
        // Detect bad names: "unit", "unité", "1", or same as product name
        const isBadName = ['unit', 'unité', 'unité ', '1'].includes(nomLower)
          || nomLower === p.designation.toLowerCase().trim()
          || nomLower.startsWith('bol ')
          || nomLower.startsWith('couvercle ')
          || nomLower.startsWith('colis ')
        if (isBadName) {
          changed = true
          console.log(`  [FIX] ${p.designation}: "${c.nom}" → "pièce"`)
          return { ...c, nom: 'pièce' }
        }
      }
      return c
    })

    if (changed) {
      fixCount++
      if (LIVE) {
        const { error: updateErr } = await supabase
          .from('mercuriale')
          .update({ conditionnements: newConds })
          .eq('id', p.id)
        if (updateErr) {
          console.error(`  ERROR updating ${p.designation}:`, updateErr)
        } else {
          console.log(`  ✓ Updated ${p.designation}`)
        }
      }
    } else {
      console.log(`  [OK] ${p.designation} — no fix needed`)
    }
  }

  console.log(`\n--- Summary ---`)
  console.log(`Total products: ${products.length}`)
  console.log(`Fixed: ${fixCount}`)
  console.log(`Mode: ${DRY_RUN ? 'DRY RUN (no changes written)' : 'LIVE'}`)
}

main().catch(e => { console.error(e); process.exit(1) })
