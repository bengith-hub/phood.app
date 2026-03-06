import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import { db } from '@/lib/dexie'
import type { IngredientRestaurant } from '@/types/database'

export const useIngredientsStore = defineStore('ingredients', () => {
  const ingredients = ref<IngredientRestaurant[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const actifs = computed(() => ingredients.value.filter(i => i.actif))

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const { data, error: err } = await supabase
          .from('ingredients_restaurant')
          .select('*')
          .order('nom')
        if (err) throw err
        ingredients.value = data as IngredientRestaurant[]
        await db.ingredients.clear()
        await db.ingredients.bulkPut(data as IngredientRestaurant[])
      } else {
        ingredients.value = await db.ingredients.orderBy('nom').toArray()
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement ingrédients'
      ingredients.value = await db.ingredients.orderBy('nom').toArray()
    } finally {
      loading.value = false
    }
  }

  function getById(id: string) {
    return ingredients.value.find(i => i.id === id)
  }

  function search(query: string) {
    const q = query.toLowerCase()
    return actifs.value.filter(i =>
      i.nom.toLowerCase().includes(q) ||
      i.categorie?.toLowerCase().includes(q) ||
      i.allergenes.some(a => a.toLowerCase().includes(q)) ||
      i.contient?.toLowerCase().includes(q)
    )
  }

  return { ingredients, actifs, loading, error, fetchAll, getById, search }
})
