import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { db } from '@/lib/dexie'
import type { Fournisseur } from '@/types/database'

/**
 * Fournisseurs store — uses direct REST calls to Supabase.
 *
 * The Supabase JS client's auth token refresh mechanism can hang
 * indefinitely, blocking ALL operations (reads and writes).
 * This store bypasses it entirely with fetch() + JWT from localStorage.
 */

const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL as string
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY as string

/** Read the user's JWT from Supabase's localStorage cache */
function getAccessToken(): string {
  try {
    const ref = SUPABASE_URL.replace('https://', '').split('.')[0]
    const stored = localStorage.getItem(`sb-${ref}-auth-token`)
    if (stored) {
      const parsed = JSON.parse(stored)
      return parsed.access_token || parsed.currentSession?.access_token || SUPABASE_ANON_KEY
    }
  } catch { /* ignore */ }
  return SUPABASE_ANON_KEY
}

/** Direct REST call with 10s timeout */
async function restCall<T = unknown>(
  method: 'GET' | 'POST' | 'PATCH' | 'DELETE',
  path: string,
  body?: Record<string, unknown>,
): Promise<T> {
  const controller = new AbortController()
  const timeout = setTimeout(() => controller.abort(), 10000)

  try {
    const headers: Record<string, string> = {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${getAccessToken()}`,
    }
    if (body) {
      headers['Content-Type'] = 'application/json'
      headers['Prefer'] = 'return=representation'
    }

    const resp = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
      method,
      headers,
      body: body ? JSON.stringify(body) : undefined,
      signal: controller.signal,
    })

    if (!resp.ok) {
      const text = await resp.text().catch(() => '')
      throw new Error(`Erreur ${resp.status}: ${text.slice(0, 300)}`)
    }

    const contentType = resp.headers.get('content-type') || ''
    if (contentType.includes('json')) {
      return await resp.json() as T
    }
    return [] as unknown as T
  } catch (e: unknown) {
    if ((e as Error).name === 'AbortError') {
      throw new Error('Timeout : le serveur ne répond pas. Essayez de rafraîchir la page.')
    }
    throw e
  } finally {
    clearTimeout(timeout)
  }
}

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
        // Cache in IndexedDB
        await db.fournisseurs.clear()
        await db.fournisseurs.bulkPut(data)
      } else {
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
    // 1. Get product IDs for this supplier
    const produits = await restCall<{ id: string }[]>('GET', `mercuriale?fournisseur_id=eq.${id}&select=id`)
    const produitIds = produits.map(p => p.id)

    if (produitIds.length > 0) {
      // Clear ingredient references to these products
      const idsFilter = produitIds.map(pid => `"${pid}"`).join(',')
      await restCall('PATCH', `ingredients_restaurant?fournisseur_prefere_id=in.(${idsFilter})`, { fournisseur_prefere_id: null })

      // Delete all mercuriale products for this supplier
      await restCall('DELETE', `mercuriale?fournisseur_id=eq.${id}`)
    }

    // 2. Delete the fournisseur
    await restCall('DELETE', `fournisseurs?id=eq.${id}`)
    await fetchAll()
  }

  return { fournisseurs, actifs, loading, error, fetchAll, save, getById, remove, deactivate, removeWithProducts }
})
