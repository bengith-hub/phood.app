import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import { db } from '@/lib/dexie'
import type { Inventaire, InventaireLigne, ZoneStockage } from '@/types/database'

export const useInventaireStore = defineStore('inventaire', () => {
  const inventaires = ref<Inventaire[]>([])
  const lignes = ref<InventaireLigne[]>([])
  const zones = ref<ZoneStockage[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const enCours = computed(() => inventaires.value.filter(i => i.statut === 'en_cours'))
  const valides = computed(() => inventaires.value.filter(i => i.statut === 'valide'))

  // ── Zones de stockage ────────────────────────────────────────────────

  async function fetchZones() {
    try {
      if (navigator.onLine) {
        const { data, error: err } = await supabase
          .from('zones_stockage')
          .select('*')
          .order('ordre')
        if (err) throw err
        zones.value = data as ZoneStockage[]
        await db.zonesStockage.clear()
        await db.zonesStockage.bulkPut(data as ZoneStockage[])
      } else {
        zones.value = await db.zonesStockage.orderBy('ordre').toArray()
      }
    } catch {
      zones.value = await db.zonesStockage.orderBy('ordre').toArray()
    }
  }

  function getZoneById(id: string) {
    return zones.value.find(z => z.id === id)
  }

  // ── Inventaires ──────────────────────────────────────────────────────

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const { data, error: err } = await supabase
          .from('inventaires')
          .select('*')
          .order('created_at', { ascending: false })
        if (err) throw err
        inventaires.value = data as Inventaire[]
        await db.inventaires.clear()
        await db.inventaires.bulkPut(data as Inventaire[])
      } else {
        inventaires.value = await db.inventaires.reverse().sortBy('created_at')
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement inventaires'
      inventaires.value = await db.inventaires.reverse().sortBy('created_at')
    } finally {
      loading.value = false
    }
  }

  function getById(id: string) {
    return inventaires.value.find(i => i.id === id)
  }

  async function create(
    nom: string,
    type: 'complet' | 'partiel',
    zoneIds: string[],
    userId: string,
  ): Promise<Inventaire> {
    const { data, error: err } = await supabase
      .from('inventaires')
      .insert({
        nom,
        date: new Date().toISOString().split('T')[0],
        type,
        zones: zoneIds,
        statut: 'en_cours',
        created_by: userId,
      })
      .select()
      .single()
    if (err) throw err
    await fetchAll()
    return data as Inventaire
  }

  // ── Lignes d'inventaire ──────────────────────────────────────────────

  async function fetchLignes(inventaireId: string): Promise<InventaireLigne[]> {
    try {
      if (navigator.onLine) {
        const { data, error: err } = await supabase
          .from('inventaire_lignes')
          .select('*')
          .eq('inventaire_id', inventaireId)
          .order('created_at')
        if (err) throw err
        lignes.value = data as InventaireLigne[]
        // Sync to Dexie
        const existing = await db.inventaireLignes
          .where('inventaire_id')
          .equals(inventaireId)
          .toArray()
        if (existing.length > 0) {
          await db.inventaireLignes.bulkDelete(existing.map(l => l.id))
        }
        await db.inventaireLignes.bulkPut(data as InventaireLigne[])
        return data as InventaireLigne[]
      } else {
        const data = await db.inventaireLignes
          .where('inventaire_id')
          .equals(inventaireId)
          .toArray()
        lignes.value = data
        return data
      }
    } catch {
      const data = await db.inventaireLignes
        .where('inventaire_id')
        .equals(inventaireId)
        .toArray()
      lignes.value = data
      return data
    }
  }

  async function saveLignes(inventaireId: string, newLignes: Partial<InventaireLigne>[]) {
    // Delete existing lines for this inventaire then re-insert
    await supabase
      .from('inventaire_lignes')
      .delete()
      .eq('inventaire_id', inventaireId)

    if (newLignes.length > 0) {
      const { error: err } = await supabase
        .from('inventaire_lignes')
        .insert(newLignes.map(l => ({ ...l, inventaire_id: inventaireId })))
      if (err) throw err
    }
  }

  async function upsertLigne(ligne: Partial<InventaireLigne> & { inventaire_id: string; ingredient_id: string }) {
    // Check if line already exists for this inventaire + ingredient
    const { data: existing } = await supabase
      .from('inventaire_lignes')
      .select('id')
      .eq('inventaire_id', ligne.inventaire_id)
      .eq('ingredient_id', ligne.ingredient_id)
      .maybeSingle()

    if (existing) {
      const { error: err } = await supabase
        .from('inventaire_lignes')
        .update({
          quantite_comptee: ligne.quantite_comptee,
          ecart: ligne.ecart,
          conditionnement_saisie: ligne.conditionnement_saisie,
          notes: ligne.notes,
        })
        .eq('id', existing.id)
      if (err) throw err
    } else {
      const { error: err } = await supabase
        .from('inventaire_lignes')
        .insert(ligne)
      if (err) throw err
    }
  }

  async function valider(inventaireId: string) {
    const { error: err } = await supabase
      .from('inventaires')
      .update({ statut: 'valide' })
      .eq('id', inventaireId)
    if (err) throw err
    await fetchAll()
  }

  /** Update stocks table with inventory counts */
  async function appliquerStocks(
    inventaireId: string,
    lignesFinales: { ingredient_id: string; quantite_comptee: number }[],
  ) {
    for (const ligne of lignesFinales) {
      // Upsert stock row
      const { data: existing } = await supabase
        .from('stocks')
        .select('id')
        .eq('ingredient_id', ligne.ingredient_id)
        .maybeSingle()

      if (existing) {
        await supabase
          .from('stocks')
          .update({
            quantite: ligne.quantite_comptee,
            derniere_maj: new Date().toISOString(),
            source_maj: 'inventaire',
          })
          .eq('id', existing.id)
      } else {
        await supabase
          .from('stocks')
          .insert({
            ingredient_id: ligne.ingredient_id,
            quantite: ligne.quantite_comptee,
            derniere_maj: new Date().toISOString(),
            source_maj: 'inventaire',
          })
      }
    }

    // Mark inventaire as validated
    await valider(inventaireId)
  }

  return {
    inventaires,
    lignes,
    zones,
    loading,
    error,
    enCours,
    valides,
    fetchZones,
    getZoneById,
    fetchAll,
    getById,
    create,
    fetchLignes,
    saveLignes,
    upsertLigne,
    valider,
    appliquerStocks,
  }
})
