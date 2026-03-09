import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
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
      // Try Supabase first
      if (navigator.onLine) {
        const { data, error: err } = await supabase
          .from('fournisseurs')
          .select('*')
          .order('nom')
        if (err) throw err
        fournisseurs.value = data as Fournisseur[]
        // Cache in IndexedDB
        await db.fournisseurs.clear()
        await db.fournisseurs.bulkPut(data as Fournisseur[])
      } else {
        // Fallback to IndexedDB
        fournisseurs.value = await db.fournisseurs.orderBy('nom').toArray()
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement fournisseurs'
      // Try IndexedDB as fallback
      fournisseurs.value = await db.fournisseurs.orderBy('nom').toArray()
    } finally {
      loading.value = false
    }
  }

  /**
   * Direct REST call to Supabase, bypassing the JS client's auth layer.
   * The Supabase JS client's token refresh mechanism can hang indefinitely,
   * blocking all write operations. This function uses fetch() directly
   * with the JWT token read from localStorage.
   */
  async function supabaseRest(
    method: 'POST' | 'PATCH' | 'DELETE',
    table: string,
    body: Record<string, unknown>,
    filter?: string,
  ): Promise<Record<string, unknown>[]> {
    const url = import.meta.env.VITE_SUPABASE_URL as string
    const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string

    // Read JWT from Supabase's localStorage (bypasses the hanging refresh)
    const ref = url.replace('https://', '').split('.')[0]
    const storageKey = `sb-${ref}-auth-token`
    const stored = localStorage.getItem(storageKey)
    let accessToken = anonKey // fallback to anon key
    if (stored) {
      try {
        const parsed = JSON.parse(stored)
        // Supabase v2 stores { access_token, refresh_token, ... } or { currentSession: ... }
        accessToken = parsed.access_token || parsed.currentSession?.access_token || anonKey
      } catch { /* use anon key */ }
    }

    const endpoint = filter
      ? `${url}/rest/v1/${table}?${filter}`
      : `${url}/rest/v1/${table}`

    const controller = new AbortController()
    const timeout = setTimeout(() => controller.abort(), 15000)

    try {
      const resp = await fetch(endpoint, {
        method,
        headers: {
          'Content-Type': 'application/json',
          'apikey': anonKey,
          'Authorization': `Bearer ${accessToken}`,
          'Prefer': 'return=representation',
        },
        body: JSON.stringify(body),
        signal: controller.signal,
      })

      if (!resp.ok) {
        const text = await resp.text().catch(() => '')
        throw new Error(`Erreur ${resp.status}: ${text.slice(0, 200)}`)
      }

      const data = await resp.json()
      return Array.isArray(data) ? data : []
    } catch (e: unknown) {
      if ((e as Error).name === 'AbortError') {
        throw new Error('Timeout (15s) : le serveur ne répond pas. Essayez de vous reconnecter.')
      }
      throw e
    } finally {
      clearTimeout(timeout)
    }
  }

  async function save(fournisseur: Partial<Fournisseur> & { id?: string }) {
    if (fournisseur.id) {
      // Remove id from update payload — it should only be in the .eq() filter
      const { id, ...updatePayload } = fournisseur
      const data = await supabaseRest('PATCH', 'fournisseurs', updatePayload, `id=eq.${id}`)
      if (data.length === 0) {
        throw new Error('Sauvegarde refusée — session expirée ou droits insuffisants. Essayez de vous reconnecter.')
      }
    } else {
      const data = await supabaseRest('POST', 'fournisseurs', fournisseur as Record<string, unknown>)
      if (data.length === 0) {
        throw new Error('Création refusée — session expirée ou droits insuffisants. Essayez de vous reconnecter.')
      }
    }
    await fetchAll()
  }

  function getById(id: string) {
    return fournisseurs.value.find(f => f.id === id)
  }

  async function remove(id: string) {
    const { error: err } = await supabase
      .from('fournisseurs')
      .delete()
      .eq('id', id)
    if (err) throw err
    await fetchAll()
  }

  async function deactivate(id: string) {
    const { error: err } = await supabase
      .from('fournisseurs')
      .update({ actif: false })
      .eq('id', id)
    if (err) throw err
    await fetchAll()
  }

  /** Delete fournisseur + all associated mercuriale products (cascade) */
  async function removeWithProducts(id: string) {
    // 1. Nullify ingredients_restaurant.fournisseur_prefere_id pointing to this supplier's products
    const { data: produits } = await supabase
      .from('mercuriale')
      .select('id')
      .eq('fournisseur_id', id)
    const produitIds = (produits || []).map(p => p.id)

    if (produitIds.length > 0) {
      // Clear fournisseur_prefere_id references to these products
      await supabase
        .from('ingredients_restaurant')
        .update({ fournisseur_prefere_id: null })
        .in('fournisseur_prefere_id', produitIds)

      // Delete all mercuriale products for this supplier
      const { error: delProdErr } = await supabase
        .from('mercuriale')
        .delete()
        .eq('fournisseur_id', id)
      if (delProdErr) throw delProdErr
    }

    // 2. Delete the fournisseur itself
    const { error: err } = await supabase
      .from('fournisseurs')
      .delete()
      .eq('id', id)
    if (err) throw err

    await fetchAll()
  }

  return { fournisseurs, actifs, loading, error, fetchAll, save, getById, remove, deactivate, removeWithProducts }
})
