// Sync Open-Meteo weather forecast → meteo_daily
// Triggered daily at 07:00 via pg_cron → pg_net
// Fetches 7-day forecast from Meteo-France models via Open-Meteo (free, no API key)
// Coordinates: Begles (44.83, -0.57)

import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const OPEN_METEO_URL = 'https://api.open-meteo.com/v1/meteofrance'
const LATITUDE = 44.83
const LONGITUDE = -0.57

interface OpenMeteoDaily {
  time: string[]
  temperature_2m_max: number[]
  temperature_2m_min: number[]
  precipitation_sum: number[]
  sunshine_duration: number[]
  cloud_cover_mean: number[]
  weather_code: number[]
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
      .insert({ job_name: 'sync-meteo', status: 'running' })
      .select('id')
      .single()

    const startTime = Date.now()

    // Fetch 7-day forecast
    const params = new URLSearchParams({
      latitude: LATITUDE.toString(),
      longitude: LONGITUDE.toString(),
      daily: [
        'temperature_2m_max',
        'temperature_2m_min',
        'precipitation_sum',
        'sunshine_duration',
        'cloud_cover_mean',
        'weather_code',
      ].join(','),
      timezone: 'Europe/Paris',
    })

    const response = await fetch(`${OPEN_METEO_URL}?${params}`)

    if (!response.ok) {
      throw new Error(`Open-Meteo API error: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    const daily: OpenMeteoDaily = data.daily

    if (!daily?.time?.length) {
      throw new Error('No daily data returned from Open-Meteo')
    }

    let upsertCount = 0

    // Upsert each day's forecast
    for (let i = 0; i < daily.time.length; i++) {
      const { error } = await supabase
        .from('meteo_daily')
        .upsert(
          {
            date: daily.time[i],
            temperature_max: daily.temperature_2m_max[i],
            temperature_min: daily.temperature_2m_min[i],
            precipitation_mm: daily.precipitation_sum[i],
            ensoleillement_secondes: daily.sunshine_duration[i],
            couverture_nuageuse_pct: daily.cloud_cover_mean[i],
            code_meteo: daily.weather_code[i],
          },
          { onConflict: 'date' }
        )

      if (error) {
        console.error(`Error upserting meteo for ${daily.time[i]}:`, error)
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
      JSON.stringify({
        success: true,
        days_forecast: daily.time.length,
        upserted: upsertCount,
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
        job_name: 'sync-meteo',
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
