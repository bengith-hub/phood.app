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
