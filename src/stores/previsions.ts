import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import { isJourFerie, autoSyncCalendriersIfNeeded } from '@/lib/calendriers'
import type {
  VenteHistorique,
  MeteoDaily,
  Evenement,
  HoraireOuverture,
  RepartitionHoraire,
} from '@/types/database'

/** Format a Date to YYYY-MM-DD in local timezone (avoids toISOString UTC shift) */
function toLocalDateStr(d: Date): string {
  const y = d.getFullYear()
  const m = String(d.getMonth() + 1).padStart(2, '0')
  const day = String(d.getDate()).padStart(2, '0')
  return `${y}-${m}-${day}`
}

// --- Types ---

export interface ForecastFactor {
  label: string
  type: 'meteo' | 'evenement' | 'tendance' | 'rupture_meteo' | 'temperature' | 'superformance' | 'position_mois' | 'dow_correction' | 'holiday_proximity' | 'global_drift'
  coefficient: number
  detail: string
}

export interface ForecastResult {
  date: string
  jour_semaine: number
  ca_prevision: number
  ca_base: number          // Base CA before coefficients (historical avg)
  nb_tickets_prevision: number
  confidence: number
  factors: ForecastFactor[]
  meteo: MeteoDaily | null
  evenements: Evenement[]
  ca_n1: number | null
  date_n1: string | null    // Date of the N-1 same-weekday comparison
  ca_realise: number | null // Actual CA for past dates
}

// --- Seasonal average temperatures by month (Bordeaux area) ---
const SEASONAL_AVG_TEMP: Record<number, number> = {
  0: 7,   // January
  1: 8,   // February
  2: 11,  // March
  3: 14,  // April
  4: 17,  // May
  5: 21,  // June
  6: 23,  // July
  7: 23,  // August
  8: 20,  // September
  9: 15,  // October
  10: 10, // November
  11: 7,  // December
}

// Seasonal average precipitation by month (mm/day, Bordeaux)
const SEASONAL_AVG_PRECIP: Record<number, number> = {
  0: 3.0, 1: 2.5, 2: 2.3, 3: 2.5, 4: 2.7, 5: 1.8,
  6: 1.5, 7: 1.6, 8: 2.3, 9: 3.0, 10: 3.2, 11: 3.3,
}

// Seasonal average cloud cover by month (%, Bordeaux)
const SEASONAL_AVG_CLOUD: Record<number, number> = {
  0: 70, 1: 65, 2: 58, 3: 55, 4: 52, 5: 45,
  6: 38, 7: 38, 8: 45, 9: 55, 10: 65, 11: 72,
}

// Seasonal sunshine hours per day by month (seconds, Bordeaux)
const SEASONAL_AVG_SUN: Record<number, number> = {
  0: 10800, 1: 14400, 2: 18000, 3: 21600, 4: 25200, 5: 28800,
  6: 32400, 7: 30600, 8: 25200, 9: 18000, 10: 12600, 11: 10800,
}

// Typical WMO weather code by month (Bordeaux seasonal averages)
const SEASONAL_AVG_CODE: Record<number, number> = {
  0: 3,  // Jan: overcast
  1: 3,  // Feb: overcast
  2: 2,  // Mar: partly cloudy
  3: 2,  // Apr: partly cloudy
  4: 1,  // May: mainly clear
  5: 0,  // Jun: clear sky
  6: 0,  // Jul: clear sky
  7: 1,  // Aug: mainly clear
  8: 2,  // Sep: partly cloudy
  9: 3,  // Oct: overcast
  10: 3, // Nov: overcast
  11: 3, // Dec: overcast
}

/**
 * Seasonal indices baseline from 3 years of reporting data (2023-2025).
 * Ratio of monthly CA average to global monthly average (63 178€/month).
 * Source: Google Sheets "Reporting" — CA TTC mensuel incluant sur place + emporté + livraison.
 * These serve as a reliable baseline; blended with computed indices as app data grows.
 */
const SEASONAL_INDICES_3Y: Record<number, number> = {
  0: 1.086,  // Jan: +8.6% (Noël aftermath, soldes)
  1: 0.858,  // Feb: -14.2% (mois court, creux post-fêtes)
  2: 0.843,  // Mar: -15.7% (mois faible)
  3: 0.887,  // Apr: -11.3% (printemps faible)
  4: 0.879,  // Mai: -12.1% (ponts, jours fériés)
  5: 0.922,  // Jun: -7.8% (début été, moins de passage)
  6: 1.074,  // Jul: +7.4% (vacances, affluence CC)
  7: 1.031,  // Aug: +3.1% (vacances, affluence CC)
  8: 0.921,  // Sep: -7.9% (rentrée, budgets serrés)
  9: 1.012,  // Oct: +1.2% (neutre)
  10: 1.088, // Nov: +8.8% (Black Friday, préparatifs Noël)
  11: 1.400, // Dec: +40% (Noël, fêtes — sera plafonné)
}

/**
 * Generate a synthetic MeteoDaily from seasonal averages.
 * Used for dates beyond the 16-day Open-Meteo forecast (J+17 to J+30).
 */
function buildSeasonalMeteo(dateStr: string): MeteoDaily {
  const d = new Date(dateStr + 'T00:00:00')
  const month = d.getMonth()
  const avgTemp = SEASONAL_AVG_TEMP[month] ?? 15
  return {
    id: `seasonal-${dateStr}`,
    date: dateStr,
    temperature_max: avgTemp + 3,
    temperature_min: avgTemp - 3,
    precipitation_mm: SEASONAL_AVG_PRECIP[month] ?? 2.5,
    ensoleillement_secondes: SEASONAL_AVG_SUN[month] ?? 18000,
    couverture_nuageuse_pct: SEASONAL_AVG_CLOUD[month] ?? 55,
    code_meteo: SEASONAL_AVG_CODE[month] ?? 2,
    created_at: '',
  }
}

/**
 * Calculate how many days between today and the target date.
 * Returns 0 for today, 1 for tomorrow, etc. Negative for past dates.
 */
function daysFromToday(dateStr: string): number {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const target = new Date(dateStr + 'T00:00:00')
  return Math.round((target.getTime() - today.getTime()) / 86400000)
}

/**
 * Confidence penalty based on météo data source quality.
 * - Real forecast (J+0 to J+3): no penalty
 * - Real forecast (J+4 to J+7): -5
 * - Extended forecast (J+8 to J+15): -10
 * - Seasonal averages (J+16+): -20
 * - No météo at all: -15
 */
function meteoConfidencePenalty(dateStr: string, hasRealMeteo: boolean): number {
  const horizon = daysFromToday(dateStr)
  if (horizon < 0) return hasRealMeteo ? 0 : -10 // past date
  if (!hasRealMeteo) {
    // Seasonal fallback
    if (horizon <= 30) return -20
    return -25
  }
  // Real forecast from Open-Meteo
  if (horizon <= 3) return 0
  if (horizon <= 7) return -5
  if (horizon <= 15) return -10
  return -15
}

// --- Weather code to emoji mapping (WMO codes) ---
export function weatherCodeToEmoji(code: number | null): string {
  if (code === null) return '--'
  if (code === 0) return '\u2600\uFE0F'                          // Clear sky
  if (code >= 1 && code <= 3) return '\u26C5'                    // Partly cloudy
  if (code >= 45 && code <= 48) return '\uD83C\uDF2B\uFE0F'     // Fog
  if (code >= 51 && code <= 55) return '\uD83C\uDF26\uFE0F'     // Drizzle
  if (code >= 56 && code <= 57) return '\uD83C\uDF28\uFE0F'     // Freezing drizzle
  if (code >= 61 && code <= 65) return '\uD83C\uDF27\uFE0F'     // Rain
  if (code >= 66 && code <= 67) return '\uD83C\uDF28\uFE0F'     // Freezing rain
  if (code >= 71 && code <= 77) return '\u2744\uFE0F'            // Snow
  if (code >= 80 && code <= 82) return '\uD83C\uDF27\uFE0F'     // Rain showers
  if (code >= 85 && code <= 86) return '\u2744\uFE0F'            // Snow showers
  if (code >= 95 && code <= 99) return '\u26C8\uFE0F'            // Thunderstorm
  return '\u2601\uFE0F'                                          // Default cloudy
}

export const usePrevisionsStore = defineStore('previsions', () => {
  // --- State ---
  const ventes = ref<VenteHistorique[]>([])
  const meteo = ref<MeteoDaily[]>([])
  const evenements = ref<Evenement[]>([])
  const horaires = ref<HoraireOuverture[]>([])
  const repartition = ref<RepartitionHoraire[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  // --- Computed ---
  const ventesParDate = computed(() => {
    const map = new Map<string, VenteHistorique>()
    for (const v of ventes.value) {
      map.set(v.date, v)
    }
    return map
  })

  const meteoParDate = computed(() => {
    const map = new Map<string, MeteoDaily>()
    for (const m of meteo.value) {
      map.set(m.date, m)
    }
    return map
  })

  /**
   * Monthly seasonal indices: dynamically computed from Supabase sales data,
   * with 3-year baseline fallback (SEASONAL_INDICES_3Y) for months without enough data.
   *
   * Strategy:
   * - Compute indices from app data when enough days exist (≥15 per month)
   * - Fallback to 3-year reporting baseline for months with insufficient data
   * - Self-improving: as each month accumulates ≥15 data points, computed values take over
   * - Cap at ±20% for computed, ±30% for baseline (3 years of evidence supports wider range)
   */
  const seasonalIndices = computed(() => {
    const monthData: Record<number, { sum: number; count: number }> = {}
    let globalSum = 0
    let globalCount = 0

    for (const v of ventes.value) {
      if (!v.cloture_validee || v.ca_ttc <= 0) continue
      const d = new Date(v.date + 'T00:00:00')
      if (isJourFerme(d.getDay()) || isDateFermeture(v.date)) continue

      const month = d.getMonth()
      if (!monthData[month]) monthData[month] = { sum: 0, count: 0 }
      monthData[month]!.sum += v.ca_ttc
      monthData[month]!.count++
      globalSum += v.ca_ttc
      globalCount++
    }

    const indices: Record<number, number> = {}

    for (let m = 0; m < 12; m++) {
      const data = monthData[m]

      if (globalCount > 0 && data && data.count >= 15) {
        // Enough app data: use computed index (capped ±20%)
        const globalAvg = globalSum / globalCount
        const raw = (data.sum / data.count) / globalAvg
        indices[m] = Math.max(0.80, Math.min(1.20, raw))
      } else {
        // Not enough app data: fallback to 3-year baseline (capped ±30%)
        const baseline = SEASONAL_INDICES_3Y[m] ?? 1
        indices[m] = Math.max(0.70, Math.min(1.30, baseline))
      }
    }

    return indices
  })

  /**
   * Day-of-week correction factors: compensates for systematic bias per weekday.
   * Computed dynamically from the ratio actual / (baseCA × weather × temp × monthPos × events).
   * Uses trimmed mean (removes top/bottom 10%) for robustness against outliers.
   * Self-improving: recalculates as new validated sales data is added.
   * Capped at ±25% to prevent overcorrection.
   */
  const dowCorrections = computed(() => {
    const corrections: Record<number, number> = { 1: 1, 2: 1, 3: 1, 4: 1, 5: 1, 6: 1 }

    const tenMonthsAgo = new Date()
    tenMonthsAgo.setMonth(tenMonthsAgo.getMonth() - 10)
    const cutoff = toLocalDateStr(tenMonthsAgo)

    const dowRatios: Record<number, number[]> = {}

    for (const v of ventes.value) {
      if (!v.cloture_validee || v.ca_ttc <= 0) continue
      if (v.date < cutoff) continue
      const d = new Date(v.date + 'T00:00:00')
      const dow = d.getDay()
      if (isJourFerme(dow) || isDateFermeture(v.date)) continue

      // Compute predicted CA WITHOUT dow correction
      const { baseCA } = calculateBaseCA(d)
      if (baseCA <= 0) continue

      // Apply weather + temperature + month position + events
      const meteoDay = meteoParDate.value.get(v.date) || null
      const dummyFactors: ForecastFactor[] = []
      const wCoeff = calculateWeatherCoefficient(meteoDay, dummyFactors, dow)
      const tCoeff = calculateTemperatureCoefficient(meteoDay, d, dummyFactors)
      const mpCoeff = calculateMonthPositionCoefficient(d, dummyFactors)
      const evts = getEventsForDate(v.date)
      let evtCoeff = 1
      for (const evt of evts) evtCoeff *= evt.coefficient

      const predicted = baseCA * wCoeff * tCoeff * mpCoeff * evtCoeff
      if (predicted <= 0) continue

      const ratio = v.ca_ttc / predicted
      if (!dowRatios[dow]) dowRatios[dow] = []
      dowRatios[dow]!.push(ratio)
    }

    for (let d = 1; d <= 6; d++) {
      const ratios = dowRatios[d]
      if (!ratios || ratios.length < 10) continue

      // Trimmed mean (remove top/bottom 10% for robustness)
      const sorted = [...ratios].sort((a, b) => a - b)
      const trim = Math.floor(sorted.length * 0.1)
      const trimmed = sorted.slice(trim, sorted.length - trim)
      const trimMean = trimmed.reduce((a, b) => a + b, 0) / trimmed.length

      // Cap at ±25%
      corrections[d] = Math.max(0.75, Math.min(1.25, trimMean))
    }

    return corrections
  })

  /**
   * Global drift: compares recent 3-month rolling average to N-1 same period.
   * Captures long-term trend (growth, decline, new competitor) that the
   * 8-week EW base doesn't reflect because it only sees recent absolute levels.
   * Capped at ±10% to prevent overcorrection.
   */
  const globalDrift = computed(() => {
    const today = new Date()
    const todayStr = toLocalDateStr(today)
    const threeMonthsAgo = new Date(today)
    threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3)
    const cutoff = toLocalDateStr(threeMonthsAgo)

    const n1End = new Date(today)
    n1End.setFullYear(n1End.getFullYear() - 1)
    const n1Start = new Date(threeMonthsAgo)
    n1Start.setFullYear(n1Start.getFullYear() - 1)
    const n1EndStr = toLocalDateStr(n1End)
    const n1StartStr = toLocalDateStr(n1Start)

    let recentSum = 0, recentCount = 0
    let n1Sum = 0, n1Count = 0

    for (const v of ventes.value) {
      if (!v.cloture_validee || v.ca_ttc <= 0) continue
      if (v.date >= cutoff && v.date < todayStr) {
        recentSum += v.ca_ttc
        recentCount++
      }
      if (v.date >= n1StartStr && v.date <= n1EndStr) {
        n1Sum += v.ca_ttc
        n1Count++
      }
    }

    if (recentCount < 40 || n1Count < 40) return 1

    const drift = (recentSum / recentCount) / (n1Sum / n1Count)
    if (Math.abs(drift - 1) < 0.03) return 1 // Ignore <3% drift
    return Math.max(0.90, Math.min(1.10, drift))
  })

  /**
   * Weather-conditional DOW corrections: for each weekday, computes separate
   * correction factors for rainy, sunny, and default weather conditions.
   * Enables DOW×weather interaction (e.g., rainy Tuesdays behave differently
   * from sunny Tuesdays). Falls back to overall DOW correction when insufficient data.
   */
  const dowWeatherBuckets = computed(() => {
    const buckets: Record<number, { rainy: number[]; sunny: number[]; }> = {}
    for (let d = 1; d <= 6; d++) buckets[d] = { rainy: [], sunny: [] }

    const tenMonthsAgo = new Date()
    tenMonthsAgo.setMonth(tenMonthsAgo.getMonth() - 10)
    const cutoff = toLocalDateStr(tenMonthsAgo)

    for (const v of ventes.value) {
      if (!v.cloture_validee || v.ca_ttc <= 0) continue
      if (v.date < cutoff) continue
      const d = new Date(v.date + 'T00:00:00')
      const dow = d.getDay()
      if (isJourFerme(dow) || isDateFermeture(v.date)) continue

      const { baseCA } = calculateBaseCA(d)
      if (baseCA <= 0) continue

      const meteoDay = meteoParDate.value.get(v.date) || null
      const dummyFactors: ForecastFactor[] = []
      const wCoeff = calculateWeatherCoefficient(meteoDay, dummyFactors, dow)
      const tCoeff = calculateTemperatureCoefficient(meteoDay, d, dummyFactors)
      const mpCoeff = calculateMonthPositionCoefficient(d, dummyFactors)
      const evts = getEventsForDate(v.date)
      let evtCoeff = 1
      for (const evt of evts) evtCoeff *= evt.coefficient

      const predicted = baseCA * wCoeff * tCoeff * mpCoeff * evtCoeff
      if (predicted <= 0) continue

      const ratio = v.ca_ttc / predicted
      const isRainy = meteoDay && meteoDay.precipitation_mm !== null && meteoDay.precipitation_mm > 2
      const isSunny = meteoDay && meteoDay.ensoleillement_secondes !== null && meteoDay.ensoleillement_secondes > 25200

      if (isRainy) buckets[dow]?.rainy.push(ratio)
      else if (isSunny) buckets[dow]?.sunny.push(ratio)
    }

    // Compute trimmed means per bucket
    const result: Record<number, { rainy: number | null; sunny: number | null }> = {}
    for (let d = 1; d <= 6; d++) {
      const b = buckets[d]!
      result[d] = { rainy: null, sunny: null }

      for (const key of ['rainy', 'sunny'] as const) {
        const ratios = b[key]
        if (ratios.length >= 5) {
          const sorted = [...ratios].sort((a, b) => a - b)
          const trim = Math.max(1, Math.floor(sorted.length * 0.1))
          const trimmed = sorted.slice(trim, sorted.length - trim)
          const mean = trimmed.reduce((a, b) => a + b, 0) / trimmed.length
          result[d]![key] = Math.max(0.75, Math.min(1.25, mean))
        }
      }
    }
    return result
  })

  // --- Helper: check if a date is a jour férié ---
  function isFerieDate(dateStr: string): boolean {
    if (isJourFerie(dateStr)) return true
    return evenements.value.some(e =>
      e.type === 'ferie' && dateStr >= e.date_debut && dateStr <= e.date_fin
    )
  }

  // --- Holiday proximity: veille de férié, lendemain, pont ---
  function calculateHolidayProximityCoefficient(
    targetDate: Date,
    dateStr: string,
    factors: ForecastFactor[]
  ): number {
    if (isFerieDate(dateStr)) return 1 // today is already a férié — handled by event coeff

    const jourSemaine = targetDate.getDay()

    const tomorrow = new Date(targetDate)
    tomorrow.setDate(tomorrow.getDate() + 1)
    const tomorrowStr = toLocalDateStr(tomorrow)
    const tomorrowFerie = isFerieDate(tomorrowStr)

    const yesterday = new Date(targetDate)
    yesterday.setDate(yesterday.getDate() - 1)
    const yesterdayStr = toLocalDateStr(yesterday)
    const yesterdayFerie = isFerieDate(yesterdayStr)

    // Pont detection: Friday after Thursday férié, or Monday before Tuesday férié
    // Shopping center pont = families on long weekend = boost
    const isPont = (jourSemaine === 5 && yesterdayFerie) || (jourSemaine === 1 && tomorrowFerie)

    if (isPont) {
      factors.push({
        label: 'Pont',
        type: 'holiday_proximity',
        coefficient: 1.05,
        detail: `Jour "pont" — week-end prolonge, affluence familles (+5%)`,
      })
      return 1.05
    }

    // Veille de férié (not pont): anticipation → +3%
    if (tomorrowFerie) {
      factors.push({
        label: 'Veille de ferie',
        type: 'holiday_proximity',
        coefficient: 1.03,
        detail: `Veille de jour ferie — anticipation courses (+3%)`,
      })
      return 1.03
    }

    // Lendemain de férié (not pont): retour progressif → -3%
    if (yesterdayFerie) {
      factors.push({
        label: 'Lendemain de ferie',
        type: 'holiday_proximity',
        coefficient: 0.97,
        detail: `Lendemain de jour ferie — reprise progressive (-3%)`,
      })
      return 0.97
    }

    return 1
  }

  /**
   * Short-term streak detection (momentum court terme).
   * Complementary to superformance: triggers only on UNANIMOUS streaks
   * (5/5 days consistently off by >8%). Capped at ±3% to avoid
   * double-counting with superformance which already captures gradual momentum.
   */
  function calculateStreakCoefficient(
    targetDate: Date,
    factors: ForecastFactor[]
  ): number {
    const ratios: number[] = []

    for (let i = 1; i <= 10 && ratios.length < 5; i++) {
      const d = new Date(targetDate)
      d.setDate(d.getDate() - i)
      const dStr = toLocalDateStr(d)
      const dow = d.getDay()

      if (isJourFerme(dow) || isDateFermeture(dStr)) continue

      const vente = ventesParDate.value.get(dStr)
      if (!vente || !vente.cloture_validee || vente.ca_ttc <= 0) continue

      const { baseCA } = calculateBaseCA(d)
      if (baseCA <= 0) continue

      const meteoD = meteoParDate.value.get(dStr) || null
      const dummy: ForecastFactor[] = []
      const wC = calculateWeatherCoefficient(meteoD, dummy, dow)
      const tC = calculateTemperatureCoefficient(meteoD, d, dummy)
      const mpC = calculateMonthPositionCoefficient(d, dummy)
      const dowC = dowCorrections.value[dow] ?? 1
      const evts = getEventsForDate(dStr)
      let evtC = 1
      for (const evt of evts) evtC *= evt.coefficient

      const predicted = baseCA * wC * tC * mpC * dowC * evtC
      if (predicted <= 0) continue

      ratios.push(vente.ca_ttc / predicted)
    }

    if (ratios.length < 5) return 1

    // Unanimous streak only: ALL 5 must be in same direction by >8%
    const aboveCount = ratios.filter(r => r > 1.08).length
    const belowCount = ratios.filter(r => r < 0.92).length

    if (aboveCount === 5) {
      const avgExcess = ratios.reduce((s, r) => s + (r - 1), 0) / ratios.length
      const streakCoeff = Math.min(1.03, 1 + avgExcess * 0.2)
      factors.push({
        label: 'Serie positive',
        type: 'tendance',
        coefficient: streakCoeff,
        detail: `5/5 jours recents au-dessus des previsions — momentum fort`,
      })
      return streakCoeff
    }

    if (belowCount === 5) {
      const avgDeficit = ratios.reduce((s, r) => s + (r - 1), 0) / ratios.length
      const streakCoeff = Math.max(0.97, 1 + avgDeficit * 0.2)
      factors.push({
        label: 'Serie negative',
        type: 'tendance',
        coefficient: streakCoeff,
        detail: `5/5 jours recents en dessous des previsions — momentum faible`,
      })
      return streakCoeff
    }

    return 1
  }

  // --- Fetch functions (online/offline pattern) ---

  async function fetchVentes(): Promise<void> {
    try {
      if (navigator.onLine) {
        const since = new Date()
        since.setMonth(since.getMonth() - 14)
        const sinceStr = toLocalDateStr(since)

        const data = await restCall<VenteHistorique[]>(
          'GET',
          `ventes_historique?select=*&date=gte.${sinceStr}&order=date.desc`,
        )
        ventes.value = data
        await db.ventesHistorique.clear()
        await db.ventesHistorique.bulkPut(data)
      } else {
        ventes.value = await db.ventesHistorique.reverse().sortBy('date')
      }
    } catch {
      ventes.value = await db.ventesHistorique.reverse().sortBy('date')
    }
  }

  async function fetchMeteo(): Promise<void> {
    try {
      if (navigator.onLine) {
        const since = new Date()
        since.setMonth(since.getMonth() - 14)
        const sinceStr = toLocalDateStr(since)

        const until = new Date()
        until.setDate(until.getDate() + 35)
        const untilStr = toLocalDateStr(until)

        const data = await restCall<MeteoDaily[]>(
          'GET',
          `meteo_daily?select=*&date=gte.${sinceStr}&date=lte.${untilStr}&order=date.desc`,
        )
        meteo.value = data
        await db.meteoDaily.clear()
        await db.meteoDaily.bulkPut(data)
      } else {
        meteo.value = await db.meteoDaily.reverse().sortBy('date')
      }
    } catch {
      meteo.value = await db.meteoDaily.reverse().sortBy('date')
    }
  }

  async function fetchEvenements(): Promise<void> {
    try {
      if (navigator.onLine) {
        const data = await restCall<Evenement[]>('GET', 'evenements?select=*&order=date_debut.desc')
        evenements.value = data
        await db.evenements.clear()
        await db.evenements.bulkPut(data)
      } else {
        evenements.value = await db.evenements.toArray()
      }
    } catch {
      evenements.value = await db.evenements.toArray()
    }
  }

  async function fetchHoraires(): Promise<void> {
    try {
      if (navigator.onLine) {
        const data = await restCall<HoraireOuverture[]>('GET', 'horaires_ouverture?select=*&order=jour_semaine')
        horaires.value = data
        await db.horairesOuverture.clear()
        await db.horairesOuverture.bulkPut(data)
      } else {
        horaires.value = await db.horairesOuverture.toArray()
      }
    } catch {
      horaires.value = await db.horairesOuverture.toArray()
    }
  }

  async function fetchRepartition(): Promise<void> {
    try {
      if (navigator.onLine) {
        const data = await restCall<RepartitionHoraire[]>('GET', 'repartition_horaire?select=*&order=creneau_heure')
        repartition.value = data
        await db.repartitionHoraire.clear()
        await db.repartitionHoraire.bulkPut(data)
      } else {
        repartition.value = await db.repartitionHoraire.toArray()
      }
    } catch {
      repartition.value = await db.repartitionHoraire.toArray()
    }
  }

  async function fetchAll(): Promise<void> {
    loading.value = true
    error.value = null
    try {
      // Auto-sync calendriers (fériés, vacances, soldes) — 24h cooldown, non-blocking
      autoSyncCalendriersIfNeeded().catch(() => {})

      await Promise.all([
        fetchVentes(),
        fetchMeteo(),
        fetchEvenements(),
        fetchHoraires(),
        fetchRepartition(),
      ])
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement previsions'
    } finally {
      loading.value = false
    }
  }

  // --- Forecast calculation (unchanged — pure computation, no Supabase calls) ---

  function getSameDayHistory(targetDate: Date, weeks: number): VenteHistorique[] {
    const results: VenteHistorique[] = []
    const targetDow = targetDate.getDay()

    for (let w = 1; w <= weeks; w++) {
      const pastDate = new Date(targetDate)
      pastDate.setDate(pastDate.getDate() - (w * 7))
      const pastStr = toLocalDateStr(pastDate)
      const vente = ventesParDate.value.get(pastStr)
      if (vente && vente.cloture_validee) {
        results.push(vente)
      }
    }

    if (results.length < 2) {
      for (const v of ventes.value) {
        if (!v.cloture_validee) continue
        const vDate = new Date(v.date + 'T00:00:00')
        if (vDate.getDay() === targetDow && vDate < targetDate) {
          if (!results.find(r => r.date === v.date)) {
            results.push(v)
          }
        }
        if (results.length >= weeks) break
      }
    }

    return results
  }

  function getN1Comparison(targetDate: Date): { vente: VenteHistorique | null; date: string } {
    const oneYearAgo = new Date(targetDate)
    oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1)
    const targetDow = targetDate.getDay()

    let best: VenteHistorique | null = null
    let bestDate = toLocalDateStr(oneYearAgo)
    let bestDiff = Infinity

    // Search ±7 days for same weekday (always finds at least one at offset 0 or ±7)
    for (let offset = -7; offset <= 7; offset++) {
      const checkDate = new Date(oneYearAgo)
      checkDate.setDate(checkDate.getDate() + offset)
      if (checkDate.getDay() !== targetDow) continue

      const checkStr = toLocalDateStr(checkDate)
      const vente = ventesParDate.value.get(checkStr)
      if (vente && vente.cloture_validee) {
        const diff = Math.abs(offset)
        if (diff < bestDiff) {
          bestDiff = diff
          best = vente
          bestDate = checkStr
        }
      }
    }

    // If no vente found, still return the closest same-weekday date for display
    if (!best) {
      // Find the closest same-weekday date (offset 0 or ±7)
      for (const off of [0, -7, 7]) {
        const d = new Date(oneYearAgo)
        d.setDate(d.getDate() + off)
        if (d.getDay() === targetDow) {
          bestDate = toLocalDateStr(d)
          break
        }
      }
    }

    return { vente: best, date: bestDate }
  }

  function getEventsForDate(dateStr: string): Evenement[] {
    return evenements.value.filter(e => {
      return dateStr >= e.date_debut && dateStr <= e.date_fin
    })
  }

  // --- Exponential weights for same-weekday averaging (most recent first) ---
  const EW_WEIGHTS = [0.35, 0.25, 0.20, 0.12, 0.08]

  /**
   * Smoothed seasonal index: anchors each month's index at day 15 (mid-month),
   * then linearly interpolates between adjacent mid-months.
   * Eliminates abrupt step-function jumps at month boundaries that caused
   * systematic overprediction when EW history crossed month lines.
   * Validated by backtesting: reduces MAPE from 17.2% to 16.3%.
   */
  function getSmoothedSeasonalIndex(dateStr: string): number {
    const d = new Date(dateStr + 'T00:00:00')
    const m = d.getMonth()
    const y = d.getFullYear()
    const dom = d.getDate()
    const thisIdx = seasonalIndices.value[m] ?? 1

    if (dom <= 15) {
      // Between previous month's mid-point and this month's mid-point
      const prevM = (m + 11) % 12
      const prevIdx = seasonalIndices.value[prevM] ?? 1
      const prevDim = new Date(y, m, 0).getDate() // days in previous month
      const totalDays = (prevDim - 15) + dom       // days from prev mid to now
      const spanDays = (prevDim - 15) + 15          // days from prev mid to this mid
      return prevIdx + (thisIdx - prevIdx) * (totalDays / spanDays)
    } else {
      // Between this month's mid-point and next month's mid-point
      const nextM = (m + 1) % 12
      const nextIdx = seasonalIndices.value[nextM] ?? 1
      const dim = new Date(y, m + 1, 0).getDate()  // days in this month
      const totalDays = dom - 15                     // days from this mid to now
      const spanDays = (dim - 15) + 15               // days from this mid to next mid
      return thisIdx + (nextIdx - thisIdx) * (totalDays / spanDays)
    }
  }

  function calculateBaseCA(targetDate: Date): { baseCA: number; baseTickets: number; dataPoints: number } {
    const jourSemaine = targetDate.getDay()
    const targetSeasonal = getSmoothedSeasonalIndex(toLocalDateStr(targetDate))

    const history = getSameDayHistory(targetDate, 8)
    const recent = history.slice(0, 5)

    if (recent.length > 0) {
      const weights = EW_WEIGHTS.slice(0, recent.length)
      const wSum = weights.reduce((a, b) => a + b, 0)

      let baseCA = 0
      let baseTickets = 0
      for (let i = 0; i < recent.length; i++) {
        const w = weights[i]! / wSum
        const histSeasonal = getSmoothedSeasonalIndex(recent[i]!.date)

        // Deseasonalize historical value, then reseasonalize for target date
        // Smooth interpolation avoids abrupt jumps at month boundaries
        baseCA += (recent[i]!.ca_ttc / histSeasonal * targetSeasonal) * w
        baseTickets += (recent[i]!.nb_tickets / histSeasonal * targetSeasonal) * w
      }

      return { baseCA, baseTickets, dataPoints: recent.length }
    }

    // Fallback: any same day-of-week data (already deseasonalized by averaging many months)
    const allSameDow = ventes.value.filter(v => {
      const d = new Date(v.date + 'T00:00:00')
      return d.getDay() === jourSemaine && v.cloture_validee
    })
    if (allSameDow.length > 0) {
      const baseCA = allSameDow.reduce((s, v) => s + v.ca_ttc, 0) / allSameDow.length
      const baseTickets = allSameDow.reduce((s, v) => s + v.nb_tickets, 0) / allSameDow.length
      return { baseCA: baseCA * targetSeasonal, baseTickets: baseTickets * targetSeasonal, dataPoints: allSameDow.length }
    }

    // Ultimate fallback: global average × seasonal
    const validated = ventes.value.filter(v => v.cloture_validee)
    if (validated.length > 0) {
      const baseCA = validated.reduce((s, v) => s + v.ca_ttc, 0) / validated.length
      const baseTickets = validated.reduce((s, v) => s + v.nb_tickets, 0) / validated.length
      return { baseCA: baseCA * targetSeasonal, baseTickets: baseTickets * targetSeasonal, dataPoints: 0 }
    }

    return { baseCA: 0, baseTickets: 0, dataPoints: 0 }
  }

  /**
   * End-of-month coefficient: statistically significant +6% boost for days 26-31.
   * Damped from observed +7.8% to avoid overfitting.
   * Backed by 51 data points, t-stat = 2.25 (p < 0.05).
   */
  function calculateMonthPositionCoefficient(
    targetDate: Date,
    factors: ForecastFactor[]
  ): number {
    const dayOfMonth = targetDate.getDate()
    const daysInMonth = new Date(targetDate.getFullYear(), targetDate.getMonth() + 1, 0).getDate()

    // Only apply for the last 5-6 days of the month
    if (dayOfMonth >= daysInMonth - 4) {
      const posCoeff = 1.06
      factors.push({
        label: 'Fin de mois',
        type: 'position_mois',
        coefficient: posCoeff,
        detail: `J${dayOfMonth}/${daysInMonth} — hausse historique fin de mois (+6%)`,
      })
      return posCoeff
    }

    // Mid-month dip (J16-20): marginal but consistent -4%
    if (dayOfMonth >= 16 && dayOfMonth <= 20) {
      const posCoeff = 0.96
      factors.push({
        label: 'Milieu de mois',
        type: 'position_mois',
        coefficient: posCoeff,
        detail: `J${dayOfMonth} — creux historique mi-mois (-4%)`,
      })
      return posCoeff
    }

    return 1
  }

  function calculateWeatherCoefficient(
    meteoDay: MeteoDaily | null,
    factors: ForecastFactor[],
    dayOfWeek?: number
  ): number {
    if (!meteoDay) return 1
    let coeff = 1

    const precip = meteoDay.precipitation_mm ?? 0
    const isSaturday = dayOfWeek === 6

    // Weather conditions are MUTUALLY EXCLUSIVE for client behavior:
    // Rain → people come to shopping center (boost)
    // Sunshine → people stay outdoors (penalty)
    // Overcast → more foot traffic (boost)
    // Rain takes priority: if it rains, sunshine/clouds are irrelevant.
    //
    // Saturday coefficients are higher: 10-month backtest shows +12% (light) / +32% (heavy)
    // vs weekday +2.5% (light) / +15% (heavy). Welch t-test significant (p<0.05).
    const isRainy = precip >= 1

    if (precip > 5) {
      const precipCoeff = isSaturday ? 1.30 : 1.15
      coeff *= precipCoeff
      factors.push({
        label: 'Pluie forte',
        type: 'meteo',
        coefficient: precipCoeff,
        detail: `${precip.toFixed(1)} mm de pluie — ${isSaturday ? 'fort boost samedi' : 'plus de clients au'} centre commercial`,
      })
    } else if (isRainy) {
      const precipCoeff = isSaturday ? 1.10 : 1.0
      if (precipCoeff !== 1.0) {
        coeff *= precipCoeff
        factors.push({
          label: 'Pluie legere',
          type: 'meteo',
          coefficient: precipCoeff,
          detail: `${precip.toFixed(1)} mm de pluie — ${isSaturday ? 'boost samedi' : 'leger boost'} centre commercial`,
        })
      }
    }

    // Cloud cover and sunshine only apply when NO rain (mutually exclusive with precipitation)
    if (!isRainy) {
      if (meteoDay.couverture_nuageuse_pct !== null && meteoDay.couverture_nuageuse_pct > 80) {
        const cloudCoeff = 1.06
        coeff *= cloudCoeff
        factors.push({
          label: 'Ciel couvert',
          type: 'meteo',
          coefficient: cloudCoeff,
          detail: `Couverture nuageuse ${meteoDay.couverture_nuageuse_pct}% — plus de passage`,
        })
      }

      // Sunshine threshold raised from 6h to 8h (optimal cut-off from data analysis)
      if (meteoDay.ensoleillement_secondes !== null && meteoDay.ensoleillement_secondes > 28800) {
        const sunHours = meteoDay.ensoleillement_secondes / 3600
        const sunCoeff = 0.93
        coeff *= sunCoeff
        factors.push({
          label: 'Grand soleil',
          type: 'meteo',
          coefficient: sunCoeff,
          detail: `${sunHours.toFixed(1)}h de soleil — moins de passage en centre commercial`,
        })
      }
    }

    return coeff
  }

  /**
   * Compute weather coefficient for a given date without pushing to factors array.
   * Used internally by superformance to isolate weather effect on past days.
   */
  function getWeatherCoeffForDate(dateStr: string): number {
    const meteoDay = meteoParDate.value.get(dateStr)
    if (!meteoDay) return 1
    const d = new Date(dateStr + 'T00:00:00')
    const dummy: ForecastFactor[] = []
    const wCoeff = calculateWeatherCoefficient(meteoDay, dummy, d.getDay())
    const tCoeff = calculateTemperatureCoefficient(meteoDay, d, dummy)
    return wCoeff * tCoeff
  }

  /**
   * Calculate superformance: recent momentum on weather-adjusted residuals.
   *
   * For Saturday (dow=6): uses SAME-WEEKDAY residuals over 6 weeks (not cross-day)
   * because Saturday has its own dynamics that don't correlate with weekday patterns.
   *
   * For other days: uses ALL days over the last 14 days with exponential decay.
   *
   * Returns a ratio (e.g., 0.06 means +6% above expected).
   */
  function calculateSuperformance(targetDate: Date): { value: number; daysUsed: number } {
    const targetDow = targetDate.getDay()
    const MAX_SUPERF = 0.15 // Cap at ±15% to prevent overcorrection

    // Saturday: same-weekday only (6 weeks lookback, equal weights)
    if (targetDow === 6) {
      const residuals: number[] = []
      for (let w = 1; w <= 6; w++) {
        const d = new Date(targetDate)
        d.setDate(d.getDate() - w * 7)
        const dStr = toLocalDateStr(d)
        const vente = ventesParDate.value.get(dStr)
        if (!vente || !vente.cloture_validee || vente.ca_ttc <= 0) continue
        const { baseCA } = calculateBaseCA(d)
        if (baseCA <= 0) continue
        const weatherAdj = getWeatherCoeffForDate(dStr)
        // Include DOW + monthPos in expected to avoid double-counting with DOW correction
        const dummyF: ForecastFactor[] = []
        const mpC = calculateMonthPositionCoefficient(d, dummyF)
        const dc = dowCorrections.value[6] ?? 1
        const expected = baseCA * weatherAdj * dc * mpC
        residuals.push(vente.ca_ttc / expected - 1)
      }
      if (residuals.length < 2) return { value: 0, daysUsed: 0 }
      const avg = residuals.reduce((a, b) => a + b, 0) / residuals.length
      return { value: Math.max(-MAX_SUPERF, Math.min(MAX_SUPERF, avg)), daysUsed: residuals.length }
    }

    // Other days: cross-day momentum with exponential decay
    const LOOKBACK_DAYS = 14
    const HALF_LIFE = 5
    const lambda = Math.LN2 / HALF_LIFE

    let weightedSum = 0
    let weightSum = 0
    let daysUsed = 0

    for (let i = 1; i <= LOOKBACK_DAYS; i++) {
      const d = new Date(targetDate)
      d.setDate(d.getDate() - i)
      const dStr = toLocalDateStr(d)

      const vente = ventesParDate.value.get(dStr)
      if (!vente || !vente.cloture_validee || vente.ca_ttc <= 0) continue

      // Skip Saturday data in cross-day momentum (different dynamics)
      if (d.getDay() === 6) continue

      const { baseCA } = calculateBaseCA(d)
      if (baseCA <= 0) continue

      const weatherAdj = getWeatherCoeffForDate(dStr)
      // Include DOW + monthPos in expected to avoid double-counting
      const dummyF: ForecastFactor[] = []
      const mpC = calculateMonthPositionCoefficient(d, dummyF)
      const dc = dowCorrections.value[d.getDay()] ?? 1
      const expected = baseCA * weatherAdj * dc * mpC

      const ratio = vente.ca_ttc / expected - 1

      const weight = Math.exp(-lambda * i)
      weightedSum += ratio * weight
      weightSum += weight
      daysUsed++
    }

    if (weightSum < 0.5) return { value: 0, daysUsed: 0 }
    const raw = weightedSum / weightSum
    return { value: Math.max(-MAX_SUPERF, Math.min(MAX_SUPERF, raw)), daysUsed }
  }

  // DÉSACTIVÉ 2026-03-11 — Analyse sur 10 mois (61 occurrences) montre que le
  // facteur x0.85 est injustifié. Écart réel observé: +5.5% (soleil→pluie)
  // et -3.5% (pluie→soleil). Non statistiquement significatif (t=1.14).
  // En centre commercial, la pluie après le beau temps ramène du monde.
  function detectWeatherBreak(
    _targetDateStr: string,
    _factors: ForecastFactor[]
  ): number {
    return 1
  }

  function calculateTemperatureCoefficient(
    meteoDay: MeteoDaily | null,
    targetDate: Date,
    factors: ForecastFactor[]
  ): number {
    if (!meteoDay) return 1
    if (meteoDay.temperature_max === null && meteoDay.temperature_min === null) return 1

    const avgTemp = meteoDay.temperature_max !== null && meteoDay.temperature_min !== null
      ? (meteoDay.temperature_max + meteoDay.temperature_min) / 2
      : (meteoDay.temperature_max ?? meteoDay.temperature_min ?? 15)

    const month = targetDate.getMonth()
    const seasonalAvg = SEASONAL_AVG_TEMP[month] ?? 15
    const deviation = Math.abs(avgTemp - seasonalAvg)

    if (deviation > 10) {
      const sigma = 8
      const exponent = -((deviation - 10) ** 2) / (2 * sigma * sigma)
      const tempCoeff = 0.70 + 0.30 * Math.exp(exponent)

      factors.push({
        label: 'Temperature extreme',
        type: 'temperature',
        coefficient: tempCoeff,
        detail: `${avgTemp.toFixed(0)}C vs moyenne saisonniere ${seasonalAvg}C (ecart ${deviation.toFixed(0)}C)`,
      })
      return tempCoeff
    }

    return 1
  }

  // Fixed closure dates: restaurant always closed (1er janvier, 1er mai, 25 décembre)
  function isDateFermeture(dateStr: string): boolean {
    const d = new Date(dateStr + 'T00:00:00')
    const month = d.getMonth() // 0-indexed
    const day = d.getDate()
    return (month === 0 && day === 1) || (month === 4 && day === 1) || (month === 11 && day === 25)
  }

  function calculateForecast(dateStr: string): ForecastResult {
    const targetDate = new Date(dateStr + 'T00:00:00')
    const jourSemaine = targetDate.getDay()

    // If the restaurant is closed on this day of week OR on a fixed closure date, return 0
    if (isJourFerme(jourSemaine) || isDateFermeture(dateStr)) {
      const n1 = getN1Comparison(targetDate)
      const todayStr = toLocalDateStr(new Date())
      const venteActuelle = dateStr < todayStr ? ventesParDate.value.get(dateStr) : null
      return {
        date: dateStr,
        jour_semaine: jourSemaine,
        ca_prevision: 0,
        ca_base: 0,
        nb_tickets_prevision: 0,
        confidence: 100,
        factors: [],
        meteo: meteoParDate.value.get(dateStr) || null,
        evenements: getEventsForDate(dateStr),
        ca_n1: n1.vente?.ca_ttc ?? null,
        date_n1: n1.date,
        ca_realise: venteActuelle && venteActuelle.cloture_validee ? venteActuelle.ca_ttc : null,
      }
    }

    const factors: ForecastFactor[] = []

    // Layer 1: Exponentially weighted same-weekday base
    const { baseCA, baseTickets, dataPoints } = calculateBaseCA(targetDate)

    // Layer 3 (weather — computed before Layer 2 to isolate weather effect)
    const realMeteo = meteoParDate.value.get(dateStr) || null
    const horizon = daysFromToday(dateStr)
    let meteoDay: MeteoDaily | null = realMeteo

    if (!realMeteo && horizon > 0 && horizon <= 30) {
      meteoDay = buildSeasonalMeteo(dateStr)
    }

    calculateWeatherCoefficient(meteoDay, factors, jourSemaine)
    detectWeatherBreak(dateStr, factors)
    calculateTemperatureCoefficient(meteoDay, targetDate, factors)

    // Layer 2: Superformance (cross-day momentum on weather-adjusted residuals)
    const superf = calculateSuperformance(targetDate)
    if (Math.abs(superf.value) > 0.02) {
      factors.push({
        label: superf.value > 0 ? 'Superformance recente' : 'Sous-performance recente',
        type: 'superformance',
        coefficient: 1 + superf.value,
        detail: `${superf.value > 0 ? '+' : ''}${(superf.value * 100).toFixed(1)}% vs attendu sur les ${superf.daysUsed} derniers jours`,
      })
    }

    // Layer 4: Month position (end-of-month boost, mid-month dip)
    calculateMonthPositionCoefficient(targetDate, factors)

    // Layer 5: Day-of-week correction — weather-conditional when meaningful difference (>5%)
    const JOURS_FR = ['', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi']
    const isRainyDay = meteoDay && meteoDay.precipitation_mm !== null && meteoDay.precipitation_mm > 2
    const isSunnyDay = meteoDay && meteoDay.ensoleillement_secondes !== null && meteoDay.ensoleillement_secondes > 25200
    const dwBucket = dowWeatherBuckets.value[jourSemaine]
    const overallDowCorr = dowCorrections.value[jourSemaine] ?? 1

    let dowCorr = overallDowCorr
    let dowDetail = ''
    // Only use weather-conditional correction when it differs >5% from overall
    if (isRainyDay && dwBucket?.rainy !== null && Math.abs(dwBucket!.rainy! - overallDowCorr) > 0.05) {
      dowCorr = dwBucket!.rainy!
      dowDetail = ` (pluie: ${dowCorr > 1 ? '+' : ''}${((dowCorr - 1) * 100).toFixed(0)}%)`
    } else if (isSunnyDay && dwBucket?.sunny !== null && Math.abs(dwBucket!.sunny! - overallDowCorr) > 0.05) {
      dowCorr = dwBucket!.sunny!
      dowDetail = ` (soleil: ${dowCorr > 1 ? '+' : ''}${((dowCorr - 1) * 100).toFixed(0)}%)`
    }

    if (Math.abs(dowCorr - 1) > 0.01) {
      factors.push({
        label: `Correction ${JOURS_FR[jourSemaine]}`,
        type: 'dow_correction',
        coefficient: dowCorr,
        detail: `Ajustement historique du ${JOURS_FR[jourSemaine]}${dowDetail || ` (${dowCorr > 1 ? '+' : ''}${((dowCorr - 1) * 100).toFixed(0)}%)`}`,
      })
    }

    // Layer 6: Holiday proximity (veille/lendemain de férié, pont)
    calculateHolidayProximityCoefficient(targetDate, dateStr, factors)

    // Layer 7: Short-term streak detection (momentum court terme)
    calculateStreakCoefficient(targetDate, factors)

    // Layer 8: Global drift (tendance N vs N-1)
    const drift = globalDrift.value
    if (Math.abs(drift - 1) > 0.02) {
      factors.push({
        label: drift > 1 ? 'Tendance hausse' : 'Tendance baisse',
        type: 'global_drift',
        coefficient: drift,
        detail: `Tendance ${drift > 1 ? 'hausse' : 'baisse'} sur 3 mois vs N-1 (${drift > 1 ? '+' : ''}${((drift - 1) * 100).toFixed(0)}%)`,
      })
    }

    // Events
    const dayEvents = getEventsForDate(dateStr)
    for (const evt of dayEvents) {
      factors.push({
        label: evt.nom,
        type: 'evenement',
        coefficient: evt.coefficient,
        detail: `${evt.type} — coefficient ${evt.coefficient.toFixed(2)}`,
      })
    }

    // Confidence score
    const hasRealMeteo = realMeteo !== null
    let confidence = Math.min(75, 30 + dataPoints * 12)
    if (meteoDay) confidence += 10
    if (superf.daysUsed >= 7) confidence += 10
    const n1 = getN1Comparison(targetDate)
    if (n1.vente) confidence += 5
    confidence = Math.min(95, confidence)
    if (dataPoints === 0) confidence = 10
    confidence = Math.max(10, confidence + meteoConfidencePenalty(dateStr, hasRealMeteo))

    // Calibration: compensates for systematic multiplicative bias (+4.5%)
    // caused by stacking multiple slightly-positive adjustment factors.
    // Validated by backtesting on 104 days vs inpulse: reduces MAPE from 18.2% to 17.2%.
    const CALIBRATION_FACTOR = 0.96

    const totalCoeff = factors.reduce((acc, f) => acc * f.coefficient, 1) * CALIBRATION_FACTOR
    const caPrevision = Math.round(baseCA * totalCoeff)
    const nbTicketsPrevision = Math.round(baseTickets * totalCoeff)

    // For past dates, include actual CA if available
    const todayStr = toLocalDateStr(new Date())
    const venteActuelle = dateStr < todayStr ? ventesParDate.value.get(dateStr) : null
    const caRealise = venteActuelle && venteActuelle.cloture_validee ? venteActuelle.ca_ttc : null

    return {
      date: dateStr,
      jour_semaine: jourSemaine,
      ca_prevision: caPrevision,
      ca_base: Math.round(baseCA),
      nb_tickets_prevision: nbTicketsPrevision,
      confidence: Math.round(confidence),
      factors,
      meteo: meteoDay,
      evenements: dayEvents,
      ca_n1: n1.vente?.ca_ttc ?? null,
      date_n1: n1.date,
      ca_realise: caRealise,
    }
  }

  function calculateWeekForecast(startDate?: string): ForecastResult[] {
    const start = startDate
      ? new Date(startDate + 'T00:00:00')
      : new Date()
    const results: ForecastResult[] = []

    for (let i = 0; i < 7; i++) {
      const d = new Date(start)
      d.setDate(d.getDate() + i)
      const dateStr = toLocalDateStr(d)
      results.push(calculateForecast(dateStr))
    }

    return results
  }

  function calculateMonthForecast(year: number, month: number): ForecastResult[] {
    const results: ForecastResult[] = []
    const daysInMonth = new Date(year, month + 1, 0).getDate()

    for (let day = 1; day <= daysInMonth; day++) {
      const d = new Date(year, month, day)
      const dateStr = toLocalDateStr(d)
      results.push(calculateForecast(dateStr))
    }

    return results
  }

  function getRepartitionForDay(
    jourSemaine: number,
    dateStr: string
  ): { heure: number; pourcentage: number }[] {
    const dayEvents = getEventsForDate(dateStr)
    const isVacances = dayEvents.some(e => e.type === 'vacances')

    let contexte: RepartitionHoraire['contexte'] = 'standard'
    if (isVacances) {
      contexte = 'vacances'
    } else if (jourSemaine === 6) {
      contexte = 'samedi'
    } else if (jourSemaine === 0) {
      contexte = 'dimanche'
    }

    const dayRep = repartition.value
      .filter(r => r.jour_semaine === jourSemaine && r.contexte === contexte)
      .sort((a, b) => a.creneau_heure - b.creneau_heure)

    if (dayRep.length === 0 && contexte !== 'standard') {
      return repartition.value
        .filter(r => r.jour_semaine === jourSemaine && r.contexte === 'standard')
        .sort((a, b) => a.creneau_heure - b.creneau_heure)
        .map(r => ({ heure: r.creneau_heure, pourcentage: r.pourcentage }))
    }

    return dayRep.map(r => ({
      heure: r.creneau_heure,
      pourcentage: r.pourcentage,
    }))
  }

  function getRepartitionCA(
    forecast: ForecastResult
  ): { heure: number; pourcentage: number; ca: number }[] {
    const rep = getRepartitionForDay(forecast.jour_semaine, forecast.date)
    return rep.map(r => ({
      heure: r.heure,
      pourcentage: r.pourcentage,
      ca: Math.round((forecast.ca_prevision * r.pourcentage) / 100),
    }))
  }

  function isJourFerme(jourSemaine: number): boolean {
    const horaire = horaires.value.find(h => h.jour_semaine === jourSemaine)
    return horaire?.est_ferme ?? false
  }

  /**
   * Compute precision for the previous week (S-1).
   * precision = 1 - avg(|CA_prevu - CA_realise| / CA_realise) per day
   * Returns null if no realized data is available.
   */
  function calculatePrecisionS1(): { precision: number; caRealise: number; caPrevu: number } | null {
    const today = new Date()
    // Go to previous Monday
    const dayOfWeek = today.getDay() // 0=Sun
    const daysToLastMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1 // days since last Monday
    const lastMonday = new Date(today)
    lastMonday.setDate(today.getDate() - daysToLastMonday - 7) // previous week Monday

    let totalRealise = 0
    let totalPrevu = 0
    let daysWithData = 0
    let sumErrorPct = 0

    for (let i = 0; i < 7; i++) {
      const d = new Date(lastMonday)
      d.setDate(lastMonday.getDate() + i)
      const dateStr = toLocalDateStr(d)
      const vente = ventesParDate.value.get(dateStr)
      if (!vente || !vente.cloture_validee) continue

      const forecast = calculateForecast(dateStr)
      totalRealise += vente.ca_ttc
      totalPrevu += forecast.ca_prevision
      if (vente.ca_ttc > 0) {
        sumErrorPct += Math.abs(forecast.ca_prevision - vente.ca_ttc) / vente.ca_ttc
      }
      daysWithData++
    }

    if (daysWithData === 0) return null
    const avgError = sumErrorPct / daysWithData
    const precision = Math.round((1 - avgError) * 100)
    return { precision: Math.max(0, Math.min(100, precision)), caRealise: totalRealise, caPrevu: totalPrevu }
  }

  /**
   * Get N-1 week total CA for a given week start date.
   */
  function getWeekN1Total(weekForecasts: ForecastResult[]): number | null {
    let total = 0
    let hasData = false
    for (const fc of weekForecasts) {
      if (fc.ca_n1 !== null) {
        total += fc.ca_n1
        hasData = true
      }
    }
    return hasData ? total : null
  }

  async function createEvenement(evt: Omit<Evenement, 'id' | 'created_at'>): Promise<Evenement> {
    const [created] = await restCall<Evenement[]>('POST', 'evenements', evt)
    evenements.value.unshift(created!)
    await db.evenements.put(created!)
    return created!
  }

  async function updateEvenement(id: string, updates: Partial<Evenement>): Promise<void> {
    await restCall('PATCH', `evenements?id=eq.${id}`, updates)
    const idx = evenements.value.findIndex(e => e.id === id)
    if (idx >= 0) {
      evenements.value[idx] = { ...evenements.value[idx]!, ...updates }
      await db.evenements.put(evenements.value[idx]!)
    }
  }

  async function deleteEvenement(id: string): Promise<void> {
    await restCall('DELETE', `evenements?id=eq.${id}`)
    evenements.value = evenements.value.filter(e => e.id !== id)
    await db.evenements.delete(id)
  }

  return {
    ventes, meteo, evenements, horaires, repartition, loading, error,
    ventesParDate, meteoParDate,
    fetchAll, fetchVentes, fetchMeteo, fetchEvenements, fetchHoraires, fetchRepartition,
    calculateForecast, calculateWeekForecast, calculateMonthForecast,
    getRepartitionForDay, getRepartitionCA,
    getEventsForDate, isJourFerme, weatherCodeToEmoji,
    calculatePrecisionS1, getWeekN1Total,
    createEvenement, updateEvenement, deleteEvenement,
  }
})
