// Backup Supabase tables to Google Drive as JSON
// Triggered daily at 04:00 via pg_cron → pg_net
// Uses Google Service Account (same as Gmail/Calendar)
// Backs up: fournisseurs, mercuriale, ingredients_restaurant, recettes,
//   recette_ingredients, commandes, commande_lignes, avoirs, stocks, config

import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const TABLES_TO_BACKUP = [
  'fournisseurs',
  'mercuriale',
  'ingredients_restaurant',
  'recettes',
  'recette_ingredients',
  'commandes',
  'commande_lignes',
  'avoirs',
  'stocks',
  'config',
  'profiles',
  'receptions',
  'reception_lignes',
  'historique_prix',
]

// Google Drive folder ID for backups (set via env)
const DRIVE_FOLDER_ID = Deno.env.get('GOOGLE_DRIVE_BACKUP_FOLDER_ID') || ''

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return new Response('Unauthorized', { status: 401 })
    }

    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const serviceAccountB64 = Deno.env.get('GOOGLE_SERVICE_ACCOUNT_BASE64')

    if (!serviceAccountB64 || !DRIVE_FOLDER_ID) {
      await logResult(supabaseUrl, supabaseKey, 'backup_drive', false, 0,
        'Missing GOOGLE_SERVICE_ACCOUNT_BASE64 or GOOGLE_DRIVE_BACKUP_FOLDER_ID')
      return new Response(JSON.stringify({ error: 'Google Drive not configured' }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const supabase = createClient(supabaseUrl, supabaseKey)

    // Export all tables
    const backupData: Record<string, unknown[]> = {}
    let totalRows = 0

    for (const table of TABLES_TO_BACKUP) {
      const { data, error } = await supabase
        .from(table)
        .select('*')
        .limit(10000)

      if (error) {
        console.error(`Failed to export ${table}:`, error.message)
        backupData[table] = []
      } else {
        backupData[table] = data || []
        totalRows += (data || []).length
      }
    }

    // Create backup JSON
    const backupJson = JSON.stringify({
      created_at: new Date().toISOString(),
      tables: Object.keys(backupData),
      total_rows: totalRows,
      data: backupData,
    }, null, 2)

    // Get Google access token via service account JWT
    const credentials = JSON.parse(atob(serviceAccountB64))
    const accessToken = await getGoogleAccessToken(credentials)

    // Upload to Google Drive
    const dateStr = new Date().toISOString().split('T')[0]
    const fileName = `phood_backup_${dateStr}.json`

    // Delete old backup with same name if exists (keep daily uniqueness)
    await deleteExistingFile(accessToken, fileName, DRIVE_FOLDER_ID)

    // Upload new backup
    const uploadResult = await uploadToDrive(accessToken, fileName, backupJson, DRIVE_FOLDER_ID)

    // Clean up old backups (keep last 30 days)
    await cleanOldBackups(accessToken, DRIVE_FOLDER_ID, 30)

    await logResult(supabaseUrl, supabaseKey, 'backup_drive', true, totalRows, null)

    return new Response(JSON.stringify({
      success: true,
      fileName,
      totalRows,
      fileId: uploadResult.id,
      sizeKb: Math.round(backupJson.length / 1024),
    }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (err) {
    console.error('Backup error:', err)
    return new Response(JSON.stringify({ error: (err as Error).message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

/**
 * Get Google access token using service account JWT (no external deps).
 */
async function getGoogleAccessToken(credentials: {
  client_email: string
  private_key: string
}): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const header = btoa(JSON.stringify({ alg: 'RS256', typ: 'JWT' }))
  const claim = btoa(JSON.stringify({
    iss: credentials.client_email,
    scope: 'https://www.googleapis.com/auth/drive.file',
    aud: 'https://oauth2.googleapis.com/token',
    exp: now + 3600,
    iat: now,
  }))

  const unsignedJwt = `${header}.${claim}`

  // Sign with RSA private key
  const pemContent = credentials.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\n/g, '')

  const binaryKey = Uint8Array.from(atob(pemContent), c => c.charCodeAt(0))
  const cryptoKey = await crypto.subtle.importKey(
    'pkcs8',
    binaryKey,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  )

  const encoder = new TextEncoder()
  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    cryptoKey,
    encoder.encode(unsignedJwt),
  )

  const signatureB64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=+$/, '')

  const jwt = `${unsignedJwt}.${signatureB64}`

  // Exchange JWT for access token
  const tokenResp = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `grant_type=urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Ajwt-bearer&assertion=${jwt}`,
  })

  if (!tokenResp.ok) {
    throw new Error(`Token exchange failed: ${await tokenResp.text()}`)
  }

  const tokenData = await tokenResp.json()
  return tokenData.access_token
}

async function uploadToDrive(
  accessToken: string,
  fileName: string,
  content: string,
  folderId: string,
): Promise<{ id: string }> {
  const metadata = {
    name: fileName,
    mimeType: 'application/json',
    parents: [folderId],
  }

  const boundary = 'phood_backup_boundary'
  const body = [
    `--${boundary}`,
    'Content-Type: application/json; charset=UTF-8',
    '',
    JSON.stringify(metadata),
    `--${boundary}`,
    'Content-Type: application/json',
    '',
    content,
    `--${boundary}--`,
  ].join('\r\n')

  const resp = await fetch(
    'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart',
    {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${accessToken}`,
        'Content-Type': `multipart/related; boundary=${boundary}`,
      },
      body,
    },
  )

  if (!resp.ok) {
    throw new Error(`Drive upload failed: ${await resp.text()}`)
  }

  return await resp.json()
}

async function deleteExistingFile(
  accessToken: string,
  fileName: string,
  folderId: string,
) {
  const resp = await fetch(
    `https://www.googleapis.com/drive/v3/files?q=name='${fileName}'+and+'${folderId}'+in+parents+and+trashed=false&fields=files(id)`,
    {
      headers: { 'Authorization': `Bearer ${accessToken}` },
    },
  )

  if (!resp.ok) return

  const data = await resp.json()
  for (const file of data.files || []) {
    await fetch(`https://www.googleapis.com/drive/v3/files/${file.id}`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${accessToken}` },
    })
  }
}

async function cleanOldBackups(
  accessToken: string,
  folderId: string,
  keepDays: number,
) {
  const cutoff = new Date(Date.now() - keepDays * 86400000).toISOString()
  const resp = await fetch(
    `https://www.googleapis.com/drive/v3/files?q='${folderId}'+in+parents+and+name+contains+'phood_backup_'+and+createdTime<'${cutoff}'+and+trashed=false&fields=files(id,name)`,
    {
      headers: { 'Authorization': `Bearer ${accessToken}` },
    },
  )

  if (!resp.ok) return

  const data = await resp.json()
  for (const file of data.files || []) {
    await fetch(`https://www.googleapis.com/drive/v3/files/${file.id}`, {
      method: 'DELETE',
      headers: { 'Authorization': `Bearer ${accessToken}` },
    })
    console.log(`Deleted old backup: ${file.name}`)
  }
}

async function logResult(
  supabaseUrl: string,
  supabaseKey: string,
  jobName: string,
  success: boolean,
  rowCount: number,
  errorMessage: string | null,
) {
  try {
    await fetch(`${supabaseUrl}/rest/v1/cron_logs`, {
      method: 'POST',
      headers: {
        'apikey': supabaseKey,
        'Authorization': `Bearer ${supabaseKey}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      body: JSON.stringify({
        job_name: jobName,
        success,
        rows_affected: rowCount,
        error_message: errorMessage,
      }),
    })
  } catch {
    // Logging is best-effort
  }
}
