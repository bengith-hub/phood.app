import { defineStore } from 'pinia'
import { ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { db } from '@/lib/dexie'
import type { Stock } from '@/types/database'

export const useStocksStore = defineStore('stocks', () => {
  const stocks = ref<Stock[]>([])
  const loading = ref(false)

  async function fetchAll() {
    loading.value = true
    try {
      if (navigator.onLine) {
        const { data, error } = await supabase
          .from('stocks')
          .select('*')
        if (error) throw error
        stocks.value = data as Stock[]
        await db.stocks.clear()
        await db.stocks.bulkPut(data as Stock[])
      } else {
        stocks.value = await db.stocks.toArray()
      }
    } catch {
      stocks.value = await db.stocks.toArray()
    } finally {
      loading.value = false
    }
  }

  function getByIngredient(ingredientId: string) {
    return stocks.value.find(s => s.ingredient_id === ingredientId)
  }

  /** Get all ingredients with stock below their tampon level */
  function stocksBas(
    getIngredient: (id: string) => { stock_tampon: number; nom: string; unite_stock: string } | undefined,
  ) {
    const results: { ingredientId: string; nom: string; quantite: number; tampon: number; unite: string }[] = []

    for (const s of stocks.value) {
      const ing = getIngredient(s.ingredient_id)
      if (!ing) continue
      if (s.quantite < ing.stock_tampon) {
        results.push({
          ingredientId: s.ingredient_id,
          nom: ing.nom,
          quantite: s.quantite,
          tampon: ing.stock_tampon,
          unite: ing.unite_stock,
        })
      }
    }

    return results.sort((a, b) => (a.quantite / a.tampon) - (b.quantite / b.tampon))
  }

  return { stocks, loading, fetchAll, getByIngredient, stocksBas }
})
