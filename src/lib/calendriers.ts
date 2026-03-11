/**
 * Calendriers automatiques — Jours fériés, vacances scolaires, soldes, Ramadan
 * Spec: CLAUDE.md section "Calendriers auto"
 *
 * - Jours fériés: 11 fixes + mobiles (Pâques via Meeus/Jones/Butcher)
 * - Vacances scolaires: API data.education.gouv.fr (3 zones: A=Bordeaux 1.10, B+C=passage 1.05)
 * - Soldes: calcul local (2ème mercredi janvier, dernier mercredi juin, 4 semaines)
 * - Ramadan: dates approx. via calcul Hijri (coeff 0.88, soit -12%)
 * - Aïd el-Fitr: 2 jours après le Ramadan (coeff 1.0, neutre)
 */

import { restCall } from './rest-client'
import type { Evenement } from '@/types/database'

// --- Easter calculation: Meeus/Jones/Butcher algorithm ---

function calculateEasterDate(year: number): Date {
  const a = year % 19
  const b = Math.floor(year / 100)
  const c = year % 100
  const d = Math.floor(b / 4)
  const e = b % 4
  const f = Math.floor((b + 8) / 25)
  const g = Math.floor((b - f + 1) / 3)
  const h = (19 * a + b - d - g + 15) % 30
  const i = Math.floor(c / 4)
  const k = c % 4
  const l = (32 + 2 * e + 2 * i - h - k) % 7
  const m = Math.floor((a + 11 * h + 22 * l) / 451)
  const month = Math.floor((h + l - 7 * m + 114) / 31) - 1 // 0-indexed
  const day = ((h + l - 7 * m + 114) % 31) + 1
  return new Date(year, month, day)
}

// --- Fixed French public holidays ---

function getJoursFeries(year: number): { date: Date; nom: string }[] {
  const easter = calculateEasterDate(year)

  const lundiPaques = new Date(easter)
  lundiPaques.setDate(lundiPaques.getDate() + 1)

  const ascension = new Date(easter)
  ascension.setDate(ascension.getDate() + 39)

  const lundiPentecote = new Date(easter)
  lundiPentecote.setDate(lundiPentecote.getDate() + 50)

  return [
    { date: new Date(year, 0, 1), nom: 'Jour de l\'an' },
    { date: lundiPaques, nom: 'Lundi de Pâques' },
    { date: new Date(year, 4, 1), nom: 'Fête du Travail' },
    { date: new Date(year, 4, 8), nom: 'Victoire 1945' },
    { date: ascension, nom: 'Ascension' },
    { date: lundiPentecote, nom: 'Lundi de Pentecôte' },
    { date: new Date(year, 6, 14), nom: 'Fête nationale' },
    { date: new Date(year, 7, 15), nom: 'Assomption' },
    { date: new Date(year, 10, 1), nom: 'Toussaint' },
    { date: new Date(year, 10, 11), nom: 'Armistice' },
    { date: new Date(year, 11, 25), nom: 'Noël' },
  ]
}

// --- Soldes calculation ---

function getNthWeekday(year: number, month: number, weekday: number, n: number): Date {
  const first = new Date(year, month, 1)
  let day = first.getDay()
  let offset = (weekday - day + 7) % 7
  offset += (n - 1) * 7
  return new Date(year, month, 1 + offset)
}

function getLastWeekday(year: number, month: number, weekday: number): Date {
  const last = new Date(year, month + 1, 0) // last day of month
  let day = last.getDay()
  const offset = (day - weekday + 7) % 7
  return new Date(year, month, last.getDate() - offset)
}

function getSoldes(year: number): { debut: Date; fin: Date; nom: string }[] {
  // Winter soldes: 2nd Wednesday of January, 4 weeks
  const winterStart = getNthWeekday(year, 0, 3, 2) // 3 = Wednesday
  const winterEnd = new Date(winterStart)
  winterEnd.setDate(winterEnd.getDate() + 27) // 4 weeks

  // Summer soldes: last Wednesday of June, 4 weeks
  const summerStart = getLastWeekday(year, 5, 3) // 5 = June, 3 = Wednesday
  const summerEnd = new Date(summerStart)
  summerEnd.setDate(summerEnd.getDate() + 27)

  return [
    { debut: winterStart, fin: winterEnd, nom: 'Soldes d\'hiver' },
    { debut: summerStart, fin: summerEnd, nom: 'Soldes d\'été' },
  ]
}

// --- Ramadan & Aïd el-Fitr ---
// Approximate Hijri → Gregorian conversion for Ramadan start dates.
// Based on known dates + lunar year (~354.37 days). Accuracy: ±1-2 days.
// Actual dates depend on moon sighting, but this is good enough for forecasting.

const RAMADAN_KNOWN_DATES: Record<number, { start: string; end: string }> = {
  2024: { start: '2024-03-11', end: '2024-04-09' },
  2025: { start: '2025-03-01', end: '2025-03-29' },
  2026: { start: '2026-02-18', end: '2026-03-19' },
  2027: { start: '2027-02-08', end: '2027-03-08' },
  2028: { start: '2028-01-28', end: '2028-02-25' },
  2029: { start: '2029-01-16', end: '2029-02-13' },
  2030: { start: '2030-01-06', end: '2030-02-03' },
}

function getRamadan(year: number): { debut: string; fin: string } | null {
  const known = RAMADAN_KNOWN_DATES[year]
  if (known) return { debut: known.start, fin: known.end }

  // Fallback: approximate from 2025 known date using lunar year drift (~10.63 days/year)
  const refYear = 2025
  const refStart = new Date(2025, 2, 1) // March 1, 2025
  const yearsDiff = year - refYear
  const drift = Math.round(yearsDiff * -10.63)
  const approxStart = new Date(refStart)
  approxStart.setDate(approxStart.getDate() + drift)
  const approxEnd = new Date(approxStart)
  approxEnd.setDate(approxEnd.getDate() + 29)
  return { debut: toDateStr(approxStart), fin: toDateStr(approxEnd) }
}

function getAidElFitr(year: number): { debut: string; fin: string } | null {
  const ramadan = getRamadan(year)
  if (!ramadan) return null
  const endDate = new Date(ramadan.fin + 'T00:00:00')
  const aidStart = new Date(endDate)
  aidStart.setDate(aidStart.getDate() + 1)
  const aidEnd = new Date(aidStart)
  aidEnd.setDate(aidEnd.getDate() + 1) // 2 days
  return { debut: toDateStr(aidStart), fin: toDateStr(aidEnd) }
}

// --- Vacances scolaires 3 zones (A=Bordeaux, B, C) via API ---

interface VacancesApiRecord {
  fields: {
    description: string
    start_date: string
    end_date: string
    zones: string
    location: string
  }
}

async function fetchVacancesScolaires(year: number, zone: 'A' | 'B' | 'C'): Promise<{ debut: string; fin: string; nom: string }[]> {
  const startYear = `${year}-09-01`
  const endYear = `${year + 1}-08-31`
  const locations: Record<string, string> = { A: 'Bordeaux', B: 'Lille', C: 'Paris' }

  try {
    const url = `https://data.education.gouv.fr/api/records/1.0/search/?dataset=fr-en-calendrier-scolaire&rows=50&refine.zones=Zone+${zone}&refine.location=${locations[zone]}&sort=start_date&q=start_date>=${startYear}+AND+start_date<=${endYear}`
    const response = await fetch(url)
    if (!response.ok) throw new Error(`API error: ${response.status}`)
    const data = await response.json() as { records: VacancesApiRecord[] }

    return (data.records || []).map((r: VacancesApiRecord) => ({
      debut: r.fields.start_date.split('T')[0]!,
      fin: r.fields.end_date.split('T')[0]!,
      nom: r.fields.description,
    }))
  } catch (err) {
    console.warn(`Failed to fetch vacances scolaires Zone ${zone}:`, err)
    return []
  }
}

// --- Date helpers ---

function toDateStr(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

// --- Main: sync calendars to evenements table ---

export async function syncCalendriers(year?: number): Promise<{
  joursFeries: number
  vacances: number
  soldes: number
  ramadan: number
}> {
  const targetYear = year ?? new Date().getFullYear()
  const years = [targetYear, targetYear + 1] // Current + next year
  const stats = { joursFeries: 0, vacances: 0, soldes: 0, ramadan: 0 }

  for (const y of years) {
    // 1. Jours fériés — batch upsert
    const feries = getJoursFeries(y)
    try {
      await restCall('POST', 'evenements?on_conflict=nom,date_debut', feries.map(f => ({
        nom: f.nom,
        type: 'ferie',
        date_debut: toDateStr(f.date),
        date_fin: toDateStr(f.date),
        coefficient: 0.7,
        recurrent: true,
      })), { prefer: 'resolution=merge-duplicates' })
      stats.joursFeries += feries.length
    } catch (err) {
      console.warn('Failed to sync jours fériés:', err)
    }

    // 2. Soldes — batch upsert
    const soldes = getSoldes(y)
    try {
      await restCall('POST', 'evenements?on_conflict=nom,date_debut', soldes.map(s => ({
        nom: s.nom,
        type: 'soldes',
        date_debut: toDateStr(s.debut),
        date_fin: toDateStr(s.fin),
        coefficient: 1.15,
        recurrent: true,
      })), { prefer: 'resolution=merge-duplicates' })
      stats.soldes += soldes.length
    } catch (err) {
      console.warn('Failed to sync soldes:', err)
    }

    // 3. Vacances scolaires — 3 zones
    // Zone A (Bordeaux, local) = coeff 1.10 — Zones B & C (passage) = coeff 1.05
    const zoneConfigs: { zone: 'A' | 'B' | 'C'; coefficient: number; suffix: string }[] = [
      { zone: 'A', coefficient: 1.10, suffix: '' },
      { zone: 'B', coefficient: 1.05, suffix: ' (Zone B)' },
      { zone: 'C', coefficient: 1.05, suffix: ' (Zone C)' },
    ]
    for (const zc of zoneConfigs) {
      const vacances = await fetchVacancesScolaires(y, zc.zone)
      if (vacances.length > 0) {
        try {
          await restCall('POST', 'evenements?on_conflict=nom,date_debut', vacances.map(v => ({
            nom: v.nom + zc.suffix,
            type: 'vacances',
            date_debut: v.debut,
            date_fin: v.fin,
            coefficient: zc.coefficient,
            recurrent: false,
          })), { prefer: 'resolution=merge-duplicates' })
          stats.vacances += vacances.length
        } catch (err) {
          console.warn(`Failed to sync vacances Zone ${zc.zone}:`, err)
        }
      }
    }

    // 4. Ramadan — coeff 0.88 (impact négatif -12% en centre commercial)
    const ramadan = getRamadan(y)
    if (ramadan) {
      try {
        await restCall('POST', 'evenements?on_conflict=nom,date_debut', [{
          nom: `Ramadan ${y}`,
          type: 'custom',
          date_debut: ramadan.debut,
          date_fin: ramadan.fin,
          coefficient: 0.88,
          recurrent: false,
        }], { prefer: 'resolution=merge-duplicates' })
        stats.ramadan++
      } catch (err) {
        console.warn('Failed to sync Ramadan:', err)
      }
    }

    // 5. Aïd el-Fitr — coeff 1.0 (neutre, pas de pic observé)
    const aid = getAidElFitr(y)
    if (aid) {
      try {
        await restCall('POST', 'evenements?on_conflict=nom,date_debut', [{
          nom: `Aïd el-Fitr ${y}`,
          type: 'custom',
          date_debut: aid.debut,
          date_fin: aid.fin,
          coefficient: 1.0,
          recurrent: false,
        }], { prefer: 'resolution=merge-duplicates' })
      } catch (err) {
        console.warn('Failed to sync Aïd el-Fitr:', err)
      }
    }
  }

  return stats
}

/**
 * Auto-sync calendriers if not synced in the last 24 hours.
 * Called automatically on fetchAll() — no manual action needed.
 */
const SYNC_KEY = 'phood-calendriers-last-sync'

export async function autoSyncCalendriersIfNeeded(): Promise<void> {
  try {
    const lastSync = localStorage.getItem(SYNC_KEY)
    if (lastSync) {
      const elapsed = Date.now() - parseInt(lastSync)
      if (elapsed < 24 * 60 * 60 * 1000) return // <24h: skip
    }
    if (!navigator.onLine) return
    await syncCalendriers()
    localStorage.setItem(SYNC_KEY, String(Date.now()))
  } catch (err) {
    console.warn('Auto-sync calendriers failed:', err)
  }
}

/**
 * Get all jours fériés for a given year (local calculation, no API call)
 */
export function getJoursFeriesForYear(year: number): { date: string; nom: string }[] {
  return getJoursFeries(year).map(f => ({
    date: toDateStr(f.date),
    nom: f.nom,
  }))
}

/**
 * Check if a date is a jour férié
 */
export function isJourFerie(dateStr: string): boolean {
  const d = new Date(dateStr + 'T00:00:00')
  const feries = getJoursFeries(d.getFullYear())
  return feries.some(f => toDateStr(f.date) === dateStr)
}

/**
 * Get the Evenement[] for jours fériés as typed objects (for previsions module)
 */
export function getJoursFeriesAsEvenements(year: number): Evenement[] {
  return getJoursFeries(year).map(f => ({
    id: `ferie-${toDateStr(f.date)}`,
    nom: f.nom,
    type: 'ferie' as const,
    date_debut: toDateStr(f.date),
    date_fin: toDateStr(f.date),
    coefficient: 0.7,
    recurrent: true,
    notes: null,
    created_at: '',
  }))
}
