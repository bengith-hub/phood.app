#!/usr/bin/env node
/**
 * Fix unite_commande values on mercuriale products.
 * Most products had unite_commande='kg' from inpulse import, which is wrong for:
 * - Count products (should be 'unite')
 * - Liquid products (should be 'L')
 *
 * Usage:
 *   node scripts/fix-unite-commande.cjs --dry-run
 *   node scripts/fix-unite-commande.cjs --live
 */
const { createClient } = require('@supabase/supabase-js')

const DRY_RUN = process.argv.includes('--dry-run')
const LIVE = process.argv.includes('--live')
if (!DRY_RUN && !LIVE) {
  console.log('Usage: node scripts/fix-unite-commande.cjs --dry-run|--live')
  process.exit(1)
}

const sb = createClient(
  'https://pfcvtpavwjchwdarhixc.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'
)

async function main() {
  console.log(`Mode: ${DRY_RUN ? 'DRY RUN' : 'LIVE'}`)
  const { data } = await sb.from('mercuriale')
    .select('id, designation, unite_commande, unite_facturation, conditionnements')
    .eq('actif', true)

  const weightUnits = ['g', 'kg']
  const volumeUnits = ['l', 'ml', 'cl']
  let fixed = 0

  for (const m of data) {
    const uf = (m.unite_facturation || '').toLowerCase()
    let newUC = m.unite_commande

    if (weightUnits.includes(uf)) {
      newUC = 'kg'
    } else if (volumeUnits.includes(uf)) {
      newUC = 'L'
    } else {
      // Count-based → always 'unite'
      newUC = 'unite'
    }

    if (newUC !== m.unite_commande) {
      console.log(`  ${m.designation.substring(0, 50).padEnd(50)} ${m.unite_commande} → ${newUC}`)
      if (LIVE) {
        const { error } = await sb.from('mercuriale').update({ unite_commande: newUC }).eq('id', m.id)
        if (error) console.error(`    ERROR: ${error.message}`)
      }
      fixed++
    }
  }

  console.log(`\n${DRY_RUN ? 'Would fix' : 'Fixed'}: ${fixed} / ${data.length} products`)
  if (DRY_RUN && fixed > 0) console.log('Re-run with --live to apply.')
}

main().catch(e => { console.error(e); process.exit(1) })
