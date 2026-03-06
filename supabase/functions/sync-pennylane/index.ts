// Sync PennyLane supplier invoices → factures_pennylane
// Triggered daily at 06:30 via pg_cron → pg_net
// Uses changelog polling to fetch new/updated invoices

import { serve } from 'https://deno.land/std@0.208.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const PENNYLANE_BASE_URL = 'https://app.pennylane.com/api/external/v2'
const PAGE_SIZE = 100
// Rate limit: 25 req/5s — we add a small delay between pages
const RATE_LIMIT_DELAY_MS = 250

interface PennyLaneInvoice {
  id: string
  invoice_number: string
  date: string
  amount: number
  currency_amount: number
  supplier?: { id: string; name: string }
  status: string
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

    const pennyLaneToken = Deno.env.get('PENNYLANE_API_TOKEN')
    if (!pennyLaneToken) {
      throw new Error('PENNYLANE_API_TOKEN not configured')
    }

    // Log job start
    const { data: log } = await supabase
      .from('cron_logs')
      .insert({ job_name: 'sync-pennylane', status: 'running' })
      .select('id')
      .single()

    const startTime = Date.now()

    // Get last sync timestamp from most recent successful cron log
    const { data: lastLog } = await supabase
      .from('cron_logs')
      .select('finished_at')
      .eq('job_name', 'sync-pennylane')
      .eq('status', 'success')
      .order('finished_at', { ascending: false })
      .limit(1)
      .single()

    // Default: last 48 hours if no previous sync
    const since = lastLog?.finished_at
      ? new Date(lastLog.finished_at).toISOString()
      : new Date(Date.now() - 48 * 60 * 60 * 1000).toISOString()

    // Fetch changelog for supplier invoices
    const changelogUrl = `${PENNYLANE_BASE_URL}/changelogs/supplier_invoices?since=${since}`
    const changelogResponse = await fetch(changelogUrl, {
      headers: {
        'Authorization': `Bearer ${pennyLaneToken}`,
        'Accept': 'application/json',
      },
    })

    if (!changelogResponse.ok) {
      throw new Error(`PennyLane changelog error: ${changelogResponse.status}`)
    }

    const changelog = await changelogResponse.json()
    const changedIds: string[] = [
      ...(changelog.created || []),
      ...(changelog.updated || []),
    ]

    let syncCount = 0

    // Fetch and upsert each changed invoice
    for (const invoiceId of changedIds) {
      await new Promise((resolve) => setTimeout(resolve, RATE_LIMIT_DELAY_MS))

      const invoiceResponse = await fetch(
        `${PENNYLANE_BASE_URL}/supplier_invoices/${invoiceId}`,
        {
          headers: {
            'Authorization': `Bearer ${pennyLaneToken}`,
            'Accept': 'application/json',
          },
        }
      )

      if (!invoiceResponse.ok) {
        console.error(`Failed to fetch invoice ${invoiceId}: ${invoiceResponse.status}`)
        continue
      }

      const invoice: PennyLaneInvoice = await invoiceResponse.json()

      // Try to match fournisseur by name
      let fournisseurId: string | null = null
      if (invoice.supplier?.name) {
        const { data: fournisseur } = await supabase
          .from('fournisseurs')
          .select('id')
          .ilike('nom', `%${invoice.supplier.name}%`)
          .limit(1)
          .single()
        fournisseurId = fournisseur?.id ?? null
      }

      // Detect "depannage" (emergency purchase without BC)
      // Category "matieres_premieres" + no matching commande = depannage
      const statutRapprochement = 'non_rapprochee'

      const { error } = await supabase
        .from('factures_pennylane')
        .upsert(
          {
            pennylane_id: invoice.id,
            fournisseur_id: fournisseurId,
            numero: invoice.invoice_number,
            date_facture: invoice.date,
            montant_ht: invoice.amount,
            montant_ttc: invoice.currency_amount,
            statut_rapprochement: statutRapprochement,
          },
          { onConflict: 'pennylane_id' }
        )

      if (error) {
        console.error(`Error upserting invoice ${invoice.id}:`, error)
      } else {
        syncCount++
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
        changes_detected: changedIds.length,
        synced: syncCount,
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
        job_name: 'sync-pennylane',
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
