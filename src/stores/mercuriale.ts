import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import { db } from '@/lib/dexie'
import type { Mercuriale } from '@/types/database'

export const useMercurialeStore = defineStore('mercuriale', () => {
  const items = ref<Mercuriale[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const actifs = computed(() => items.value.filter(m => m.actif))

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
    // Sort categories, sort items within each category
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
        const { data, error: err } = await supabase
          .from('mercuriale')
          .select('*')
          .order('designation')
        if (err) throw err
        items.value = data as Mercuriale[]
        await db.mercuriale.clear()
        await db.mercuriale.bulkPut(data as Mercuriale[])
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
      const { error: err } = await supabase
        .from('mercuriale')
        .update(item)
        .eq('id', item.id)
      if (err) throw err
    } else {
      const { error: err } = await supabase
        .from('mercuriale')
        .insert(item)
      if (err) throw err
    }
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

  return { items, actifs, loading, error, fetchAll, save, getById, byFournisseur, groupedByCategorie, search }
})
