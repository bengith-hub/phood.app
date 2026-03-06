import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
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
        const { data, error: err } = await supabase
          .from('commandes')
          .select('*')
          .order('created_at', { ascending: false })
        if (err) throw err
        commandes.value = data as Commande[]
        await db.commandes.clear()
        await db.commandes.bulkPut(data as Commande[])
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

    // Count today's orders
    const { count } = await supabase
      .from('commandes')
      .select('*', { count: 'exact', head: true })
      .like('numero', `${prefix}%`)

    const seq = String((count || 0) + 1).padStart(3, '0')
    return `${prefix}-${seq}`
  }

  async function createBrouillon(fournisseurId: string, userId: string): Promise<Commande> {
    const numero = await generateNumero()
    const { data, error: err } = await supabase
      .from('commandes')
      .insert({
        numero,
        fournisseur_id: fournisseurId,
        statut: 'brouillon',
        created_by: userId,
      })
      .select()
      .single()
    if (err) throw err
    await fetchAll()
    return data as Commande
  }

  async function updateStatut(id: string, statut: StatutCommande) {
    const updates: Record<string, unknown> = { statut, updated_at: new Date().toISOString() }
    if (statut === 'envoyee') {
      updates.date_commande = new Date().toISOString().split('T')[0]
    }
    const { error: err } = await supabase
      .from('commandes')
      .update(updates)
      .eq('id', id)
    if (err) throw err
    await fetchAll()
  }

  async function updateCommande(id: string, updates: Partial<Commande>) {
    const { error: err } = await supabase
      .from('commandes')
      .update({ ...updates, updated_at: new Date().toISOString() })
      .eq('id', id)
    if (err) throw err
    await fetchAll()
  }

  async function fetchLignes(commandeId: string): Promise<CommandeLigne[]> {
    const { data, error: err } = await supabase
      .from('commande_lignes')
      .select('*')
      .eq('commande_id', commandeId)
      .order('created_at')
    if (err) throw err
    return data as CommandeLigne[]
  }

  async function saveLignes(commandeId: string, lignes: Partial<CommandeLigne>[]) {
    // Delete existing lines then re-insert
    await supabase
      .from('commande_lignes')
      .delete()
      .eq('commande_id', commandeId)

    if (lignes.length > 0) {
      const { error: err } = await supabase
        .from('commande_lignes')
        .insert(lignes.map(l => ({ ...l, commande_id: commandeId })))
      if (err) throw err
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

  return {
    commandes, loading, error, brouillons, envoyees,
    fetchAll, createBrouillon, updateStatut, updateCommande,
    fetchLignes, saveLignes, getById, generateNumero,
  }
})
