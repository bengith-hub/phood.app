import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import type { Recette, RecetteIngredient } from '@/types/database'

export const useRecettesStore = defineStore('recettes', () => {
  const recettes = ref<Recette[]>([])
  const recetteIngredients = ref<RecetteIngredient[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  const actives = computed(() => recettes.value.filter(r => r.actif))
  const plats = computed(() => actives.value.filter(r => r.type === 'recette'))
  const sousRecettes = computed(() => actives.value.filter(r => r.type === 'sous_recette'))

  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const [recData, riData] = await Promise.all([
          restCall<Recette[]>('GET', 'recettes?select=*&actif=eq.true&order=nom'),
          restCall<RecetteIngredient[]>('GET', 'recette_ingredients?select=*'),
        ])

        recettes.value = recData
        recetteIngredients.value = riData

        // Cache
        await db.recettes.clear()
        await db.recettes.bulkPut(recData)
        await db.recetteIngredients.clear()
        await db.recetteIngredients.bulkPut(riData)
      } else {
        recettes.value = await db.recettes.orderBy('nom').toArray()
        recetteIngredients.value = await db.recetteIngredients.toArray()
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement recettes'
      recettes.value = await db.recettes.orderBy('nom').toArray()
      recetteIngredients.value = await db.recetteIngredients.toArray()
    } finally {
      loading.value = false
    }
  }

  function getById(id: string) {
    return recettes.value.find(r => r.id === id)
  }

  function getIngredients(recetteId: string) {
    return recetteIngredients.value.filter(ri => ri.recette_id === recetteId)
  }

  /**
   * Calculate cost recursively through sub-recipes (up to 3 levels).
   * Uses ingredients store for base costs.
   */
  function calculateCost(
    recetteId: string,
    getIngredientCost: (id: string) => number,
    depth = 0
  ): number {
    if (depth > 3) return 0 // max 3 levels

    const ingredients = getIngredients(recetteId)
    let total = 0

    for (const ri of ingredients) {
      if (ri.ingredient_id) {
        // Base ingredient
        total += ri.quantite * getIngredientCost(ri.ingredient_id)
      } else if (ri.sous_recette_id) {
        // Sub-recipe: recurse
        const subRecette = getById(ri.sous_recette_id)
        if (subRecette) {
          const subCost = calculateCost(ri.sous_recette_id, getIngredientCost, depth + 1)
          const costPerPortion = subRecette.nb_portions > 0 ? subCost / subRecette.nb_portions : subCost
          total += ri.quantite * costPerPortion
        }
      }
    }

    return total
  }

  /**
   * Get all allergens for a recipe (recursive through sub-recipes + contient field)
   */
  function getAllergens(
    recetteId: string,
    getIngredient: (id: string) => { allergenes: string[]; contient: string | null } | undefined,
    depth = 0
  ): Set<string> {
    if (depth > 3) return new Set()

    const allergens = new Set<string>()
    const ingredients = getIngredients(recetteId)

    for (const ri of ingredients) {
      if (ri.ingredient_id) {
        const ing = getIngredient(ri.ingredient_id)
        if (ing) {
          ing.allergenes.forEach(a => allergens.add(a))
          // Also check "contient" field for pre-made ingredients
          if (ing.contient) {
            // Parse contient for known allergen keywords
            const contientLower = ing.contient.toLowerCase()
            const allergenKeywords: Record<string, string> = {
              'gluten': 'gluten', 'blé': 'gluten', 'froment': 'gluten',
              'crustacé': 'crustaces', 'crevette': 'crustaces',
              'oeuf': 'oeufs', 'œuf': 'oeufs',
              'poisson': 'poissons',
              'arachide': 'arachides', 'cacahuète': 'arachides',
              'soja': 'soja',
              'lait': 'lait', 'lactose': 'lait', 'beurre': 'lait', 'crème': 'lait',
              'noix': 'fruits_a_coque', 'amande': 'fruits_a_coque', 'noisette': 'fruits_a_coque',
              'céleri': 'celeri',
              'moutarde': 'moutarde',
              'sésame': 'sesame',
              'sulfite': 'sulfites', 'dioxyde de soufre': 'sulfites',
              'lupin': 'lupin',
              'mollusque': 'mollusques', 'huître': 'mollusques',
            }
            for (const [keyword, allergen] of Object.entries(allergenKeywords)) {
              if (contientLower.includes(keyword)) allergens.add(allergen)
            }
          }
        }
      } else if (ri.sous_recette_id) {
        const subAllergens = getAllergens(ri.sous_recette_id, getIngredient, depth + 1)
        subAllergens.forEach(a => allergens.add(a))
      }
    }

    return allergens
  }

  /**
   * Find all recipes containing a specific allergen (for counter search)
   */
  function findRecipesWithAllergen(
    allergenQuery: string,
    getIngredient: (id: string) => { allergenes: string[]; contient: string | null } | undefined,
  ): { recette: Recette; allergens: Set<string> }[] {
    const results: { recette: Recette; allergens: Set<string> }[] = []
    const q = allergenQuery.toLowerCase()

    for (const recette of actives.value) {
      // Skip recipes with no ingredients (orphan imports)
      const ris = getIngredients(recette.id)
      if (ris.length === 0) continue

      // Skip non-food artifacts from Inpulse import
      if (/EMP\/LIV|EMP\b.*\bLIV\b/i.test(recette.nom)) continue
      const cat = recette.categorie
      if (cat === 'Test' || cat === 'Kit boitage') continue

      const allergens = getAllergens(recette.id, getIngredient)
      const hasMatch = Array.from(allergens).some(a => a.includes(q))

      if (hasMatch) {
        results.push({ recette, allergens })
      }
    }

    return results
  }

  return {
    recettes, recetteIngredients, loading, error, actives, plats, sousRecettes,
    fetchAll, getById, getIngredients, calculateCost, getAllergens, findRecipesWithAllergen,
  }
})
