import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
import { db } from '@/lib/dexie'
import { compressImage, blobToBase64 } from '@/lib/image-compress'
import type { IngredientRestaurant } from '@/types/database'

/** Ingredient enriched with preferred supplier data (from mercuriale join) */
export interface IngredientEnriched extends IngredientRestaurant {
  mercuriale_photo_url?: string | null
  mercuriale_sku?: string | null
  mercuriale_designation?: string | null
}

export const useIngredientsStore = defineStore('ingredients', () => {
  const ingredients = ref<IngredientEnriched[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const actifs = computed(() => ingredients.value.filter(i => i.actif))

  const categories = computed(() => {
    const cats = new Set<string>()
    for (const i of ingredients.value) {
      if (i.categorie) cats.add(i.categorie)
    }
    return [...cats].sort((a, b) => a.localeCompare(b))
  })

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const { data, error: err } = await supabase
          .from('ingredients_restaurant')
          .select('*, mercuriale_pref:fournisseur_prefere_id(ref_fournisseur, photo_url, designation)')
          .order('nom')
        if (err) throw err
        // Flatten mercuriale join data onto each ingredient
        const enriched: IngredientEnriched[] = (data ?? []).map((row: Record<string, unknown>) => {
          const merc = row.mercuriale_pref as { ref_fournisseur?: string; photo_url?: string; designation?: string } | null
          const { mercuriale_pref: _, ...rest } = row
          return {
            ...rest,
            mercuriale_photo_url: merc?.photo_url ?? null,
            mercuriale_sku: merc?.ref_fournisseur ?? null,
            mercuriale_designation: merc?.designation ?? null,
          } as IngredientEnriched
        })
        ingredients.value = enriched
        await db.ingredients.clear()
        await db.ingredients.bulkPut(enriched as IngredientRestaurant[])
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

  async function save(item: Partial<IngredientRestaurant> & { id?: string }) {
    if (item.id) {
      const { error: err } = await supabase
        .from('ingredients_restaurant')
        .update(item)
        .eq('id', item.id)
      if (err) throw err
    } else {
      const { error: err } = await supabase
        .from('ingredients_restaurant')
        .insert(item)
      if (err) throw err
    }
    await fetchAll()
  }

  async function uploadPhoto(ingredientId: string, file: File): Promise<string> {
    const compressed = await compressImage(file, 1024, 0.75)
    const base64 = await blobToBase64(compressed)
    const path = `ingredients/${ingredientId}_${Date.now()}.jpg`

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
    await save({ id: ingredientId, photo_url: photoUrl } as Partial<IngredientRestaurant> & { id: string })
    return photoUrl
  }

  async function remove(id: string) {
    const { error: err } = await supabase
      .from('ingredients_restaurant')
      .delete()
      .eq('id', id)
    if (err) throw err
    await fetchAll()
  }

  return { ingredients, actifs, categories, loading, error, fetchAll, getById, search, save, uploadPhoto, remove }
})
