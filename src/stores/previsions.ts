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

// --- Types ---

export interface ForecastFactor {
  label: string
  type: 'meteo' | 'evenement' | 'tendance' | 'rupture_meteo' | 'temperature'
  coefficient: number
  detail: string
}

export interface ForecastResult {
  date: string
  jour_semaine: number
  ca_prevision: number
  nb_tickets_prevision: number
  confidence: number
  factors: ForecastFactor[]
  meteo: MeteoDaily | null
  evenements: Evenement[]
  ca_n1: number | null
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
        const sinceStr = since.toISOString().split('T')[0]

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
        since.setMonth(since.getMonth() - 2)
        const sinceStr = since.toISOString().split('T')[0]

        const until = new Date()
        until.setDate(until.getDate() + 7)
        const untilStr = until.toISOString().split('T')[0]

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
      const pastStr = pastDate.toISOString().split('T')[0]!
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

    let best: VenteHistorique | null = null
    let bestDiff = Infinity

    for (let offset = -3; offset <= 3; offset++) {
      const checkDate = new Date(oneYearAgo)
      checkDate.setDate(checkDate.getDate() + offset)
      if (checkDate.getDay() !== targetDow) continue

      const checkStr = checkDate.toISOString().split('T')[0]!
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

  function calculateWeatherCoefficient(
    meteoDay: MeteoDaily | null,
    factors: ForecastFactor[]
  ): number {
    if (!meteoDay) return 1
    let coeff = 1

    if (meteoDay.precipitation_mm !== null && meteoDay.precipitation_mm > 5) {
      const precipCoeff = 1.15
      coeff *= precipCoeff
      factors.push({
        label: 'Pluie forte',
        type: 'meteo',
        coefficient: precipCoeff,
        detail: `${meteoDay.precipitation_mm.toFixed(1)} mm de pluie — plus de clients au centre commercial`,
      })
    }

    if (meteoDay.couverture_nuageuse_pct !== null && meteoDay.couverture_nuageuse_pct > 80) {
      const cloudCoeff = 1.10
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
      const sunCoeff = 0.90
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

  function detectWeatherBreak(
    targetDateStr: string,
    factors: ForecastFactor[]
  ): number {
    const targetDate = new Date(targetDateStr + 'T00:00:00')
    const recentDays: MeteoDaily[] = []

    for (let i = 1; i <= 7; i++) {
      const d = new Date(targetDate)
      d.setDate(d.getDate() - i)
      const dStr = d.toISOString().split('T')[0]!
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
    const factors: ForecastFactor[] = []

    const history = getSameDayHistory(targetDate, 8)
    const recentHistory = history.slice(0, 4)

    let baseCA = 0
    let baseTickets = 0
    let confidence = 0

    if (recentHistory.length > 0) {
      baseCA = recentHistory.reduce((sum, v) => sum + v.ca_ttc, 0) / recentHistory.length
      baseTickets = recentHistory.reduce((sum, v) => sum + v.nb_tickets, 0) / recentHistory.length
      confidence = Math.min(95, 50 + recentHistory.length * 10)

      if (recentHistory.length >= 3) {
        const firstHalf = recentHistory.slice(Math.floor(recentHistory.length / 2))
        const secondHalf = recentHistory.slice(0, Math.floor(recentHistory.length / 2))
        const avgFirst = firstHalf.reduce((s, v) => s + v.ca_ttc, 0) / firstHalf.length
        const avgSecond = secondHalf.reduce((s, v) => s + v.ca_ttc, 0) / secondHalf.length

        if (avgFirst > 0) {
          const trendRatio = avgSecond / avgFirst
          if (Math.abs(trendRatio - 1) > 0.03) {
            const dampedTrend = 1 + (trendRatio - 1) * 0.5
            factors.push({
              label: dampedTrend > 1 ? 'Tendance hausse' : 'Tendance baisse',
              type: 'tendance',
              coefficient: dampedTrend,
              detail: `Evolution recente: ${((trendRatio - 1) * 100).toFixed(1)}% sur les dernieres semaines`,
            })
          }
        }
      }
    } else {
      const allSameDow = ventes.value.filter(v => {
        const d = new Date(v.date + 'T00:00:00')
        return d.getDay() === jourSemaine && v.cloture_validee
      })
      if (allSameDow.length > 0) {
        baseCA = allSameDow.reduce((s, v) => s + v.ca_ttc, 0) / allSameDow.length
        baseTickets = allSameDow.reduce((s, v) => s + v.nb_tickets, 0) / allSameDow.length
        confidence = 25
      } else {
        const validated = ventes.value.filter(v => v.cloture_validee)
        if (validated.length > 0) {
          baseCA = validated.reduce((s, v) => s + v.ca_ttc, 0) / validated.length
          baseTickets = validated.reduce((s, v) => s + v.nb_tickets, 0) / validated.length
        }
        confidence = 10
      }
    }

    const meteoDay = meteoParDate.value.get(dateStr) || null
    calculateWeatherCoefficient(meteoDay, factors)
    detectWeatherBreak(dateStr, factors)
    calculateTemperatureCoefficient(meteoDay, targetDate, factors)

    const dayEvents = getEventsForDate(dateStr)
    for (const evt of dayEvents) {
      factors.push({
        label: evt.nom,
        type: 'evenement',
        coefficient: evt.coefficient,
        detail: `${evt.type} — coefficient ${evt.coefficient.toFixed(2)}`,
      })
    }

    if (!meteoDay) {
      confidence = Math.max(10, confidence - 15)
    }

    const totalCoeff = factors.reduce((acc, f) => acc * f.coefficient, 1)
    const caPrevision = Math.round(baseCA * totalCoeff)
    const nbTicketsPrevision = Math.round(baseTickets * totalCoeff)

    const n1Vente = getN1Comparison(targetDate)

    return {
      date: dateStr,
      jour_semaine: jourSemaine,
      ca_prevision: caPrevision,
      nb_tickets_prevision: nbTicketsPrevision,
      confidence: Math.round(confidence),
      factors,
      meteo: meteoDay,
      evenements: dayEvents,
      ca_n1: n1Vente?.ca_ttc ?? null,
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
      const dateStr = d.toISOString().split('T')[0]!
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
      const dateStr = d.toISOString().split('T')[0]!
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

  return {
    ventes, meteo, evenements, horaires, repartition, loading, error,
    ventesParDate, meteoParDate,
    fetchAll, fetchVentes, fetchMeteo, fetchEvenements, fetchHoraires, fetchRepartition,
    calculateForecast, calculateWeekForecast,
    getRepartitionForDay, getRepartitionCA,
    getEventsForDate, isJourFerme, weatherCodeToEmoji,
    calculatePrecisionS1, getWeekN1Total,
  }
})
