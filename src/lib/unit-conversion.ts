import type { Mercuriale } from '@/types/database'

/**
 * Get the unit scaling factor between conditioning unit and stock unit.
 * E.g., conditioning in kg but stock in g → factor = 1000
 */
export function getUnitFactor(condUnite: string, stockUnite: string): number {
  const cu = condUnite.toLowerCase()
  const su = stockUnite.toLowerCase()

  // Weight: kg ↔ g
  if (cu === 'kg' && su === 'g') return 1000
  if (cu === 'g' && su === 'kg') return 0.001

  // Volume: L ↔ mL, L ↔ cl
  if (cu === 'l' && su === 'ml') return 1000
  if (cu === 'ml' && su === 'l') return 0.001
  if (cu === 'l' && su === 'cl') return 100
  if (cu === 'cl' && su === 'l') return 0.01

  // Cross-dimension: volume ↔ weight (assume density ≈ 1, i.e. 1 L ≈ 1 kg)
  if (cu === 'l' && su === 'g') return 1000
  if (cu === 'g' && su === 'l') return 0.001
  if (cu === 'l' && su === 'kg') return 1
  if (cu === 'kg' && su === 'l') return 1
  if (cu === 'ml' && su === 'g') return 1
  if (cu === 'g' && su === 'ml') return 1
  if (cu === 'kg' && su === 'ml') return 1000
  if (cu === 'ml' && su === 'kg') return 0.001
  if (cu === 'cl' && su === 'g') return 10
  if (cu === 'g' && su === 'cl') return 0.1
  if (cu === 'kg' && su === 'cl') return 100
  if (cu === 'cl' && su === 'kg') return 0.01

  // Same unit or count-based (unite, piece, botte) → no conversion
  return 1
}

/**
 * Determine the conditioning unit from the mercuriale product.
 * Uses the `utilise_commande` conditioning if available, otherwise falls back to unite_stock.
 */
export function getConditioningUnit(merc: Pick<Mercuriale, 'conditionnements' | 'unite_stock'>): string {
  const cond = merc.conditionnements?.find(c => c.utilise_commande)
  return cond?.unite || merc.unite_stock
}

/**
 * Convert an ordered quantity (in packs/colis) to stock units (g, mL, etc.)
 *
 * Example: 3 sacs of 25kg with stock in grams → 3 × 25 × 1000 = 75,000 g
 *
 * @param qty - Number of packs ordered (e.g., 3 sacs)
 * @param coefficient - coefficient_conversion from mercuriale (e.g., 25 for 25kg sac)
 * @param condUnite - Unit of the conditioning (e.g., 'kg')
 * @param stockUnite - Unit of the stock (e.g., 'g')
 */
export function toStockUnits(
  qty: number,
  coefficient: number,
  condUnite: string,
  stockUnite: string,
): number {
  const base = qty * coefficient
  return base * getUnitFactor(condUnite, stockUnite)
}

/**
 * Inverse of toStockUnits: convert stock units back to order units (packs/colis).
 * Useful for converting a recommendation in stock units to how many packs to order.
 */
export function fromStockUnits(
  qtyStock: number,
  coefficient: number,
  condUnite: string,
  stockUnite: string,
): number {
  const factor = getUnitFactor(condUnite, stockUnite)
  if (coefficient === 0 || factor === 0) return 0
  return qtyStock / (coefficient * factor)
}

/**
 * Get the facturation conditioning from a mercuriale product.
 *
 * Priority:
 * 1. Explicit unite_facturation field (e.g. 'kg', 'L', 'unite')
 * 2. Heuristic: weight/volume → base unit (kg, L); count → commande conditioning
 *
 * prix_unitaire_ht is always expressed per facturation unit.
 * E.g. Chicken Wings: unite_facturation = 'kg' → prix = 6.831 €/kg
 */
export function getFacturationConditioning(
  merc: Pick<Mercuriale, 'conditionnements' | 'unite_stock' | 'unite_facturation' | 'coefficient_conversion'>,
): { quantite: number; unite: string } {
  // 1. Explicit unite_facturation field
  if (merc.unite_facturation) {
    return { quantite: 1, unite: merc.unite_facturation }
  }

  const conds = merc.conditionnements ?? []

  // 2. For weight/volume products, the facturation is per base unit (kg, L)
  const su = (merc.unite_stock || '').toLowerCase()
  const isWeightVolume = ['g', 'kg', 'ml', 'cl', 'l'].includes(su)

  if (isWeightVolume) {
    const baseCond = conds.find(c => c.quantite <= 1 && !c.utilise_commande)
    if (baseCond) return { quantite: baseCond.quantite, unite: baseCond.unite }
    const baseUnit = ['g', 'kg'].includes(su) ? 'kg' : 'l'
    return { quantite: 1, unite: baseUnit }
  }

  // 3. Count products → facturation = commande conditioning
  const cmdCond = conds.find(c => c.utilise_commande)
  if (cmdCond) return { quantite: cmdCond.quantite, unite: cmdCond.unite }

  return { quantite: merc.coefficient_conversion || 1, unite: merc.unite_stock }
}

/**
 * Calculate cout_unitaire (cost per stock unit) for an ingredient
 * from its preferred mercuriale product.
 *
 * prix_unitaire_ht is per facturation conditioning (e.g. €/kg).
 * We convert to the ingredient's stock unit.
 *
 * Example: Chicken Wings at 6.831 €/kg, ingredient stock in g
 *   → facturation = {quantite: 1, unite: 'kg'}
 *   → 6.831 / (1 × 1000) = 0.006831 €/g
 *
 * Conversion case (cross-dimension with explicit conversion):
 *   Sucre dose: prix=3.275€/kg, coeff=5, conversion: 5kg = 1000 unite
 *   → prix_colis = 3.275 × 5 = 16.375€
 *   → cout/dosette = 16.375 / 1000 = 0.016375 €/dosette
 *
 * Bridge case: facturation is count-based (unite/piece) but ingredient in weight/volume
 *   → Use coefficient_conversion + unite_commande to bridge dimensions
 *   → E.g. bidon 3kg at 2.81€/bidon → 2.81 / (1 × 3 × 1000) = 0.000937 €/g
 */
export function calculateCoutUnitaire(
  merc: Pick<Mercuriale, 'prix_unitaire_ht' | 'coefficient_conversion' | 'conditionnements' | 'unite_stock' | 'unite_facturation' | 'unite_commande' | 'conversion_quantite' | 'conversion_unite'>,
  ingredientUniteStock: string,
): number {
  if (!merc.prix_unitaire_ht || merc.prix_unitaire_ht <= 0) return 0

  // Explicit conversion: e.g. 5 kg = 1000 unite
  // prix_colis = prix_unitaire × coefficient_conversion
  // cout_per_unit = prix_colis / conversion_quantite
  if (merc.conversion_quantite && merc.conversion_quantite > 0 && merc.conversion_unite) {
    const convUnite = merc.conversion_unite.toLowerCase()
    const isu = ingredientUniteStock.toLowerCase()
    const coeff = merc.coefficient_conversion || 1
    const prixColis = merc.prix_unitaire_ht * coeff
    const coutParConvUnit = prixColis / merc.conversion_quantite
    // If conversion unite matches ingredient stock unit, done
    if (convUnite === isu) return coutParConvUnit
    // Otherwise convert (e.g. conversion in kg but stock in g)
    const factor = getUnitFactor(convUnite, isu)
    return factor > 0 ? coutParConvUnit / factor : 0
  }

  const fact = getFacturationConditioning(merc)

  const fu = fact.unite.toLowerCase()
  const isu = ingredientUniteStock.toLowerCase()
  const isFactCount = !['g', 'kg', 'ml', 'cl', 'l'].includes(fu)
  const isIngWeightVolume = ['g', 'kg', 'ml', 'cl', 'l'].includes(isu)

  // Bridge: facturation in count (unite/piece/bidon) but ingredient in weight/volume
  if (isFactCount && isIngWeightVolume) {
    const coeff = merc.coefficient_conversion || 1
    // Use unite_commande (e.g. 'kg') for the dimensional conversion
    const bridgeUnit = (merc.unite_commande || merc.unite_stock || 'kg').toLowerCase()
    const factor = getUnitFactor(bridgeUnit, isu)
    const divisor = fact.quantite * coeff * factor
    return divisor > 0 ? merc.prix_unitaire_ht / divisor : 0
  }

  // Standard case: same dimension conversion
  const factor = getUnitFactor(fu, isu)
  const divisor = fact.quantite * factor
  if (divisor <= 0) return 0
  return merc.prix_unitaire_ht / divisor
}
