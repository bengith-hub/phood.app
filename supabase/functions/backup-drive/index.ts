// Backup Supabase data → Google Drive
// Triggered daily via pg_cron → pg_net
// Exports all key tables as JSON and uploads to a shared Drive folder
// Uses Google Service Account with Drive API v3

import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { decode as base64Decode } from 'https://deno.land/std@0.208.0/encoding/base64.ts'

// Tables to backup (ordered by importance)
const TABLES_TO_BACKUP = [
  'profiles',
  'config',
  'fournisseurs',
  'categories',
  'ingredients_restaurant',
  'mercuriale',
  'historique_prix',
  'recettes',
  'recette_ingredients',
  'commandes',
  'commande_lignes',
  'receptions',
  'reception_lignes',
  'avoirs',
  'stocks',
  'modeles_inventaires',
  'inventaires',
  'inventaire_lignes',
  'ventes_historique',
  'meteo_daily',
  'evenements',
  'factures_pennylane',
  'achats_hors_commande',
  'horaires_ouverture',
  'repartition_horaire',
  'zones_stockage',
  'notifications',
  'cron_logs',
]

interface GoogleServiceAccount {
  client_email: string
  private_key: string
  token_uri: string
}

/** Create a JWT and exchange it for a Google access token */
async function getGoogleAccessToken(sa: GoogleServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000)
  const header = { alg: 'RS256', typ: 'JWT' }
  const payload = {
    iss: sa.client_email,
    scope: 'https://www.googleapis.com/auth/drive.file',
    aud: sa.token_uri,
    iat: now,
    exp: now + 3600,
  }

  const encoder = new TextEncoder()
  const headerB64 = btoa(JSON.stringify(header)).replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_')
  const payloadB64 = btoa(JSON.stringify(payload)).replace(/=/g, '').replace(/\+/g, '-').replace(/\//g, '_')
  const unsignedToken = `${headerB64}.${payloadB64}`

  // Import RSA private key
  const pemContents = sa.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/, '')
    .replace(/-----END PRIVATE KEY-----/, '')
    .replace(/\n/g, '')
  const binaryKey = base64Decode(pemContents)

  const cryptoKey = await crypto.subtle.importKey(
    'pkcs8',
    binaryKey,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign']
  )

  const signature = await crypto.subtle.sign(
    'RSASSA-PKCS1-v1_5',
    cryptoKey,
    encoder.encode(unsignedToken)
  )

  const signatureB64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')

  const jwt = `${unsignedToken}.${signatureB64}`

  // Exchange JWT for access token
  const tokenResponse = await fetch(sa.token_uri, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  })

  if (!tokenResponse.ok) {
    const err = await tokenResponse.text()
    throw new Error(`Google token exchange failed: ${tokenResponse.status} ${err}`)
  }

  const tokenData = await tokenResponse.json()
  return tokenData.access_token
}

/** Upload a file to Google Drive (create or update) */
async function uploadToDrive(
  accessToken: string,
  fileName: string,
  content: string,
  folderId?: string
): Promise<string> {
  // Check if file already exists in the folder
  let existingFileId: string | null = null
  const query = folderId
    ? `name='${fileName}' and '${folderId}' in parents and trashed=false`
    : `name='${fileName}' and trashed=false`

  const searchResponse = await fetch(
    `https://www.googleapis.com/drive/v3/files?q=${encodeURIComponent(query)}&fields=files(id)`,
    { headers: { 'Authorization': `Bearer ${accessToken}` } }
  )

  if (searchResponse.ok) {
    const searchData = await searchResponse.json()
    if (searchData.files?.length > 0) {
      existingFileId = searchData.files[0].id
    }
  }

  if (existingFileId) {
    // Update existing file
    const updateResponse = await fetch(
      `https://www.googleapis.com/upload/drive/v3/files/${existingFileId}?uploadType=media`,
      {
        method: 'PATCH',
        headers: {
          'Authorization': `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
        body: content,
      }
    )
    if (!updateResponse.ok) {
      throw new Error(`Drive update failed: ${updateResponse.status}`)
    }
    return existingFileId
  } else {
    // Create new file with multipart upload
    const metadata: Record<string, unknown> = {
      name: fileName,
      mimeType: 'application/json',
    }
    if (folderId) {
      metadata.parents = [folderId]
    }

    const boundary = 'backup_boundary_' + Date.now()
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

    const createResponse = await fetch(
      'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart&fields=id',
      {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${accessToken}`,
          'Content-Type': `multipart/related; boundary=${boundary}`,
        },
        body,
      }
    )

    if (!createResponse.ok) {
      const err = await createResponse.text()
      throw new Error(`Drive create failed: ${createResponse.status} ${err}`)
    }

    const createData = await createResponse.json()
    return createData.id
  }
}

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return new Response('Unauthorized', { status: 401 })
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // Log job start
    const { data: log } = await supabase
      .from('cron_logs')
      .insert({ job_name: 'backup-drive', status: 'running' })
      .select('id')
      .single()

    const startTime = Date.now()

    // Parse Google Service Account credentials
    const saBase64 = Deno.env.get('GOOGLE_SERVICE_ACCOUNT_BASE64')
    if (!saBase64) {
      throw new Error('GOOGLE_SERVICE_ACCOUNT_BASE64 not configured')
    }

    const saJson = new TextDecoder().decode(base64Decode(saBase64))
    const serviceAccount: GoogleServiceAccount = JSON.parse(saJson)

    const driveFolderId = Deno.env.get('GOOGLE_DRIVE_BACKUP_FOLDER_ID') || undefined

    // Get Google access token
    const accessToken = await getGoogleAccessToken(serviceAccount)

    // Export each table
    const today = new Date().toISOString().split('T')[0]
    const backupData: Record<string, unknown[]> = {}
    const errors: string[] = []

    for (const table of TABLES_TO_BACKUP) {
      try {
        const { data, error } = await supabase
          .from(table)
          .select('*')
          .limit(50000) // Safety limit

        if (error) {
          errors.push(`${table}: ${error.message}`)
          continue
        }

        backupData[table] = data || []
      } catch (e) {
        errors.push(`${table}: ${(e as Error).message}`)
      }
    }

    // Build backup JSON
    const backup = {
      exported_at: new Date().toISOString(),
      project: 'phood-app',
      tables: Object.keys(backupData).length,
      total_rows: Object.values(backupData).reduce((sum, rows) => sum + rows.length, 0),
      data: backupData,
    }

    const backupJson = JSON.stringify(backup, null, 2)
    const fileName = `phood-backup-${today}.json`

    // Upload to Google Drive
    const fileId = await uploadToDrive(accessToken, fileName, backupJson, driveFolderId)

    // Log job success
    const durationMs = Date.now() - startTime
    if (log?.id) {
      await supabase
        .from('cron_logs')
        .update({
          status: 'success',
          finished_at: new Date().toISOString(),
          duration_ms: durationMs,
        })
        .eq('id', log.id)
    }

    return new Response(
      JSON.stringify({
        success: true,
        file_name: fileName,
        drive_file_id: fileId,
        tables: Object.keys(backupData).length,
        total_rows: backup.total_rows,
        errors: errors.length > 0 ? errors : undefined,
        duration_ms: durationMs,
      }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )
    await supabase
      .from('cron_logs')
      .insert({
        job_name: 'backup-drive',
        status: 'error',
        finished_at: new Date().toISOString(),
        error_message: (error as Error).message,
      })

    return new Response(
      JSON.stringify({ error: (error as Error).message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    )
  }
})
