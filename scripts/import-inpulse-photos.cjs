#!/usr/bin/env node
/**
 * Import ingredient photos from inpulse CDN into Supabase Storage.
 *
 * Matches by supplierProduct.id === mercuriale.id (same UUIDs).
 * Downloads images from cdn.deepsight.io, uploads to ingredients-photos bucket,
 * then updates mercuriale.photo_url.
 *
 * Usage:
 *   node scripts/import-inpulse-photos.js [--dry-run]
 */

const fs = require('fs')
const path = require('path')
const https = require('https')
const { createClient } = require('@supabase/supabase-js')

const SUPABASE_URL = 'https://pfcvtpavwjchwdarhixc.supabase.co'
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY
  || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM'

const INPULSE_FILE = path.resolve(
  __dirname,
  '../../Library/CloudStorage/GoogleDrive-benjamin.fetu@phood-restaurant.fr/My Drive/Projet/PhoodApp/inpulse_export_phood_actifs.json'
)

const DRY_RUN = process.argv.includes('--dry-run')
const BUCKET = 'ingredients-photos'

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)

function downloadImage(url) {
  return new Promise((resolve, reject) => {
    const request = (urlStr) => {
      https.get(urlStr, (res) => {
        if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
          request(res.headers.location)
          return
        }
        if (res.statusCode !== 200) {
          reject(new Error(`HTTP ${res.statusCode} for ${urlStr}`))
          return
        }
        const chunks = []
        res.on('data', (chunk) => chunks.push(chunk))
        res.on('end', () => resolve(Buffer.concat(chunks)))
        res.on('error', reject)
      }).on('error', reject)
    }
    request(url)
  })
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms))
}

async function main() {
  console.log('=== Import photos inpulse → Supabase Storage ===')
  console.log(DRY_RUN ? '>>> DRY RUN <<<' : '>>> LIVE MODE <<<')
  console.log('')

  // 1. Read inpulse export
  console.log('Reading inpulse export...')
  const raw = fs.readFileSync(INPULSE_FILE, 'utf-8')
  const data = JSON.parse(raw)

  // 2. Collect all supplier products with images
  const photosToImport = []
  for (const ing of data.ingredients) {
    for (const sp of (ing.supplierProducts || [])) {
      if (sp.img) {
        photosToImport.push({
          mercurialeId: sp.id,
          designation: sp.name,
          imgUrl: sp.img,
        })
      }
    }
  }
  console.log(`  ${photosToImport.length} products with photos in inpulse`)

  // 3. Check which mercuriale records exist and don't have a photo yet
  const { data: existing, error: fetchErr } = await supabase
    .from('mercuriale')
    .select('id, photo_url')
  if (fetchErr) throw fetchErr

  const existingMap = new Map(existing.map(m => [m.id, m.photo_url]))

  const toProcess = photosToImport.filter(p => {
    const exists = existingMap.has(p.mercurialeId)
    const hasPhoto = existingMap.get(p.mercurialeId)
    return exists && !hasPhoto
  })

  console.log(`  ${toProcess.length} photos to import (matching mercuriale, no existing photo)`)
  console.log('')

  if (DRY_RUN) {
    for (const p of toProcess.slice(0, 10)) {
      console.log(`  Would import: ${p.designation} → ${p.imgUrl}`)
    }
    if (toProcess.length > 10) console.log(`  ... and ${toProcess.length - 10} more`)
    console.log('\nDry run complete.')
    return
  }

  // 4. Download and upload each photo
  let success = 0
  let errors = 0

  for (let i = 0; i < toProcess.length; i++) {
    const p = toProcess[i]
    const pct = Math.round(((i + 1) / toProcess.length) * 100)
    process.stdout.write(`\r  [${pct}%] ${i + 1}/${toProcess.length} — ${p.designation}`)

    try {
      // Download from CDN
      const imageBuffer = await downloadImage(p.imgUrl)

      // Upload to Supabase Storage
      const storagePath = `mercuriale/${p.mercurialeId}.jpg`
      const { data: uploadData, error: uploadErr } = await supabase.storage
        .from(BUCKET)
        .upload(storagePath, imageBuffer, {
          contentType: 'image/jpeg',
          upsert: true,
        })
      if (uploadErr) throw uploadErr

      // Get public URL
      const { data: urlData } = supabase.storage
        .from(BUCKET)
        .getPublicUrl(uploadData.path)

      // Update mercuriale record
      const { error: updateErr } = await supabase
        .from('mercuriale')
        .update({ photo_url: urlData.publicUrl })
        .eq('id', p.mercurialeId)
      if (updateErr) throw updateErr

      success++
    } catch (err) {
      errors++
      console.error(`\n  ERROR ${p.designation}: ${err.message}`)
    }

    // Rate limit: small delay between requests
    if (i % 5 === 4) await sleep(200)
  }

  console.log('')
  console.log('')
  console.log(`=== Done: ${success} imported, ${errors} errors ===`)
}

main().catch(err => {
  console.error('Fatal:', err)
  process.exit(1)
})
