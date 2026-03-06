// Sync Google Business Profile hours → horaires_ouverture
// Triggered daily at 07:30 via pg_cron → pg_net
// Uses OAuth 2.0 (not service account — GBP requires it)
// Fallback: manual entry in Supabase if GBP API not accessible

import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const GBP_API_BASE = 'https://mybusinessbusinessinformation.googleapis.com/v1'

// Day mapping: GBP uses MONDAY=0..SUNDAY=6, our DB uses 0=dimanche..6=samedi
const GBP_DAY_TO_DB: Record<string, number> = {
  SUNDAY: 0,
  MONDAY: 1,
  TUESDAY: 2,
  WEDNESDAY: 3,
  THURSDAY: 4,
  FRIDAY: 5,
  SATURDAY: 6,
}

interface GBPPeriod {
  openDay: string
  openTime: { hours: number; minutes: number }
  closeDay: string
  closeTime: { hours: number; minutes: number }
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
      .insert({ job_name: 'sync-gbp-hours', status: 'running' })
      .select('id')
      .single()

    const startTime = Date.now()

    // OAuth 2.0 token refresh (GBP requires OAuth, not service account)
    const gbpRefreshToken = Deno.env.get('GBP_REFRESH_TOKEN')
    const googleClientId = Deno.env.get('GOOGLE_CLIENT_ID')
    const googleClientSecret = Deno.env.get('GOOGLE_CLIENT_SECRET')
    const gbpLocationName = Deno.env.get('GBP_LOCATION_NAME') // e.g. "locations/12345"

    if (!gbpRefreshToken || !googleClientId || !googleClientSecret || !gbpLocationName) {
      // Fallback: GBP not configured, skip silently
      const durationMs = Date.now() - startTime
      if (log?.id) {
        await supabase
          .from('cron_logs')
          .update({
            status: 'success',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
            error_message: 'GBP not configured — skipped (using manual hours)',
          })
          .eq('id', log.id)
      }

      return new Response(
        JSON.stringify({ success: true, skipped: true, reason: 'GBP not configured' }),
        { headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Refresh access token
    const tokenResponse = await fetch('https://oauth2.googleapis.com/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        client_id: googleClientId,
        client_secret: googleClientSecret,
        refresh_token: gbpRefreshToken,
        grant_type: 'refresh_token',
      }),
    })

    if (!tokenResponse.ok) {
      throw new Error(`OAuth token refresh failed: ${tokenResponse.status}`)
    }

    const tokenData = await tokenResponse.json()
    const accessToken = tokenData.access_token

    // Fetch location details including hours
    const locationResponse = await fetch(
      `${GBP_API_BASE}/${gbpLocationName}?readMask=regularHours`,
      {
        headers: {
          'Authorization': `Bearer ${accessToken}`,
          'Accept': 'application/json',
        },
      }
    )

    if (!locationResponse.ok) {
      throw new Error(`GBP API error: ${locationResponse.status}`)
    }

    const location = await locationResponse.json()
    const periods: GBPPeriod[] = location.regularHours?.periods || []

    // Build hours map (all days default to closed)
    const hoursMap: Record<number, { ouverture: string; fermeture: string; ferme: boolean }> = {}
    for (let d = 0; d <= 6; d++) {
      hoursMap[d] = { ouverture: '10:00', fermeture: '22:00', ferme: true }
    }

    for (const period of periods) {
      const dayNum = GBP_DAY_TO_DB[period.openDay]
      if (dayNum === undefined) continue

      const openTime = `${String(period.openTime.hours).padStart(2, '0')}:${String(period.openTime.minutes || 0).padStart(2, '0')}`
      const closeTime = `${String(period.closeTime.hours).padStart(2, '0')}:${String(period.closeTime.minutes || 0).padStart(2, '0')}`

      hoursMap[dayNum] = {
        ouverture: openTime,
        fermeture: closeTime,
        ferme: false,
      }
    }

    // Upsert all 7 days
    let upsertCount = 0
    for (const [dayStr, hours] of Object.entries(hoursMap)) {
      const jourSemaine = parseInt(dayStr)

      // Delete existing for this day, then insert (simple approach for 7 rows)
      await supabase
        .from('horaires_ouverture')
        .delete()
        .eq('jour_semaine', jourSemaine)
        .eq('source', 'gbp')

      const { error } = await supabase
        .from('horaires_ouverture')
        .upsert(
          {
            jour_semaine: jourSemaine,
            heure_ouverture: hours.ouverture,
            heure_fermeture: hours.fermeture,
            est_ferme: hours.ferme,
            source: 'gbp',
            updated_at: new Date().toISOString(),
          },
          { onConflict: 'jour_semaine' }
        )

      if (error) {
        console.error(`Error upserting hours for day ${jourSemaine}:`, error)
      } else {
        upsertCount++
      }
    }

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
      JSON.stringify({ success: true, days_updated: upsertCount }),
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
        job_name: 'sync-gbp-hours',
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
