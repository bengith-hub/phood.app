import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
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
  type: 'meteo' | 'evenement' | 'tendance' | 'rupture_meteo' | 'temperature' | 'superformance'
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

  function getN1Comparison(targetDate: Date): VenteHistorique | null {
    const oneYearAgo = new Date(targetDate)
    oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1)
    const targetDow = targetDate.getDay()
    const targetMonth = oneYearAgo.getMonth()

    let best: VenteHistorique | null = null
    let bestDiff = Infinity

    for (let offset = -3; offset <= 3; offset++) {
      const checkDate = new Date(oneYearAgo)
      checkDate.setDate(checkDate.getDate() + offset)
      if (checkDate.getDay() !== targetDow) continue
      // Stay within the same month to avoid cross-month comparisons
      if (checkDate.getMonth() !== targetMonth) continue

      const checkStr = toLocalDateStr(checkDate)
      const vente = ventesParDate.value.get(checkStr)
      if (vente && vente.cloture_validee) {
        const diff = Math.abs(offset)
        if (diff < bestDiff) {
          bestDiff = diff
          best = vente
        }
      }
    }

    return best
  }

  function getEventsForDate(dateStr: string): Evenement[] {
    return evenements.value.filter(e => {
      return dateStr >= e.date_debut && dateStr <= e.date_fin
    })
  }

  // --- Exponential weights for same-weekday averaging (most recent first) ---
  const EW_WEIGHTS = [0.35, 0.25, 0.20, 0.12, 0.08]

  function calculateBaseCA(targetDate: Date): { baseCA: number; baseTickets: number; dataPoints: number } {
    const jourSemaine = targetDate.getDay()
    const history = getSameDayHistory(targetDate, 8)
    const recent = history.slice(0, 5)

    if (recent.length > 0) {
      const weights = EW_WEIGHTS.slice(0, recent.length)
      const wSum = weights.reduce((a, b) => a + b, 0)

      let baseCA = 0
      let baseTickets = 0
      for (let i = 0; i < recent.length; i++) {
        const w = weights[i]! / wSum
        baseCA += recent[i]!.ca_ttc * w
        baseTickets += recent[i]!.nb_tickets * w
      }

      return { baseCA, baseTickets, dataPoints: recent.length }
    }

    // Fallback: any same day-of-week data
    const allSameDow = ventes.value.filter(v => {
      const d = new Date(v.date + 'T00:00:00')
      return d.getDay() === jourSemaine && v.cloture_validee
    })
    if (allSameDow.length > 0) {
      const baseCA = allSameDow.reduce((s, v) => s + v.ca_ttc, 0) / allSameDow.length
      const baseTickets = allSameDow.reduce((s, v) => s + v.nb_tickets, 0) / allSameDow.length
      return { baseCA, baseTickets, dataPoints: allSameDow.length }
    }

    // Ultimate fallback: global average
    const validated = ventes.value.filter(v => v.cloture_validee)
    if (validated.length > 0) {
      const baseCA = validated.reduce((s, v) => s + v.ca_ttc, 0) / validated.length
      const baseTickets = validated.reduce((s, v) => s + v.nb_tickets, 0) / validated.length
      return { baseCA, baseTickets, dataPoints: 0 }
    }

    return { baseCA: 0, baseTickets: 0, dataPoints: 0 }
  }

  function calculateWeatherCoefficient(
    meteoDay: MeteoDaily | null,
    factors: ForecastFactor[]
  ): number {
    if (!meteoDay) return 1
    let coeff = 1

    if (meteoDay.precipitation_mm !== null && meteoDay.precipitation_mm > 5) {
      const precipCoeff = 1.12
      coeff *= precipCoeff
      factors.push({
        label: 'Pluie forte',
        type: 'meteo',
        coefficient: precipCoeff,
        detail: `${meteoDay.precipitation_mm.toFixed(1)} mm de pluie — plus de clients au centre commercial`,
      })
    }

    if (meteoDay.couverture_nuageuse_pct !== null && meteoDay.couverture_nuageuse_pct > 80) {
      const cloudCoeff = 1.08
      coeff *= cloudCoeff
      factors.push({
        label: 'Ciel couvert',
        type: 'meteo',
        coefficient: cloudCoeff,
        detail: `Couverture nuageuse ${meteoDay.couverture_nuageuse_pct}% — plus de passage`,
      })
    }

    if (meteoDay.ensoleillement_secondes !== null && meteoDay.ensoleillement_secondes > 21600) {
      const sunHours = meteoDay.ensoleillement_secondes / 3600
      const sunCoeff = 0.92
      coeff *= sunCoeff
      factors.push({
        label: 'Grand soleil',
        type: 'meteo',
        coefficient: sunCoeff,
        detail: `${sunHours.toFixed(1)}h de soleil — moins de passage en centre commercial`,
      })
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
    const wCoeff = calculateWeatherCoefficient(meteoDay, dummy)
    const tCoeff = calculateTemperatureCoefficient(meteoDay, d, dummy)
    return wCoeff * tCoeff
  }

  /**
   * Calculate superformance: recent cross-day momentum on weather-adjusted residuals.
   * Looks at ALL days (not just same weekday) over the last 14 days.
   * Uses exponentially decaying weights with half-life of 5 days.
   * Returns a ratio (e.g., 0.06 means +6% above expected).
   */
  function calculateSuperformance(targetDate: Date): { value: number; daysUsed: number } {
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

      // Expected CA for that day (base only, no superformance)
      const { baseCA } = calculateBaseCA(d)
      if (baseCA <= 0) continue

      // Weather adjustment for that day to isolate non-weather residual
      const weatherAdj = getWeatherCoeffForDate(dStr)
      const expected = baseCA * weatherAdj

      const ratio = vente.ca_ttc / expected - 1

      const weight = Math.exp(-lambda * i)
      weightedSum += ratio * weight
      weightSum += weight
      daysUsed++
    }

    if (weightSum < 0.5) return { value: 0, daysUsed: 0 }
    return { value: weightedSum / weightSum, daysUsed }
  }

  function detectWeatherBreak(
    targetDateStr: string,
    factors: ForecastFactor[]
  ): number {
    const targetDate = new Date(targetDateStr + 'T00:00:00')
    const recentDays: MeteoDaily[] = []

    for (let i = 1; i <= 7; i++) {
      const d = new Date(targetDate)
      d.setDate(d.getDate() - i)
      const dStr = toLocalDateStr(d)
      const m = meteoParDate.value.get(dStr)
      if (m) recentDays.push(m)
    }

    if (recentDays.length < 5) return 1

    const targetMeteo = meteoParDate.value.get(targetDateStr)
    if (!targetMeteo) return 1

    const recentRainyCount = recentDays.filter(
      d => d.precipitation_mm !== null && d.precipitation_mm > 2
    ).length
    const recentSunnyCount = recentDays.filter(
      d => d.ensoleillement_secondes !== null && d.ensoleillement_secondes > 18000
    ).length

    const targetIsRainy = targetMeteo.precipitation_mm !== null && targetMeteo.precipitation_mm > 2
    const targetIsSunny = targetMeteo.ensoleillement_secondes !== null &&
      targetMeteo.ensoleillement_secondes > 18000

    const hasSunToRainBreak = recentSunnyCount >= 5 && targetIsRainy
    const hasRainToSunBreak = recentRainyCount >= 5 && targetIsSunny

    if (hasSunToRainBreak || hasRainToSunBreak) {
      const damping = 0.85
      factors.push({
        label: 'Rupture meteo',
        type: 'rupture_meteo',
        coefficient: damping,
        detail: hasSunToRainBreak
          ? 'Passage soleil vers pluie apres 5+ jours — comportement incertain'
          : 'Passage pluie vers soleil apres 5+ jours — comportement incertain',
      })
      return damping
    }

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

  function calculateForecast(dateStr: string): ForecastResult {
    const targetDate = new Date(dateStr + 'T00:00:00')
    const jourSemaine = targetDate.getDay()

    // If the restaurant is closed on this day of week, return 0
    if (isJourFerme(jourSemaine)) {
      const n1Vente = getN1Comparison(targetDate)
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
        ca_n1: n1Vente?.ca_ttc ?? null,
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

    calculateWeatherCoefficient(meteoDay, factors)
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
    const n1Vente = getN1Comparison(targetDate)
    if (n1Vente) confidence += 5
    confidence = Math.min(95, confidence)
    if (dataPoints === 0) confidence = 10
    confidence = Math.max(10, confidence + meteoConfidencePenalty(dateStr, hasRealMeteo))

    const totalCoeff = factors.reduce((acc, f) => acc * f.coefficient, 1)
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
      ca_n1: n1Vente?.ca_ttc ?? null,
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
