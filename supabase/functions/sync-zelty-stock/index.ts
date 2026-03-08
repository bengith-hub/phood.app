/**
 * Supabase Edge Function: Sync Zelty orders → decrement stock
 *
 * Called daily after sync-zelty-ca, or via webhook when an order is completed.
 * Fetches yesterday's orders from Zelty, decomposes each product sold into
 * base ingredients via the recette → recette_ingredients → ingredient chain,
 * and decrements stock for each ingredient.
 *
 * Architecture:
 * 1. Fetch closed orders from Zelty (/orders) for yesterday
 * 2. For each order line (product), find the matching recette via zelty_product_id
 * 3. Recursively decompose recette → ingredients (up to 3 levels of sub-recipes)
 * 4. Call decrement_stock RPC for each base ingredient
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface ZeltyOrderLine {
  product_id: string
  quantity: number
  name: string
}

interface ZeltyOrder {
  id: string
  status: string
  items: ZeltyOrderLine[]
}

interface RecetteIngredient {
  id: string
  recette_id: string
  ingredient_id: string | null
  sous_recette_id: string | null
  quantite: number
  unite: string
}

interface Recette {
  id: string
  nb_portions: number
  zelty_product_id: string | null
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const supabaseUrl = Deno.env.get('SUPABASE_URL')!
  const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  const zeltyApiKey = Deno.env.get('ZELTY_API_KEY')!

  const supabase = createClient(supabaseUrl, supabaseKey)

  // Log start
  const { data: logRow } = await supabase
    .from('cron_logs')
    .insert({ job_name: 'sync-zelty-stock', status: 'running' })
    .select('id')
    .single()
  const logId = logRow?.id
  const startTime = Date.now()

  try {
    // Determine date range (yesterday)
    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    const dateStr = yesterday.toISOString().split('T')[0]

    // Fetch orders from Zelty for yesterday
    const zeltyUrl = `https://api.zelty.fr/2.10/orders?date_min=${dateStr}T00:00:00&date_max=${dateStr}T23:59:59&status=closed`
    const zeltyResponse = await fetch(zeltyUrl, {
      headers: { 'Authorization': `Bearer ${zeltyApiKey}` },
    })

    if (!zeltyResponse.ok) {
      throw new Error(`Zelty API error: ${zeltyResponse.status}`)
    }

    const zeltyData = await zeltyResponse.json()
    const orders: ZeltyOrder[] = zeltyData.orders || zeltyData.data || []

    // Aggregate quantities by zelty_product_id
    const productQty = new Map<string, number>()
    for (const order of orders) {
      for (const item of (order.items || [])) {
        const pid = String(item.product_id)
        productQty.set(pid, (productQty.get(pid) || 0) + item.quantity)
      }
    }

    // Load all recettes with zelty_product_id mapping
    const { data: recettes } = await supabase
      .from('recettes')
      .select('id, nb_portions, zelty_product_id')
      .not('zelty_product_id', 'is', null)

    const recetteByZelty = new Map<string, Recette>()
    for (const r of (recettes || []) as Recette[]) {
      if (r.zelty_product_id) {
        recetteByZelty.set(r.zelty_product_id, r)
      }
    }

    // Load all recette_ingredients
    const { data: allIngredients } = await supabase
      .from('recette_ingredients')
      .select('*')

    const ingredientsByRecette = new Map<string, RecetteIngredient[]>()
    for (const ri of (allIngredients || []) as RecetteIngredient[]) {
      const list = ingredientsByRecette.get(ri.recette_id) || []
      list.push(ri)
      ingredientsByRecette.set(ri.recette_id, list)
    }

    // Recursive decomposition: recette → base ingredients
    function decomposeRecette(
      recetteId: string,
      multiplier: number,
      depth: number = 0
    ): Map<string, number> {
      const result = new Map<string, number>()
      if (depth > 3) return result // Max 3 levels

      const ings = ingredientsByRecette.get(recetteId) || []
      for (const ri of ings) {
        const qty = ri.quantite * multiplier

        if (ri.ingredient_id) {
          // Base ingredient
          result.set(ri.ingredient_id, (result.get(ri.ingredient_id) || 0) + qty)
        } else if (ri.sous_recette_id) {
          // Sub-recipe: recurse
          const subResult = decomposeRecette(ri.sous_recette_id, qty, depth + 1)
          for (const [ingId, subQty] of subResult) {
            result.set(ingId, (result.get(ingId) || 0) + subQty)
          }
        }
      }

      return result
    }

    // Process each sold product
    const allDecrements = new Map<string, number>()
    let productsProcessed = 0
    let productsUnmatched = 0

    for (const [zeltyId, qtySold] of productQty) {
      const recette = recetteByZelty.get(zeltyId)
      if (!recette) {
        productsUnmatched++
        continue
      }

      // Decompose: qty sold * (1 / nb_portions) to get ingredient quantities per unit sold
      const portionMultiplier = qtySold / Math.max(1, recette.nb_portions)
      const ingredients = decomposeRecette(recette.id, portionMultiplier)

      for (const [ingId, qty] of ingredients) {
        allDecrements.set(ingId, (allDecrements.get(ingId) || 0) + qty)
      }
      productsProcessed++
    }

    // Apply all decrements
    let decrementCount = 0
    for (const [ingredientId, qty] of allDecrements) {
      if (qty > 0) {
        const { error } = await supabase.rpc('decrement_stock', {
          p_ingredient_id: ingredientId,
          p_quantite: Math.round(qty * 1000) / 1000, // Round to 3 decimals
        })
        if (!error) decrementCount++
      }
    }

    // Log success
    const duration = Date.now() - startTime
    if (logId) {
      await supabase
        .from('cron_logs')
        .update({
          status: 'success',
          finished_at: new Date().toISOString(),
          duration_ms: duration,
          error_message: null,
        })
        .eq('id', logId)
    }

    return new Response(
      JSON.stringify({
        success: true,
        date: dateStr,
        orders: orders.length,
        productsProcessed,
        productsUnmatched,
        ingredientsDecremented: decrementCount,
        duration_ms: duration,
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    const duration = Date.now() - startTime
    const errMsg = error instanceof Error ? error.message : String(error)

    if (logId) {
      await supabase
        .from('cron_logs')
        .update({
          status: 'error',
          finished_at: new Date().toISOString(),
          duration_ms: duration,
          error_message: errMsg,
        })
        .eq('id', logId)
    }

    return new Response(
      JSON.stringify({ error: errMsg }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
