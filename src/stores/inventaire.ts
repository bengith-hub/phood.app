import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
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
        const data = await restCall<ZoneStockage[]>('GET', 'zones_stockage?select=*&order=ordre')
        zones.value = data
        await db.zonesStockage.clear()
        await db.zonesStockage.bulkPut(data)
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
        const data = await restCall<Inventaire[]>('GET', 'inventaires?select=*&order=created_at.desc')
        inventaires.value = data
        await db.inventaires.clear()
        await db.inventaires.bulkPut(data)
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
    const data = await restCall<Inventaire>(
      'POST',
      'inventaires',
      {
        nom,
        date: new Date().toISOString().split('T')[0],
        type,
        zones: zoneIds,
        statut: 'en_cours',
        created_by: userId,
      },
      { single: true },
    )
    await fetchAll()
    return data
  }

  // ── Lignes d'inventaire ──────────────────────────────────────────────

  async function fetchLignes(inventaireId: string): Promise<InventaireLigne[]> {
    try {
      if (navigator.onLine) {
        const data = await restCall<InventaireLigne[]>(
          'GET',
          `inventaire_lignes?inventaire_id=eq.${inventaireId}&select=*&order=created_at`,
        )
        lignes.value = data
        // Sync to Dexie
        const existing = await db.inventaireLignes
          .where('inventaire_id')
          .equals(inventaireId)
          .toArray()
        if (existing.length > 0) {
          await db.inventaireLignes.bulkDelete(existing.map(l => l.id))
        }
        await db.inventaireLignes.bulkPut(data)
        return data
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
    await restCall('DELETE', `inventaire_lignes?inventaire_id=eq.${inventaireId}`)

    if (newLignes.length > 0) {
      await restCall('POST', 'inventaire_lignes', newLignes.map(l => ({ ...l, inventaire_id: inventaireId })))
    }
  }

  async function upsertLigne(ligne: Partial<InventaireLigne> & { inventaire_id: string; ingredient_id: string }) {
    // Check if line already exists
    const existing = await restCall<{ id: string } | null>(
      'GET',
      `inventaire_lignes?inventaire_id=eq.${ligne.inventaire_id}&ingredient_id=eq.${ligne.ingredient_id}&select=id`,
      undefined,
      { maybeSingle: true },
    )

    if (existing) {
      await restCall('PATCH', `inventaire_lignes?id=eq.${existing.id}`, {
        quantite_comptee: ligne.quantite_comptee,
        ecart: ligne.ecart,
        conditionnement_saisie: ligne.conditionnement_saisie,
        notes: ligne.notes,
      })
    } else {
      await restCall('POST', 'inventaire_lignes', ligne)
    }
  }

  async function valider(inventaireId: string) {
    await restCall('PATCH', `inventaires?id=eq.${inventaireId}`, { statut: 'valide' })
    await fetchAll()
  }

  /** Update stocks table with inventory counts */
  async function appliquerStocks(
    inventaireId: string,
    lignesFinales: { ingredient_id: string; quantite_comptee: number }[],
  ) {
    for (const ligne of lignesFinales) {
      // Upsert stock row
      const existing = await restCall<{ id: string } | null>(
        'GET',
        `stocks?ingredient_id=eq.${ligne.ingredient_id}&select=id`,
        undefined,
        { maybeSingle: true },
      )

      if (existing) {
        await restCall('PATCH', `stocks?id=eq.${existing.id}`, {
          quantite: ligne.quantite_comptee,
          derniere_maj: new Date().toISOString(),
          source_maj: 'inventaire',
        })
      } else {
        await restCall('POST', 'stocks', {
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
