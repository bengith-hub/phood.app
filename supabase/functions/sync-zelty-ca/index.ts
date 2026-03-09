// Sync Zelty closures → ventes_historique
// Triggered daily at 06:00 via pg_cron → pg_net
// Fetches closures from Zelty API and upserts yesterday's data

import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10'

interface ZeltyClosure {
  id: number
  date: string
  turnover: number // CA TTC in centimes
  taxes: number    // Taxes in centimes
}

serve(async (req) => {
  try {
    // Verify authorization (service_role key from pg_net)
    const authHeader = req.headers.get('Authorization')
    if (!authHeader?.startsWith('Bearer ')) {
      return new Response('Unauthorized', { status: 401 })
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const zeltyApiKey = Deno.env.get('ZELTY_API_KEY')
    if (!zeltyApiKey) {
      throw new Error('ZELTY_API_KEY not configured')
    }

    // Log job start
    const { data: log } = await supabase
      .from('cron_logs')
      .insert({ job_name: 'sync-zelty-ca', status: 'running' })
      .select('id')
      .single()

    const startTime = Date.now()

    // Fetch closures from Zelty
    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    const dateStr = yesterday.toISOString().split('T')[0]

    const response = await fetch(`${ZELTY_BASE_URL}/closures`, {
      headers: {
        'Authorization': `Bearer ${zeltyApiKey}`,
        'Accept': 'application/json',
      },
    })

    if (!response.ok) {
      throw new Error(`Zelty API error: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    const closures: ZeltyClosure[] = data.closures || []

    // Filter for yesterday's closures and pick the one with highest turnover
    // (Zelty can create a duplicate empty closure at midnight)
    const yesterdayClosures = closures.filter(c => c.date === dateStr)

    let upsertCount = 0

    if (yesterdayClosures.length > 0) {
      // Keep the closure with highest turnover (the real one)
      const best = yesterdayClosures.reduce((a, b) => (b.turnover || 0) > (a.turnover || 0) ? b : a)

      const { error } = await supabase
        .from('ventes_historique')
        .upsert(
          {
            date: best.date,
            ca_ttc: (best.turnover || 0) / 100, // centimes → euros
            nb_tickets: 0,
            nb_couverts: null,
            cloture_validee: true,
            zelty_closure_id: String(best.id),
          },
          { onConflict: 'date' }
        )

      if (error) {
        console.error(`Error upserting closure for ${best.date}:`, error)
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
      JSON.stringify({ success: true, date: dateStr, upserted: upsertCount }),
      { headers: { 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    // Log job error
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )
    await supabase
      .from('cron_logs')
      .insert({
        job_name: 'sync-zelty-ca',
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
