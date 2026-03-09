import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import type { Fournisseur } from '@/types/database'

export const useFournisseursStore = defineStore('fournisseurs', () => {
  const fournisseurs = ref<Fournisseur[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const actifs = computed(() => fournisseurs.value.filter(f => f.actif))

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const data = await restCall<Fournisseur[]>('GET', 'fournisseurs?select=*&order=nom')
        fournisseurs.value = data
        await db.fournisseurs.clear()
        await db.fournisseurs.bulkPut(data)
      } else {
        fournisseurs.value = await db.fournisseurs.orderBy('nom').toArray()
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement fournisseurs'
      fournisseurs.value = await db.fournisseurs.orderBy('nom').toArray()
    } finally {
      loading.value = false
    }
  }

  async function save(fournisseur: Partial<Fournisseur> & { id?: string }) {
    if (fournisseur.id) {
      const { id, ...payload } = fournisseur
      const data = await restCall<{ id: string }[]>('PATCH', `fournisseurs?id=eq.${id}`, payload as Record<string, unknown>)
      if (!data || data.length === 0) {
        throw new Error('Sauvegarde refusée — session expirée ou droits insuffisants. Reconnectez-vous.')
      }
    } else {
      const data = await restCall<{ id: string }[]>('POST', 'fournisseurs', fournisseur as Record<string, unknown>)
      if (!data || data.length === 0) {
        throw new Error('Création refusée — session expirée ou droits insuffisants. Reconnectez-vous.')
      }
    }
    await fetchAll()
  }

  function getById(id: string) {
    return fournisseurs.value.find(f => f.id === id)
  }

  async function remove(id: string) {
    await restCall('DELETE', `fournisseurs?id=eq.${id}`)
    await fetchAll()
  }

  async function deactivate(id: string) {
    await restCall('PATCH', `fournisseurs?id=eq.${id}`, { actif: false })
    await fetchAll()
  }

  /** Delete fournisseur + all associated mercuriale products (cascade) */
  async function removeWithProducts(id: string) {
    const produits = await restCall<{ id: string }[]>('GET', `mercuriale?fournisseur_id=eq.${id}&select=id`)
    const produitIds = produits.map(p => p.id)

    if (produitIds.length > 0) {
      const idsFilter = produitIds.map(pid => `"${pid}"`).join(',')
      await restCall('PATCH', `ingredients_restaurant?fournisseur_prefere_id=in.(${idsFilter})`, { fournisseur_prefere_id: null })
      await restCall('DELETE', `mercuriale?fournisseur_id=eq.${id}`)
    }

    await restCall('DELETE', `fournisseurs?id=eq.${id}`)
    await fetchAll()
  }

  return { fournisseurs, actifs, loading, error, fetchAll, save, getById, remove, deactivate, removeWithProducts }
})
