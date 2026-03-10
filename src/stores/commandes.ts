import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import type { Commande, CommandeLigne, StatutCommande } from '@/types/database'

export const useCommandesStore = defineStore('commandes', () => {
  const commandes = ref<Commande[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const byStatut = (statut: StatutCommande) =>
    commandes.value.filter(c => c.statut === statut)

  const brouillons = computed(() => byStatut('brouillon'))
  const envoyees = computed(() => byStatut('envoyee'))

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const data = await restCall<Commande[]>('GET', 'commandes?select=*&order=created_at.desc')
        commandes.value = data
        await db.commandes.clear()
        await db.commandes.bulkPut(data)
      } else {
        commandes.value = await db.commandes.reverse().sortBy('created_at')
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement commandes'
      commandes.value = await db.commandes.reverse().sortBy('created_at')
    } finally {
      loading.value = false
    }
  }

  async function generateNumero(): Promise<string> {
    const today = new Date()
    const prefix = `BC${today.getFullYear()}${String(today.getMonth() + 1).padStart(2, '0')}${String(today.getDate()).padStart(2, '0')}`

    // Count today's orders via HEAD + count
    const count = await restCall<number>(
      'HEAD',
      `commandes?select=*&numero=like.${encodeURIComponent(prefix + '%')}`,
      undefined,
      { prefer: 'count=exact' },
    )

    const seq = String((count || 0) + 1).padStart(3, '0')
    return `${prefix}-${seq}`
  }

  async function createBrouillon(fournisseurId: string, userId: string): Promise<Commande> {
    const numero = await generateNumero()
    const data = await restCall<Commande>(
      'POST',
      'commandes',
      {
        numero,
        fournisseur_id: fournisseurId,
        statut: 'brouillon',
        created_by: userId,
      },
      { single: true },
    )
    await fetchAll()
    return data
  }

  async function updateStatut(id: string, statut: StatutCommande) {
    const updates: Record<string, unknown> = { statut, updated_at: new Date().toISOString() }
    if (statut === 'envoyee') {
      updates.date_commande = new Date().toISOString().split('T')[0]
    }
    await restCall('PATCH', `commandes?id=eq.${id}`, updates)
    await fetchAll()

    // Fire-and-forget Google Calendar sync
    if (statut === 'envoyee' || statut === 'receptionnee') {
      syncCalendarEvent(id, statut).catch(() => {})
    }
  }

  /**
   * Sync delivery event to Google Calendar (fire-and-forget).
   * Creates event on 'envoyee', updates on 'receptionnee'.
   */
  async function syncCalendarEvent(id: string, statut: StatutCommande) {
    try {
      // Load config to get calendar ID
      const configs = await restCall<{ google_calendar_id: string | null }[]>(
        'GET', 'config?select=google_calendar_id&limit=1'
      )
      const calendarId = configs[0]?.google_calendar_id
      if (!calendarId) return // Calendar not configured

      const cmd = commandes.value.find(c => c.id === id)
      if (!cmd) return

      if (statut === 'envoyee') {
        // Fetch order lines for the event description
        const lignes = await fetchLignes(id)
        const lignesDesc = lignes.map(l => `\u2022 ${l.mercuriale_id} \u00d7 ${l.quantite}`).join('\n')

        await fetch('/.netlify/functions/google-calendar', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            action: 'create-delivery',
            calendarId,
            commandeNumero: cmd.numero,
            fournisseurNom: cmd.fournisseur_id, // Will be resolved by caller if needed
            dateLivraison: cmd.date_livraison_prevue || cmd.date_commande,
            nbReferences: lignes.length,
            lignesDescription: lignesDesc,
          }),
        })
      } else if (statut === 'receptionnee') {
        await fetch('/.netlify/functions/google-calendar', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            action: 'update-delivery',
            calendarId,
            commandeNumero: cmd.numero,
            newStatus: 'received',
            fournisseurNom: cmd.fournisseur_id,
          }),
        })
      }
    } catch (e) {
      console.error('Calendar sync failed:', e)
    }
  }

  async function updateCommande(id: string, updates: Partial<Commande>) {
    await restCall('PATCH', `commandes?id=eq.${id}`, { ...updates, updated_at: new Date().toISOString() })
    await fetchAll()
  }

  async function fetchLignes(commandeId: string): Promise<CommandeLigne[]> {
    return await restCall<CommandeLigne[]>('GET', `commande_lignes?commande_id=eq.${commandeId}&select=*&order=created_at`)
  }

  async function saveLignes(commandeId: string, lignes: Partial<CommandeLigne>[]) {
    // Delete existing lines then re-insert
    await restCall('DELETE', `commande_lignes?commande_id=eq.${commandeId}`)

    if (lignes.length > 0) {
      await restCall('POST', 'commande_lignes', lignes.map(l => ({ ...l, commande_id: commandeId })))
    }

    // Recalculate totals
    const totalHt = lignes.reduce((sum, l) => sum + (l.montant_ht || 0), 0)
    const totalTtc = lignes.reduce((sum, l) => sum + (l.montant_ttc || 0), 0)
    await updateCommande(commandeId, {
      montant_total_ht: totalHt,
      montant_total_ttc: totalTtc,
    })
  }

  function getById(id: string) {
    return commandes.value.find(c => c.id === id)
  }

  async function remove(id: string) {
    await restCall('DELETE', `commande_lignes?commande_id=eq.${id}`)
    await restCall('DELETE', `commandes?id=eq.${id}`)
    await fetchAll()
  }

  return {
    commandes, loading, error, brouillons, envoyees,
    fetchAll, createBrouillon, updateStatut, updateCommande,
    fetchLignes, saveLignes, getById, generateNumero, remove,
  }
})
