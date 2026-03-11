/**
 * Supabase Edge Function: Sync Zelty orders → decrement stock + update repartition horaire
 *
 * Called daily after sync-zelty-ca, or via webhook when an order is completed.
 * Fetches yesterday's orders from Zelty (with expand[]=items), decomposes each
 * product sold into base ingredients via the recette → recette_ingredients chain,
 * Auto-detects variantes and modificateurs from Zelty modifier NAMES:
 *   - "Normal" → coefficient 1.0, "Grand" → coefficient 1.5
 *   - "Sans X" → find ingredient X by name, skip its decrement
 *   - price > 0 → extra: find matching recette/ingredient, add extra portion
 * No manual mapping needed in PhoodApp — zero config when Zelty options change.
 *
 * Also calculates hourly CA distribution and updates repartition_horaire
 * using an exponential moving average (EMA) with alpha = 0.15.
 *
 * Architecture:
 * 1. Fetch closed orders from Zelty (/orders?expand[]=items) for yesterday
 * 2. For each order item, find the matching recette via zelty_product_id
 * 3. Auto-detect variante by modifier name → apply coefficient
 * 4. Auto-detect "sans" by name prefix → set ingredient decrement to 0
 * 5. Auto-detect extras by price > 0 → find recette/ingredient by name, add portion
 * 6. Recursively decompose recette → ingredients (up to 3 levels of sub-recipes)
 * 7. Apply unit conversion (recipe unite → stock unite) and rendement
 * 8. Call decrement_stock RPC for each base ingredient
 * 9. Calculate hourly CA distribution and update repartition_horaire
 *
 * Zelty API notes:
 * - /orders requires `from` and `to` params (NOT date_min/date_max)
 * - expand[]=items is REQUIRED to get order line items
 * - Default page size is 100, use `limit` and `offset` for pagination
 * - order.created_at is ISO with timezone: "2026-03-07T19:50:44+01:00"
 * - order.price.final_amount_inc_tax is in centimes TTC
 * - order.mode: "takeaway" | "delivery" | "eat_in" | etc.
 * - item.item_id is the Zelty dish ID (= recettes.zelty_product_id)
 * - item.modifiers[].id is the Zelty option value ID (= variantes/modificateurs mapping)
 * - item.modifiers[].type is always "option_value"
 */

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const ZELTY_BASE_URL = 'https://api.zelty.fr/2.10'
const ZELTY_PAGE_SIZE = 200

// ========================================
// Zelty API types
// ========================================

interface ZeltyModifier {
  id: number
  type: string           // "option_value"
  name: string
  quantity: number
  price?: {
    original_amount_inc_tax?: number
  }
}

interface ZeltyItem {
  id: number
  name: string
  type: string           // "dish"
  item_id: string        // Zelty dish ID = recettes.zelty_product_id
  price?: {
    final_amount_inc_tax?: number
  }
  modifiers?: ZeltyModifier[]
}

type OrderChannel = 'sur_place' | 'emporter'

interface ZeltyOrder {
  id: number
  status: string
  mode?: string          // 'takeaway', 'delivery', 'eat_in', etc.
  order_type?: string    // fallback field
  created_at?: string    // "2026-03-07T19:50:44+01:00"
  price?: {
    final_amount_inc_tax?: number  // centimes TTC
    final_amount_exc_tax?: number
  }
  items?: ZeltyItem[]
}

// ========================================
// PhoodApp DB types
// ========================================

interface RecetteIngredient {
  id: string
  recette_id: string
  ingredient_id: string | null
  sous_recette_id: string | null
  quantite: number
  unite: string
  sur_place: boolean
  emporter: boolean
}

interface Recette {
  id: string
  nom: string
  nb_portions: number
  zelty_product_id: string | null
}

interface IngredientInfo {
  nom: string
  unite_stock: string
  rendement: number | null
}

// ========================================
// Helpers
// ========================================

/**
 * Unit conversion factor between recipe unit and stock unit.
 * Same logic as src/lib/unit-conversion.ts (duplicated for Deno Edge Function).
 */
function getUnitFactor(fromUnite: string, toUnite: string): number {
  const from = fromUnite.toLowerCase()
  const to = toUnite.toLowerCase()
  if (from === to) return 1
  if (from === 'kg' && to === 'g') return 1000
  if (from === 'g' && to === 'kg') return 0.001
  if (from === 'l' && to === 'ml') return 1000
  if (from === 'ml' && to === 'l') return 0.001
  if (from === 'l' && to === 'cl') return 100
  if (from === 'cl' && to === 'l') return 0.01
  return 1
}

/**
 * Fetch all orders for a given day from Zelty with pagination.
 * Uses expand[]=items to include order line items with modifiers.
 */
async function fetchDayOrders(apiKey: string, dateStr: string): Promise<ZeltyOrder[]> {
  const allOrders: ZeltyOrder[] = []
  let offset = 0
  const MAX_PAGES = 10

  for (let page = 0; page < MAX_PAGES; page++) {
    const url = `${ZELTY_BASE_URL}/orders?from=${dateStr}T00:00:00&to=${dateStr}T23:59:59&limit=${ZELTY_PAGE_SIZE}&offset=${offset}&expand[]=items`
    const resp = await fetch(url, {
      headers: {
        'Authorization': `Bearer ${apiKey}`,
        'Accept': 'application/json',
      },
    })

    if (!resp.ok) {
      throw new Error(`Zelty API error: ${resp.status} ${resp.statusText}`)
    }

    const data = await resp.json()
    const orders: ZeltyOrder[] = data.orders || []
    allOrders.push(...orders)

    if (orders.length < ZELTY_PAGE_SIZE) break
    offset += ZELTY_PAGE_SIZE
  }

  return allOrders
}

/**
 * Extract local hour from Zelty ISO timestamp.
 * Zelty returns timestamps with timezone offset: "2026-03-07T19:50:44+01:00"
 * The hour in the string IS the local hour (Paris).
 */
function extractLocalHour(timestamp: string | undefined): number | null {
  if (!timestamp) return null
  const match = timestamp.match(/T(\d{2}):/)
  if (match) return parseInt(match[1]!, 10)
  return null
}

// ========================================
// Main handler
// ========================================

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
    const dateStr = yesterday.toISOString().split('T')[0]!

    // Fetch ALL orders from Zelty for yesterday (with items via expand[])
    const orders = await fetchDayOrders(zeltyApiKey, dateStr)

    // Map Zelty mode to our channel
    function getChannel(order: ZeltyOrder): OrderChannel {
      const mode = (order.mode || order.order_type || '').toLowerCase()
      if (mode === 'eat_in' || mode === 'on_site' || mode === 'dine_in') return 'sur_place'
      return 'emporter' // takeaway, delivery, etc.
    }

    // ========================================
    // PART 1: Stock decrement
    // ========================================

    // Load all recettes with zelty_product_id
    const { data: recettes } = await supabase
      .from('recettes')
      .select('id, nom, nb_portions, zelty_product_id')
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

    // Load ingredients for unit conversion + rendement + name matching
    const { data: ingredientsList } = await supabase
      .from('ingredients_restaurant')
      .select('id, nom, unite_stock, rendement')

    const ingredientById = new Map<string, IngredientInfo>()
    for (const ing of (ingredientsList || []) as Array<{ id: string; nom: string; unite_stock: string; rendement: number | null }>) {
      ingredientById.set(ing.id, { nom: ing.nom, unite_stock: ing.unite_stock, rendement: ing.rendement })
    }

    // Recursive decomposition: recette → base ingredients, filtered by channel
    function decomposeRecette(
      recetteId: string,
      multiplier: number,
      channel: OrderChannel,
      depth: number = 0
    ): Map<string, number> {
      const result = new Map<string, number>()
      if (depth > 3) return result // Max 3 levels

      const ings = ingredientsByRecette.get(recetteId) || []
      for (const ri of ings) {
        // Skip ingredient if not used for this channel
        if (channel === 'sur_place' && !ri.sur_place) continue
        if (channel === 'emporter' && !ri.emporter) continue

        const qty = ri.quantite * multiplier

        if (ri.ingredient_id) {
          // Convert recipe unit → stock unit (e.g., 0.15 kg → 150 g)
          const ing = ingredientById.get(ri.ingredient_id)
          let adjustedQty = qty
          if (ing) {
            adjustedQty *= getUnitFactor(ri.unite, ing.unite_stock)
            // Apply rendement: if yield < 1 (e.g., 0.85 = 15% prep loss),
            // we need more raw ingredient: 150g / 0.85 ≈ 176.5g
            if (ing.rendement && ing.rendement > 0 && ing.rendement < 1) {
              adjustedQty /= ing.rendement
            }
          }
          result.set(ri.ingredient_id, (result.get(ri.ingredient_id) || 0) + adjustedQty)
        } else if (ri.sous_recette_id) {
          const subResult = decomposeRecette(ri.sous_recette_id, qty, channel, depth + 1)
          for (const [ingId, subQty] of subResult) {
            result.set(ingId, (result.get(ingId) || 0) + subQty)
          }
        }
      }

      return result
    }

    /**
     * Normalize a French string for fuzzy name matching.
     * Removes accents, lowercases, trims.
     */
    function normalize(name: string): string {
      return name.toLowerCase().trim()
        .replace(/[éèêë]/g, 'e')
        .replace(/[àâä]/g, 'a')
        .replace(/[ùûü]/g, 'u')
        .replace(/[ôö]/g, 'o')
        .replace(/[îï]/g, 'i')
        .replace(/[ç]/g, 'c')
    }

    /**
     * Check if two normalized names match (one contains the other).
     */
    function namesMatch(a: string, b: string): boolean {
      return a.includes(b) || b.includes(a)
    }

    // Build recette lookup by normalized name (for extra matching)
    const allRecettes = (recettes || []) as Recette[]
    const recetteByName = new Map<string, Recette>()
    for (const r of allRecettes) {
      if (r.nom) recetteByName.set(normalize(r.nom), r)
    }

    // --------------------------------------------------------
    // Process each order item with auto-detection by name
    // --------------------------------------------------------
    // Modifier detection heuristic:
    //   "Normal"       → variante coefficient 1.0
    //   "Grand"        → variante coefficient 1.5
    //   "Sans X"       → find ingredient X in recipe, set decrement to 0
    //   price > 0      → extra: find matching recette or ingredient, add portion
    // --------------------------------------------------------
    const allDecrements = new Map<string, number>()
    let itemsProcessed = 0
    let itemsUnmatched = 0
    let variantesApplied = 0
    let sansApplied = 0
    let extrasApplied = 0

    for (const order of orders) {
      const channel = getChannel(order)

      for (const item of (order.items || [])) {
        const zeltyDishId = String(item.item_id)
        const recette = recetteByZelty.get(zeltyDishId)
        if (!recette) {
          itemsUnmatched++
          continue
        }

        // Classify modifiers by name/price
        let varianteCoefficient = 1.0
        const sansNames: string[] = []   // normalized ingredient names to exclude
        const extraNames: string[] = []  // normalized product/ingredient names to add

        for (const mod of (item.modifiers || [])) {
          const modName = (mod.name || '').trim()
          const normalized = normalize(modName)
          const hasPrice = (mod.price?.original_amount_inc_tax || 0) > 0

          if (normalized === 'normal') {
            varianteCoefficient = 1.0
            variantesApplied++
          } else if (normalized === 'grand') {
            varianteCoefficient = 1.5
            variantesApplied++
          } else if (normalized.startsWith('sans ')) {
            sansNames.push(normalized.substring(5))
            sansApplied++
          } else if (hasPrice) {
            // Paid modifier = extra (e.g., "Cheddar fumé", "Poulet")
            extraNames.push(normalized)
            extrasApplied++
          }
        }

        // Decompose base recipe with variante coefficient
        const portionMultiplier = varianteCoefficient / Math.max(1, recette.nb_portions)
        const itemDecrements = decomposeRecette(recette.id, portionMultiplier, channel)

        // Apply "sans": set matching ingredient decrement to 0
        for (const sansName of sansNames) {
          for (const [ingId] of itemDecrements) {
            const ingInfo = ingredientById.get(ingId)
            if (ingInfo && namesMatch(normalize(ingInfo.nom), sansName)) {
              itemDecrements.set(ingId, 0)
            }
          }
        }

        // Apply extras: find matching recette or ingredient, add its portion
        for (const extraName of extraNames) {
          let found = false

          // Try 1: find a recette matching the extra name → decompose 1 portion
          for (const [rName, r] of recetteByName) {
            if (namesMatch(rName, extraName)) {
              const extraDec = decomposeRecette(r.id, 1 / Math.max(1, r.nb_portions), channel)
              for (const [ingId, qty] of extraDec) {
                itemDecrements.set(ingId, (itemDecrements.get(ingId) || 0) + qty)
              }
              found = true
              break
            }
          }

          // Try 2: find ingredient in current recipe and add same qty again (double it)
          if (!found) {
            for (const [ingId, qty] of [...itemDecrements.entries()]) {
              const ingInfo = ingredientById.get(ingId)
              if (ingInfo && qty > 0 && namesMatch(normalize(ingInfo.nom), extraName)) {
                itemDecrements.set(ingId, qty * 2)
                found = true
                break
              }
            }
          }
        }

        // Accumulate into global decrements
        for (const [ingId, qty] of itemDecrements) {
          allDecrements.set(ingId, (allDecrements.get(ingId) || 0) + qty)
        }

        itemsProcessed++
      }
    }

    // Apply all decrements via RPC
    let decrementCount = 0
    for (const [ingredientId, qty] of allDecrements) {
      if (qty > 0) {
        const { error } = await supabase.rpc('decrement_stock', {
          p_ingredient_id: ingredientId,
          p_quantite: Math.round(qty * 1000) / 1000,
        })
        if (!error) decrementCount++
      }
    }

    // ========================================
    // PART 2: Update repartition horaire (EMA)
    // ========================================
    let repartitionUpdated = 0

    const jourSemaine = yesterday.getDay() // 0=Sun, 1=Mon, ...

    // Determine contexte
    const { data: vacancesEvents } = await supabase
      .from('evenements')
      .select('date_debut, date_fin')
      .eq('type', 'vacances')
      .lte('date_debut', dateStr)
      .gte('date_fin', dateStr)

    const isVacances = (vacancesEvents || []).length > 0
    let contexte: string
    if (isVacances) {
      contexte = 'vacances'
    } else if (jourSemaine === 6) {
      contexte = 'samedi'
    } else if (jourSemaine === 0) {
      contexte = 'dimanche'
    } else {
      contexte = 'standard'
    }

    // Aggregate CA by hour
    const hourlyCA: Record<number, number> = {}
    let dayTotalCA = 0

    for (const order of orders) {
      const priceCentimes = order.price?.final_amount_inc_tax || 0
      if (priceCentimes <= 0) continue
      const totalEuros = priceCentimes / 100

      const hour = extractLocalHour(order.created_at)
      if (hour === null || hour < 10 || hour > 21) continue

      hourlyCA[hour] = (hourlyCA[hour] || 0) + totalEuros
      dayTotalCA += totalEuros
    }

    if (dayTotalCA > 0) {
      const todayPcts: Record<number, number> = {}
      for (let h = 10; h <= 21; h++) {
        todayPcts[h] = ((hourlyCA[h] || 0) / dayTotalCA) * 100
      }

      const { data: existingRep } = await supabase
        .from('repartition_horaire')
        .select('creneau_heure, pourcentage')
        .eq('jour_semaine', jourSemaine)
        .eq('contexte', contexte)

      const existingMap = new Map<number, number>()
      for (const r of (existingRep || [])) {
        existingMap.set(r.creneau_heure, r.pourcentage)
      }

      // Apply EMA: new_pct = alpha * today_pct + (1 - alpha) * old_pct
      const ALPHA = 0.15
      const rows: Array<{
        jour_semaine: number
        creneau_heure: number
        pourcentage: number
        contexte: string
        updated_at: string
      }> = []

      for (let h = 10; h <= 21; h++) {
        const todayPct = todayPcts[h] || 0
        const existingPct = existingMap.get(h)

        let newPct: number
        if (existingPct !== undefined && existingPct > 0) {
          newPct = ALPHA * todayPct + (1 - ALPHA) * existingPct
        } else {
          newPct = todayPct
        }

        rows.push({
          jour_semaine: jourSemaine,
          creneau_heure: h,
          pourcentage: Math.round(newPct * 100) / 100,
          contexte,
          updated_at: new Date().toISOString(),
        })
      }

      const { error: repError } = await supabase
        .from('repartition_horaire')
        .upsert(rows, { onConflict: 'jour_semaine,creneau_heure,contexte' })

      if (!repError) {
        repartitionUpdated = rows.length
      } else {
        console.error('Repartition upsert error:', repError)
      }
    }

    // ========================================
    // PART 3: Update nb_tickets in ventes_historique
    // ========================================
    const nbTickets = orders.filter(o => (o.price?.final_amount_inc_tax || 0) > 0).length

    if (nbTickets > 0) {
      const { error: ticketError } = await supabase
        .from('ventes_historique')
        .update({ nb_tickets: nbTickets })
        .eq('date', dateStr)

      if (ticketError) {
        console.error('Error updating nb_tickets:', ticketError)
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
        itemsProcessed,
        itemsUnmatched,
        variantesApplied,
        sansApplied,
        extrasApplied,
        ingredientsDecremented: decrementCount,
        nbTickets,
        repartition: { contexte, updated: repartitionUpdated, dayTotalCA: Math.round(dayTotalCA) },
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
