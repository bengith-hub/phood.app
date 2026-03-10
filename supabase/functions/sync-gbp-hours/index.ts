// Sync Google Places API hours → horaires_ouverture
// Triggered daily at 07:30 via pg_cron → pg_net
// Uses Places API (New) with API key — no OAuth needed
// Replaces GBP API which requires special access approval from Google

import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// Places API (New) day mapping: 0=Sunday, 1=Monday, ..., 6=Saturday
// Our DB uses the same convention: 0=dimanche, 1=lundi, ..., 6=samedi
// So no mapping needed — they match directly

interface PlacesPeriod {
  open: { day: number; hour: number; minute: number }
  close: { day: number; hour: number; minute: number }
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

    const placesApiKey = Deno.env.get('GOOGLE_PLACES_API_KEY')
    const placeId = Deno.env.get('PHOOD_BEGLES_PLACE_ID')

    if (!placesApiKey || !placeId) {
      const durationMs = Date.now() - startTime
      if (log?.id) {
        await supabase
          .from('cron_logs')
          .update({
            status: 'success',
            finished_at: new Date().toISOString(),
            duration_ms: durationMs,
            error_message: 'Places API not configured — skipped (using manual hours)',
          })
          .eq('id', log.id)
      }

      return new Response(
        JSON.stringify({ success: true, skipped: true, reason: 'Places API not configured' }),
        { headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Fetch place details with opening hours
    const placesResponse = await fetch(
      `https://places.googleapis.com/v1/places/${placeId}`,
      {
        headers: {
          'X-Goog-Api-Key': placesApiKey,
          'X-Goog-FieldMask': 'regularOpeningHours',
        },
      }
    )

    if (!placesResponse.ok) {
      const errorBody = await placesResponse.text()
      throw new Error(`Places API error ${placesResponse.status}: ${errorBody}`)
    }

    const placeData = await placesResponse.json()
    const periods: PlacesPeriod[] = placeData.regularOpeningHours?.periods || []

    // Build hours map (all days default to closed)
    const hoursMap: Record<number, { ouverture: string; fermeture: string; ferme: boolean }> = {}
    for (let d = 0; d <= 6; d++) {
      hoursMap[d] = { ouverture: '10:00', fermeture: '22:00', ferme: true }
    }

    for (const period of periods) {
      const dayNum = period.open.day
      if (dayNum < 0 || dayNum > 6) continue

      const openTime = `${String(period.open.hour).padStart(2, '0')}:${String(period.open.minute || 0).padStart(2, '0')}`
      const closeTime = `${String(period.close.hour).padStart(2, '0')}:${String(period.close.minute || 0).padStart(2, '0')}`

      hoursMap[dayNum] = {
        ouverture: openTime,
        fermeture: closeTime,
        ferme: false,
      }
    }

    // Replace all 7 days: delete all existing rows, then insert fresh
    // (No UNIQUE constraint on jour_semaine, so upsert doesn't work)
    const { error: deleteError } = await supabase
      .from('horaires_ouverture')
      .delete()
      .gte('jour_semaine', 0) // delete all rows

    if (deleteError) {
      console.error('Error deleting existing hours:', deleteError)
    }

    const rows = Object.entries(hoursMap).map(([dayStr, hours]) => ({
      jour_semaine: parseInt(dayStr),
      heure_ouverture: hours.ouverture,
      heure_fermeture: hours.fermeture,
      est_ferme: hours.ferme,
      source: 'places' as const,
      updated_at: new Date().toISOString(),
    }))

    const { error: insertError } = await supabase
      .from('horaires_ouverture')
      .insert(rows)

    const upsertCount = insertError ? 0 : rows.length
    if (insertError) {
      console.error('Error inserting hours:', insertError)
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
