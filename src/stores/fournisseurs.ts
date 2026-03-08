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

  async function save(fournisseur: Partial<Fournisseur> & { id?: string }) {
    if (fournisseur.id) {
      const { error: err } = await supabase
        .from('fournisseurs')
        .update(fournisseur)
        .eq('id', fournisseur.id)
      if (err) throw err
    } else {
      const { error: err } = await supabase
        .from('fournisseurs')
        .insert(fournisseur)
      if (err) throw err
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

  return { fournisseurs, actifs, loading, error, fetchAll, save, getById, remove, deactivate }
})
