import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall, restFetchAll } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import type { Mercuriale } from '@/types/database'
import { compressImage, blobToBase64 } from '@/lib/image-compress'

export const useMercurialeStore = defineStore('mercuriale', () => {
  const items = ref<Mercuriale[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const actifs = computed(() => items.value.filter(m => m.actif))

  const allCategories = computed(() => {
    const cats = new Set<string>()
    for (const item of items.value) {
      if (item.categorie) cats.add(item.categorie)
    }
    return Array.from(cats).sort((a, b) => a.localeCompare(b, 'fr'))
  })

  function byFournisseur(fournisseurId: string) {
    return actifs.value.filter(m => m.fournisseur_id === fournisseurId)
  }

  function groupedByCategorie(fournisseurId: string) {
    const products = byFournisseur(fournisseurId)
    const groups: Record<string, Mercuriale[]> = {}
    for (const p of products) {
      const cat = p.categorie || 'Sans catégorie'
      if (!groups[cat]) groups[cat] = []
      groups[cat].push(p)
    }
    return Object.entries(groups)
      .sort(([a], [b]) => a.localeCompare(b))
      .map(([categorie, produits]) => ({
        categorie,
        produits: produits.sort((a, b) => a.designation.localeCompare(b.designation)),
      }))
  }

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const data = await restFetchAll<Mercuriale>('mercuriale?select=*&order=designation')
        items.value = data
        await db.mercuriale.clear()
        await db.mercuriale.bulkPut(data)
      } else {
        items.value = await db.mercuriale.orderBy('designation').toArray()
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement mercuriale'
      items.value = await db.mercuriale.orderBy('designation').toArray()
    } finally {
      loading.value = false
    }
  }

  async function save(item: Partial<Mercuriale> & { id?: string }) {
    if (item.id) {
      const { id, ...payload } = item
      await restCall('PATCH', `mercuriale?id=eq.${id}`, payload)
    } else {
      await restCall('POST', 'mercuriale', item)
    }
    await fetchAll()
  }

  async function bulkSetActif(ids: string[], actif: boolean) {
    if (ids.length === 0) return
    const idsParam = `(${ids.join(',')})`
    await restCall('PATCH', `mercuriale?id=in.${idsParam}`, { actif })
    await fetchAll()
  }

  function getById(id: string) {
    return items.value.find(m => m.id === id)
  }

  function search(query: string) {
    const q = query.toLowerCase()
    return actifs.value.filter(m =>
      m.designation.toLowerCase().includes(q) ||
      m.ref_fournisseur?.toLowerCase().includes(q) ||
      m.categorie?.toLowerCase().includes(q)
    )
  }

  async function uploadPhoto(mercurialeId: string, file: File): Promise<string> {
    const compressed = await compressImage(file, 1024, 0.75)
    const base64 = await blobToBase64(compressed)
    const path = `mercuriale/${mercurialeId}_${Date.now()}.jpg`

    const res = await fetch('/.netlify/functions/upload-photo', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        image_base64: base64,
        bucket: 'ingredients-photos',
        path,
      }),
    })
    if (!res.ok) {
      const err = await res.json()
      throw new Error(err.error || 'Erreur upload photo')
    }
    const { url: photoUrl } = await res.json()
    await save({ id: mercurialeId, photo_url: photoUrl } as Partial<Mercuriale> & { id: string })
    return photoUrl
  }

  async function deleteItem(id: string) {
    await restCall('DELETE', `mercuriale?id=eq.${id}`)
    await fetchAll()
  }

  /** Search product photos via web scraping */
  async function searchPhotos(query: string): Promise<{ url: string; thumbnail: string; title: string }[]> {
    let res: Response
    try {
      res = await fetch('/.netlify/functions/search-product-photo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ query }),
      })
    } catch {
      throw new Error('Impossible de contacter le serveur de recherche photo')
    }
    if (!res.ok) {
      let msg = 'Erreur recherche photo'
      try { const err = await res.json(); msg = err.error || msg } catch { /* ignore */ }
      throw new Error(msg)
    }
    const data = await res.json()
    return data.images || []
  }

  /** Download an image from URL (server-side) and upload to Supabase storage */
  async function uploadPhotoFromUrl(mercurialeId: string, imageUrl: string, fallbackUrl?: string): Promise<string> {
    const path = `mercuriale/${mercurialeId}_${Date.now()}.jpg`

    // Download + upload server-side to avoid CORS issues
    let res = await fetch('/.netlify/functions/upload-photo', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        image_url: imageUrl,
        bucket: 'ingredients-photos',
        path,
      }),
    })
    // If full-size URL fails (403, etc.), try thumbnail as fallback
    if (!res.ok && fallbackUrl && fallbackUrl !== imageUrl) {
      res = await fetch('/.netlify/functions/upload-photo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          image_url: fallbackUrl,
          bucket: 'ingredients-photos',
          path,
        }),
      })
    }
    if (!res.ok) {
      let msg = 'Erreur upload photo'
      try { const err = await res.json(); msg = err.error || msg } catch { /* ignore */ }
      throw new Error(msg)
    }
    const { url: photoUrl } = await res.json()
    await save({ id: mercurialeId, photo_url: photoUrl } as Partial<Mercuriale> & { id: string })
    return photoUrl
  }

  return { items, actifs, allCategories, loading, error, fetchAll, save, bulkSetActif, getById, byFournisseur, groupedByCategorie, search, uploadPhoto, uploadPhotoFromUrl, searchPhotos, deleteItem }
})
