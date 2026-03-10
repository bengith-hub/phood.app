<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { usePrevisionsStore, weatherCodeToEmoji } from '@/stores/previsions'
import type { ForecastResult } from '@/stores/previsions'
import { syncCalendriers } from '@/lib/calendriers'

const store = usePrevisionsStore()

// --- State ---
const viewMode = ref<'semaine' | 'mois' | 'jour'>('mois')
const selectedDayIndex = ref(0)
const expandedFactorsIndex = ref<number | null>(null)
const weekOffset = ref(0) // 0 = current week, -1 = prev, +1 = next
const monthOffset = ref(0) // 0 = current month

// --- Data ---
const forecasts = ref<ForecastResult[]>([])
const monthForecasts = ref<ForecastResult[]>([])
const precisionS1 = ref<{ precision: number; caRealise: number; caPrevu: number } | null>(null)

// --- Week navigation ---
function getWeekStartDate(offset: number): string {
  const today = new Date()
  const dayOfWeek = today.getDay() // 0=Sun
  const daysToMonday = dayOfWeek === 0 ? 6 : dayOfWeek - 1
  const monday = new Date(today)
  monday.setDate(today.getDate() - daysToMonday + (offset * 7))
  return monday.toISOString().split('T')[0]!
}

function goToPrevWeek() {
  weekOffset.value--
  recalculateForecasts()
}

function goToNextWeek() {
  weekOffset.value++
  recalculateForecasts()
}

function goToCurrentWeek() {
  weekOffset.value = 0
  recalculateForecasts()
}

function recalculateForecasts() {
  const startDate = getWeekStartDate(weekOffset.value)
  forecasts.value = store.calculateWeekForecast(startDate)
  expandedFactorsIndex.value = null
}

// --- Month navigation ---
function getMonthDate(offset: number): { year: number; month: number } {
  const today = new Date()
  const d = new Date(today.getFullYear(), today.getMonth() + offset, 1)
  return { year: d.getFullYear(), month: d.getMonth() }
}

function goToPrevMonth() {
  monthOffset.value--
  recalculateMonthForecasts()
}

function goToNextMonth() {
  monthOffset.value++
  recalculateMonthForecasts()
}

function goToCurrentMonth() {
  monthOffset.value = 0
  recalculateMonthForecasts()
}

function recalculateMonthForecasts() {
  const { year, month } = getMonthDate(monthOffset.value)
  monthForecasts.value = store.calculateMonthForecast(year, month)
}

const monthLabel = computed(() => {
  const { year, month } = getMonthDate(monthOffset.value)
  const d = new Date(year, month, 1)
  const label = d.toLocaleDateString('fr-FR', { month: 'long', year: 'numeric' })
  return label.charAt(0).toUpperCase() + label.slice(1)
})

const isCurrentMonth = computed(() => monthOffset.value === 0)

// Group month forecasts by week (Mon-Sun rows)
const monthWeeks = computed(() => {
  if (monthForecasts.value.length === 0) return []

  const { year, month } = getMonthDate(monthOffset.value)
  const firstDay = new Date(year, month, 1)
  const firstDow = firstDay.getDay() // 0=Sun
  // Offset to fill from Monday: how many days before the 1st to reach Monday
  const padBefore = firstDow === 0 ? 6 : firstDow - 1

  const weeks: (ForecastResult | null)[][] = []
  let currentWeek: (ForecastResult | null)[] = []

  // Pad start
  for (let i = 0; i < padBefore; i++) {
    currentWeek.push(null)
  }

  for (const fc of monthForecasts.value) {
    currentWeek.push(fc)
    if (currentWeek.length === 7) {
      weeks.push(currentWeek)
      currentWeek = []
    }
  }

  // Pad end
  if (currentWeek.length > 0) {
    while (currentWeek.length < 7) {
      currentWeek.push(null)
    }
    weeks.push(currentWeek)
  }

  return weeks
})

const monthTotalCA = computed(() => {
  return monthForecasts.value.reduce((sum, f) => sum + f.ca_prevision, 0)
})

const monthTotalTickets = computed(() => {
  return monthForecasts.value.reduce((sum, f) => sum + f.nb_tickets_prevision, 0)
})

const monthN1Total = computed(() => {
  let total = 0
  let hasData = false
  for (const fc of monthForecasts.value) {
    if (fc.ca_n1 !== null) {
      total += fc.ca_n1
      hasData = true
    }
  }
  return hasData ? total : null
})

const monthN1Evolution = computed(() => {
  if (monthN1Total.value === null || monthN1Total.value === 0) return null
  return ((monthTotalCA.value - monthN1Total.value) / monthN1Total.value) * 100
})

const monthAvgConfidence = computed(() => {
  if (monthForecasts.value.length === 0) return 0
  return Math.round(monthForecasts.value.reduce((s, f) => s + f.confidence, 0) / monthForecasts.value.length)
})

// Per-week subtotals for month view
function weekSubtotal(week: (ForecastResult | null)[]): number {
  return week.reduce((s, fc) => s + (fc?.ca_prevision ?? 0), 0)
}

const weekLabel = computed(() => {
  if (forecasts.value.length === 0) return ''
  const first = new Date(forecasts.value[0]!.date + 'T00:00:00')
  const last = new Date(forecasts.value[forecasts.value.length - 1]!.date + 'T00:00:00')
  const opts: Intl.DateTimeFormatOptions = { day: 'numeric', month: 'short' }
  return `${first.toLocaleDateString('fr-FR', opts)} — ${last.toLocaleDateString('fr-FR', opts)}`
})

const isCurrentWeek = computed(() => weekOffset.value === 0)

// --- Computed ---
const selectedForecast = computed<ForecastResult | null>(() => {
  return forecasts.value[selectedDayIndex.value] ?? null
})

const repartitionHoraire = computed(() => {
  const fc = selectedForecast.value
  if (!fc) return []
  return store.getRepartitionCA(fc)
})

const maxRepartitionPct = computed(() => {
  const pcts = repartitionHoraire.value.map(r => r.pourcentage)
  return pcts.length > 0 ? Math.max(...pcts) : 1
})

const weekTotalCA = computed(() => {
  return forecasts.value.reduce((sum, f) => sum + f.ca_prevision, 0)
})

const weekTotalTickets = computed(() => {
  return forecasts.value.reduce((sum, f) => sum + f.nb_tickets_prevision, 0)
})

const weekN1Total = computed(() => {
  return store.getWeekN1Total(forecasts.value)
})

const weekN1Evolution = computed(() => {
  if (weekN1Total.value === null || weekN1Total.value === 0) return null
  return ((weekTotalCA.value - weekN1Total.value) / weekN1Total.value) * 100
})

// --- Helpers ---
const JOURS_COURTS = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']
const JOURS_LONGS = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']
function formatDateFr(dateStr: string): string {
  const d = new Date(dateStr + 'T00:00:00')
  return d.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })
}

function formatHeure(h: number): string {
  return `${String(h).padStart(2, '0')}h`
}

function formatEuros(val: number): string {
  return val.toLocaleString('fr-FR', { maximumFractionDigits: 0 }) + ' \u20AC'
}

function formatEurosCompact(val: number): string {
  if (val >= 1000) {
    return (val / 1000).toFixed(1).replace('.0', '') + 'k'
  }
  return val.toLocaleString('fr-FR', { maximumFractionDigits: 0 })
}

function isFutureDate(dateStr: string): boolean {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  return new Date(dateStr + 'T00:00:00') >= today
}

function meteoHorizon(dateStr: string): number {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const target = new Date(dateStr + 'T00:00:00')
  return Math.round((target.getTime() - today.getTime()) / 86400000)
}

function isSeasonalMeteo(m: { id: string } | null): boolean {
  return m !== null && typeof m.id === 'string' && m.id.startsWith('seasonal-')
}

function confidenceColor(confidence: number): string {
  if (confidence >= 70) return 'var(--color-success)'
  if (confidence >= 40) return 'var(--color-warning)'
  return 'var(--color-danger)'
}

function coefficientClass(coeff: number): string {
  if (coeff > 1.02) return 'coeff-positive'
  if (coeff < 0.98) return 'coeff-negative'
  return 'coeff-neutral'
}

function evolutionN1(forecast: ForecastResult): string | null {
  if (forecast.ca_n1 === null || forecast.ca_n1 === 0) return null
  const pct = ((forecast.ca_prevision - forecast.ca_n1) / forecast.ca_n1) * 100
  const sign = pct >= 0 ? '+' : ''
  return `${sign}${pct.toFixed(0)}%`
}

function evolutionN1Class(forecast: ForecastResult): string {
  if (forecast.ca_n1 === null || forecast.ca_n1 === 0) return ''
  const pct = ((forecast.ca_prevision - forecast.ca_n1) / forecast.ca_n1) * 100
  if (pct > 2) return 'evo-positive'
  if (pct < -2) return 'evo-negative'
  return 'evo-neutral'
}

function toggleFactors(index: number): void {
  expandedFactorsIndex.value = expandedFactorsIndex.value === index ? null : index
}

function selectDay(index: number): void {
  selectedDayIndex.value = index
  if (viewMode.value === 'semaine') {
    viewMode.value = 'jour'
  }
}

function selectDayFromMonth(fc: ForecastResult): void {
  // Switch to week view centered on that day's week, then open day view
  const targetDate = new Date(fc.date + 'T00:00:00')
  const today = new Date()
  const todayDow = today.getDay()
  const daysToMonday = todayDow === 0 ? 6 : todayDow - 1
  const currentMonday = new Date(today)
  currentMonday.setDate(today.getDate() - daysToMonday)

  const targetDow = targetDate.getDay()
  const daysToTargetMonday = targetDow === 0 ? 6 : targetDow - 1
  const targetMonday = new Date(targetDate)
  targetMonday.setDate(targetDate.getDate() - daysToTargetMonday)

  const diffWeeks = Math.round((targetMonday.getTime() - currentMonday.getTime()) / (7 * 24 * 60 * 60 * 1000))
  weekOffset.value = diffWeeks
  recalculateForecasts()

  // Find index of clicked day in the week
  const dayIdx = targetDow === 0 ? 6 : targetDow - 1
  selectedDayIndex.value = dayIdx
  viewMode.value = 'jour'
}

function isToday(dateStr: string): boolean {
  return dateStr === new Date().toISOString().split('T')[0]
}

function dayOfMonth(dateStr: string): number {
  return new Date(dateStr + 'T00:00:00').getDate()
}

// --- Helpers: past date check ---
function isPastDate(dateStr: string): boolean {
  return dateStr < new Date().toISOString().split('T')[0]!
}

// --- Waterfall data for factors card ---
function getWaterfallSteps(fc: ForecastResult): { label: string; value: number; cumul: number; type: string; detail: string }[] {
  const steps: { label: string; value: number; cumul: number; type: string; detail: string }[] = []
  let running = fc.ca_base

  // Start with base
  steps.push({ label: 'Moyenne historique', value: fc.ca_base, cumul: fc.ca_base, type: 'base', detail: 'Moyenne des memes jours de semaine' })

  for (const f of fc.factors) {
    const impact = Math.round(running * (f.coefficient - 1))
    running += impact
    steps.push({
      label: f.label,
      value: impact,
      cumul: running,
      type: f.type,
      detail: f.detail,
    })
  }

  return steps
}

// --- Data diagnostics ---
const ventesValidees = computed(() => store.ventes.filter(v => v.cloture_validee).length)
const meteoCount = computed(() => store.meteo.length)

// --- Meteo backfill ---
const meteoBackfillStatus = ref<'idle' | 'running' | 'success' | 'error'>('idle')
const meteoBackfillMsg = ref('')

async function backfillMeteo() {
  meteoBackfillStatus.value = 'running'
  meteoBackfillMsg.value = 'Import meteo historique en cours...'
  try {
    const resp = await fetch('/.netlify/functions/backfill-meteo', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({}),
    })
    const data = await resp.json()
    if (data.success) {
      meteoBackfillStatus.value = 'success'
      meteoBackfillMsg.value = `${data.total_imported} jours de meteo importes (${data.date_from} a ${data.date_to})`
      await store.fetchMeteo()
      recalculateForecasts()
      recalculateMonthForecasts()
    } else {
      meteoBackfillStatus.value = 'error'
      meteoBackfillMsg.value = data.error || 'Erreur inconnue'
    }
  } catch (e: unknown) {
    meteoBackfillStatus.value = 'error'
    meteoBackfillMsg.value = (e as Error).message || String(e)
  }
}

// --- CA backfill ---
const caBackfillStatus = ref<'idle' | 'running' | 'success' | 'error'>('idle')
const caBackfillMsg = ref('')

async function backfillCA() {
  caBackfillStatus.value = 'running'
  caBackfillMsg.value = 'Import historique CA Zelty en cours...'
  try {
    const resp = await fetch('/.netlify/functions/backfill-zelty-ca', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({}),
    })
    const data = await resp.json()
    if (data.total_imported !== undefined) {
      caBackfillStatus.value = 'success'
      caBackfillMsg.value = `${data.total_imported} jours importes (${data.date_from} a ${data.date_to})`
      await store.fetchVentes()
      recalculateForecasts()
      recalculateMonthForecasts()
      precisionS1.value = store.calculatePrecisionS1()
    } else {
      caBackfillStatus.value = 'error'
      caBackfillMsg.value = data.error || 'Erreur inconnue'
    }
  } catch (e: unknown) {
    caBackfillStatus.value = 'error'
    caBackfillMsg.value = (e as Error).message || String(e)
  }
}

// --- Calendar sync ---
const calendarSyncStatus = ref<string | null>(null)
const calendarSyncing = ref(false)

async function syncCalendars() {
  calendarSyncing.value = true
  calendarSyncStatus.value = 'Synchronisation des calendriers (feries, vacances, soldes)...'
  try {
    const stats = await syncCalendriers()
    calendarSyncStatus.value = `Calendriers mis a jour : ${stats.joursFeries} feries, ${stats.vacances} vacances, ${stats.soldes} soldes`
    await store.fetchEvenements()
    recalculateForecasts()
    recalculateMonthForecasts()
    setTimeout(() => { calendarSyncStatus.value = null }, 5000)
  } catch {
    calendarSyncStatus.value = 'Erreur lors de la synchronisation des calendriers'
    setTimeout(() => { calendarSyncStatus.value = null }, 5000)
  } finally {
    calendarSyncing.value = false
  }
}

// --- Lifecycle ---
onMounted(async () => {
  await store.fetchAll()
  recalculateForecasts()
  recalculateMonthForecasts()
  precisionS1.value = store.calculatePrecisionS1()
  // Auto-sync calendars if no events exist
  if (store.evenements.length === 0) {
    syncCalendars()
  }
})

// Recalculate when data changes
watch(
  () => [store.ventes.length, store.meteo.length, store.evenements.length],
  () => {
    if (store.ventes.length > 0) {
      recalculateForecasts()
      recalculateMonthForecasts()
      precisionS1.value = store.calculatePrecisionS1()
    }
  }
)
</script>

<template>
  <div class="previsions">
    <!-- Header -->
    <div class="page-header">
      <h1>Previsions</h1>
      <div class="header-right">
        <div class="view-toggle">
          <button
            class="toggle-btn"
            :class="{ active: viewMode === 'mois' }"
            @click="viewMode = 'mois'"
          >
            Mois
          </button>
          <button
            class="toggle-btn"
            :class="{ active: viewMode === 'semaine' }"
            @click="viewMode = 'semaine'"
          >
            Semaine
          </button>
          <button
            class="toggle-btn"
            :class="{ active: viewMode === 'jour' }"
            @click="viewMode = 'jour'"
          >
            Jour
          </button>
        </div>
      </div>
    </div>

    <!-- Calendar sync status -->
    <div v-if="calendarSyncStatus" class="sync-status">{{ calendarSyncStatus }}</div>

    <!-- Loading -->
    <div v-if="store.loading" class="loading-state">
      <div class="spinner"></div>
      <p>Chargement des previsions...</p>
    </div>

    <!-- Error -->
    <div v-else-if="store.error" class="error-state">
      <p>{{ store.error }}</p>
      <button class="btn-retry" @click="store.fetchAll()">Reessayer</button>
    </div>

    <!-- Content -->
    <template v-else-if="forecasts.length > 0 || monthForecasts.length > 0">

      <!-- Data diagnostic banner -->
      <div v-if="(ventesValidees === 0 || meteoCount === 0) && !store.loading" class="data-warning">
        <div class="data-warning-icon">&#9888;</div>
        <div class="data-warning-content">
          <strong>Donnees manquantes</strong>
          <p>
            {{ ventesValidees }} jours de CA &middot;
            {{ meteoCount }} jours de meteo &middot;
            {{ store.evenements.length }} evenements calendrier
          </p>

          <div v-if="ventesValidees === 0" class="data-warning-action">
            <p>Aucune donnee de vente. Importez l'historique Zelty :</p>
            <button
              class="btn-backfill"
              :disabled="caBackfillStatus === 'running'"
              @click="backfillCA"
            >
              {{ caBackfillStatus === 'running' ? 'Import en cours...' : 'Importer le CA Zelty (18 mois)' }}
            </button>
            <span v-if="caBackfillMsg" class="backfill-inline-msg" :class="caBackfillStatus">{{ caBackfillMsg }}</span>
          </div>

          <div v-if="meteoCount === 0" class="data-warning-action">
            <p>Aucune donnee meteo. Importez l'historique :</p>
            <button
              class="btn-backfill"
              :disabled="meteoBackfillStatus === 'running'"
              @click="backfillMeteo"
            >
              {{ meteoBackfillStatus === 'running' ? 'Import en cours...' : 'Importer la meteo (18 mois)' }}
            </button>
            <span v-if="meteoBackfillMsg" class="backfill-inline-msg" :class="meteoBackfillStatus">{{ meteoBackfillMsg }}</span>
          </div>
        </div>
      </div>

      <!-- === MONTH VIEW === -->
      <div v-if="viewMode === 'mois'" class="month-view">

        <!-- Month navigation -->
        <div class="month-nav">
          <button class="nav-arrow-btn" @click="goToPrevMonth">&larr;</button>
          <div class="nav-center">
            <span class="nav-label">{{ monthLabel }}</span>
            <button
              v-if="!isCurrentMonth"
              class="btn-today-link"
              @click="goToCurrentMonth"
            >
              Mois actuel
            </button>
          </div>
          <button class="nav-arrow-btn" @click="goToNextMonth">&rarr;</button>
        </div>

        <!-- Month summary cards -->
        <div class="summary-row">
          <div class="summary-card summary-card--primary">
            <span class="summary-card-label">CA prevu</span>
            <span class="summary-card-value">{{ formatEuros(monthTotalCA) }}</span>
            <div v-if="monthN1Evolution !== null" class="summary-card-sub">
              <span
                class="evo-badge"
                :class="monthN1Evolution > 2 ? 'evo-positive' : monthN1Evolution < -2 ? 'evo-negative' : 'evo-neutral'"
              >
                {{ monthN1Evolution >= 0 ? '+' : '' }}{{ monthN1Evolution.toFixed(0) }}% vs N-1
              </span>
            </div>
          </div>
          <div class="summary-card">
            <span class="summary-card-label">N-1</span>
            <span class="summary-card-value">{{ monthN1Total !== null ? formatEuros(monthN1Total) : '--' }}</span>
          </div>
          <div class="summary-card">
            <span class="summary-card-label">Confiance moy.</span>
            <span
              class="summary-card-value"
              :style="{ color: confidenceColor(monthAvgConfidence) }"
            >
              {{ monthAvgConfidence }}%
            </span>
          </div>
          <div v-if="precisionS1" class="summary-card">
            <span class="summary-card-label">Precision S-1</span>
            <span
              class="summary-card-value"
              :style="{ color: precisionS1.precision >= 85 ? 'var(--color-success)' : precisionS1.precision >= 70 ? 'var(--color-warning)' : 'var(--color-danger)' }"
            >
              {{ precisionS1.precision }}%
            </span>
            <div class="summary-card-sub">
              <span class="summary-sub-text">{{ formatEuros(precisionS1.caPrevu) }} prevu / {{ formatEuros(precisionS1.caRealise) }} realise</span>
            </div>
          </div>
        </div>

        <!-- Calendar grid -->
        <div class="month-calendar">
          <!-- Day-of-week headers -->
          <div class="month-header-row">
            <div class="month-header-cell">Lun</div>
            <div class="month-header-cell">Mar</div>
            <div class="month-header-cell">Mer</div>
            <div class="month-header-cell">Jeu</div>
            <div class="month-header-cell">Ven</div>
            <div class="month-header-cell">Sam</div>
            <div class="month-header-cell">Dim</div>
            <div class="month-header-cell month-header-total">Total</div>
          </div>

          <!-- Week rows -->
          <div
            v-for="(week, wIdx) in monthWeeks"
            :key="wIdx"
            class="month-week-row"
          >
            <div
              v-for="(fc, dIdx) in week"
              :key="dIdx"
              class="month-cell"
              :class="{
                'month-cell--empty': !fc,
                'month-cell--today': fc && isToday(fc.date),
                'month-cell--ferme': fc && store.isJourFerme(fc.jour_semaine),
                'month-cell--weekend': dIdx >= 5,
              }"
              @click="fc && selectDayFromMonth(fc)"
            >
              <template v-if="fc">
                <div class="month-cell-header">
                  <span class="month-cell-day">{{ dayOfMonth(fc.date) }}</span>
                  <span class="month-cell-weather">
                    <span class="month-cell-meteo">{{ weatherCodeToEmoji(fc.meteo?.code_meteo ?? null) }}</span>
                    <span v-if="fc.meteo?.temperature_max != null" class="month-cell-temp">{{ fc.meteo.temperature_max.toFixed(0) }}&#176;</span>
                  </span>
                </div>
                <div v-if="!store.isJourFerme(fc.jour_semaine)" class="month-cell-body">
                  <span v-if="fc.ca_realise !== null" class="month-cell-ca month-cell-ca--realise">{{ formatEuros(fc.ca_realise) }}</span>
                  <span v-else class="month-cell-ca">{{ formatEuros(fc.ca_prevision) }}</span>
                  <div class="month-cell-confidence">
                    <div class="mini-confidence-bar">
                      <div
                        class="mini-confidence-fill"
                        :style="{
                          width: fc.confidence + '%',
                          background: confidenceColor(fc.confidence)
                        }"
                      ></div>
                    </div>
                  </div>
                  <div v-if="fc.evenements.length > 0" class="month-cell-events">
                    <span
                      v-for="evt in fc.evenements.slice(0, 1)"
                      :key="evt.id"
                      class="mini-event-tag"
                      :class="'event-' + evt.type"
                    >
                      {{ evt.nom.length > 8 ? evt.nom.slice(0, 8) + '..' : evt.nom }}
                    </span>
                  </div>
                  <div v-if="fc.ca_n1 !== null" class="month-cell-n1">
                    <span
                      class="mini-evo"
                      :class="evolutionN1Class(fc)"
                    >
                      {{ evolutionN1(fc) }}
                    </span>
                  </div>
                </div>
                <div v-else class="month-cell-ferme">Ferme</div>
              </template>
            </div>

            <!-- Week total -->
            <div class="month-cell month-cell--total">
              <span class="month-week-total">{{ formatEuros(weekSubtotal(week)) }}</span>
            </div>
          </div>
        </div>

        <!-- Sync info -->
        <div class="sync-section">
          <button
            class="btn-sync-calendars"
            :disabled="calendarSyncing"
            @click="syncCalendars"
          >
            {{ calendarSyncing ? 'Synchronisation...' : 'Mettre a jour les calendriers' }}
          </button>
          <span class="sync-hint">Jours feries, vacances scolaires et soldes</span>
        </div>
      </div>

      <!-- === WEEK VIEW === -->
      <div v-if="viewMode === 'semaine'" class="week-view">

        <!-- Week navigation -->
        <div class="week-nav">
          <button class="nav-arrow-btn" @click="goToPrevWeek">&larr;</button>
          <div class="nav-center">
            <span class="nav-label">{{ weekLabel }}</span>
            <button
              v-if="!isCurrentWeek"
              class="btn-today-link"
              @click="goToCurrentWeek"
            >
              Semaine actuelle
            </button>
          </div>
          <button class="nav-arrow-btn" @click="goToNextWeek">&rarr;</button>
        </div>

        <!-- Week summary -->
        <div class="summary-row">
          <div class="summary-card summary-card--primary">
            <span class="summary-card-label">CA semaine (prevu)</span>
            <span class="summary-card-value">{{ formatEuros(weekTotalCA) }}</span>
            <div v-if="weekN1Evolution !== null" class="summary-card-sub">
              <span
                class="evo-badge"
                :class="weekN1Evolution > 2 ? 'evo-positive' : weekN1Evolution < -2 ? 'evo-negative' : 'evo-neutral'"
              >
                {{ weekN1Evolution >= 0 ? '+' : '' }}{{ weekN1Evolution.toFixed(0) }}% vs N-1
              </span>
            </div>
          </div>
          <div class="summary-card">
            <span class="summary-card-label">N-1 semaine</span>
            <span class="summary-card-value">{{ weekN1Total !== null ? formatEuros(weekN1Total) : '--' }}</span>
          </div>
          <div v-if="precisionS1" class="summary-card">
            <span class="summary-card-label">Precision S-1</span>
            <span
              class="summary-card-value"
              :style="{ color: precisionS1.precision >= 85 ? 'var(--color-success)' : precisionS1.precision >= 70 ? 'var(--color-warning)' : 'var(--color-danger)' }"
            >
              {{ precisionS1.precision }}%
            </span>
            <div class="summary-card-sub">
              <span class="summary-sub-text">{{ formatEuros(precisionS1.caPrevu) }} prevu / {{ formatEuros(precisionS1.caRealise) }} realise</span>
            </div>
          </div>
        </div>

        <!-- Day cards -->
        <div class="day-cards">
          <div
            v-for="(fc, idx) in forecasts"
            :key="fc.date"
            class="day-card"
            :class="{
              'day-card--today': isToday(fc.date),
              'day-card--ferme': store.isJourFerme(fc.jour_semaine)
            }"
            @click="selectDay(idx)"
          >
            <!-- Day header -->
            <div class="day-card-header">
              <span class="day-name">{{ JOURS_COURTS[fc.jour_semaine] }}</span>
              <span class="day-date">{{ formatDateFr(fc.date) }}</span>
              <span v-if="isToday(fc.date)" class="today-badge">Auj.</span>
            </div>

            <!-- Closed indicator -->
            <div v-if="store.isJourFerme(fc.jour_semaine)" class="day-closed">
              Ferme
            </div>

            <template v-else>
              <!-- Weather -->
              <div class="day-meteo">
                <span class="meteo-icon">{{ weatherCodeToEmoji(fc.meteo?.code_meteo ?? null) }}</span>
                <template v-if="fc.meteo?.temperature_max !== null && fc.meteo?.temperature_max !== undefined">
                  <span v-if="fc.meteo?.temperature_min !== null && fc.meteo?.temperature_min !== undefined" class="meteo-temp">
                    {{ fc.meteo!.temperature_min.toFixed(0) }}&#176;/{{ fc.meteo!.temperature_max.toFixed(0) }}&#176;
                  </span>
                  <span v-else class="meteo-temp">
                    {{ fc.meteo!.temperature_max.toFixed(0) }}&#176;
                  </span>
                </template>
              </div>

              <!-- CA forecast / realise -->
              <div class="day-ca">
                <span v-if="fc.ca_realise !== null" class="ca-value ca-value--realise">{{ formatEuros(fc.ca_realise) }}</span>
                <span v-else class="ca-value">{{ formatEuros(fc.ca_prevision) }}</span>
                <span v-if="fc.ca_realise !== null" class="ca-sub">prevu: {{ formatEuros(fc.ca_prevision) }}</span>
              </div>

              <!-- N-1 comparison -->
              <div class="day-n1">
                <span class="n1-label">N-1 :</span>
                <span class="n1-value">{{ fc.ca_n1 !== null ? formatEuros(fc.ca_n1) : '--' }}</span>
                <span
                  v-if="evolutionN1(fc)"
                  class="n1-evo"
                  :class="evolutionN1Class(fc)"
                >
                  {{ evolutionN1(fc) }}
                </span>
              </div>

              <!-- Confidence -->
              <div class="day-confidence">
                <div class="confidence-bar">
                  <div
                    class="confidence-fill"
                    :style="{
                      width: fc.confidence + '%',
                      background: confidenceColor(fc.confidence)
                    }"
                  ></div>
                </div>
                <span class="confidence-label">{{ fc.confidence }}%</span>
              </div>

              <!-- Events -->
              <div v-if="fc.evenements.length > 0" class="day-events">
                <span
                  v-for="evt in fc.evenements"
                  :key="evt.id"
                  class="event-tag"
                  :class="'event-' + evt.type"
                >
                  {{ evt.nom }}
                </span>
              </div>

              <!-- Factors toggle -->
              <button
                v-if="fc.factors.length > 0"
                class="factors-toggle"
                @click.stop="toggleFactors(idx)"
              >
                {{ expandedFactorsIndex === idx ? 'Masquer' : 'Facteurs' }}
                ({{ fc.factors.length }})
              </button>

              <!-- Factors breakdown -->
              <div
                v-if="expandedFactorsIndex === idx"
                class="factors-list"
                @click.stop
              >
                <div
                  v-for="(factor, fIdx) in fc.factors"
                  :key="fIdx"
                  class="factor-item"
                >
                  <div class="factor-header">
                    <span class="factor-label">{{ factor.label }}</span>
                    <span
                      class="factor-coeff"
                      :class="coefficientClass(factor.coefficient)"
                    >
                      x{{ factor.coefficient.toFixed(2) }}
                    </span>
                  </div>
                  <span class="factor-detail">{{ factor.detail }}</span>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>

      <!-- === DAY VIEW === -->
      <div v-if="viewMode === 'jour' && selectedForecast" class="day-view">

        <!-- Day navigation -->
        <div class="day-nav">
          <button
            class="nav-arrow-btn"
            :disabled="selectedDayIndex === 0"
            @click="selectedDayIndex--"
          >
            &larr;
          </button>
          <div class="nav-center">
            <span class="nav-label">
              {{ JOURS_LONGS[selectedForecast.jour_semaine] }}
              {{ formatDateFr(selectedForecast.date) }}
            </span>
            <span v-if="isToday(selectedForecast.date)" class="today-badge">Aujourd'hui</span>
          </div>
          <button
            class="nav-arrow-btn"
            :disabled="selectedDayIndex >= forecasts.length - 1"
            @click="selectedDayIndex++"
          >
            &rarr;
          </button>
        </div>

        <!-- Day detail cards -->
        <div class="detail-cards">

          <!-- Main forecast card -->
          <div class="detail-card detail-card--main">
            <div class="detail-row">
              <div class="detail-metric">
                <span class="metric-label">CA prevu</span>
                <span class="metric-value metric-value--large">
                  {{ formatEuros(selectedForecast.ca_prevision) }}
                </span>
              </div>
              <div v-if="selectedForecast.ca_realise !== null" class="detail-metric">
                <span class="metric-label">CA realise</span>
                <span class="metric-value metric-value--large metric-value--realise">
                  {{ formatEuros(selectedForecast.ca_realise) }}
                </span>
                <span
                  v-if="selectedForecast.ca_realise > 0"
                  class="metric-ecart"
                  :class="selectedForecast.ca_realise >= selectedForecast.ca_prevision ? 'evo-positive' : 'evo-negative'"
                >
                  Ecart : {{ selectedForecast.ca_realise >= selectedForecast.ca_prevision ? '+' : '' }}{{ ((selectedForecast.ca_realise - selectedForecast.ca_prevision) / selectedForecast.ca_prevision * 100).toFixed(0) }}%
                  ({{ selectedForecast.ca_realise >= selectedForecast.ca_prevision ? '+' : '' }}{{ formatEuros(selectedForecast.ca_realise - selectedForecast.ca_prevision) }})
                </span>
              </div>
              <div v-else-if="isPastDate(selectedForecast.date)" class="detail-metric">
                <span class="metric-label">CA realise</span>
                <span class="metric-value metric-value--large metric-value--missing">--</span>
                <span class="metric-missing-hint">Pas de donnee Zelty</span>
              </div>
              <div v-else class="detail-metric">
                <span class="metric-label">Tickets</span>
                <span class="metric-value metric-value--large">
                  {{ selectedForecast.nb_tickets_prevision }}
                </span>
              </div>
            </div>

            <!-- N-1 comparison -->
            <div v-if="selectedForecast.ca_n1 !== null" class="detail-n1">
              <span class="n1-label-full">Meme jour N-1 :</span>
              <span class="n1-value-full">{{ formatEuros(selectedForecast.ca_n1) }}</span>
              <span
                v-if="evolutionN1(selectedForecast)"
                class="n1-evo n1-evo--large"
                :class="evolutionN1Class(selectedForecast)"
              >
                {{ evolutionN1(selectedForecast) }}
              </span>
            </div>

            <!-- Confidence -->
            <div class="detail-confidence">
              <span class="confidence-text">
                Confiance :
                <strong :style="{ color: confidenceColor(selectedForecast.confidence) }">
                  {{ selectedForecast.confidence }}%
                </strong>
              </span>
              <div class="confidence-bar confidence-bar--large">
                <div
                  class="confidence-fill"
                  :style="{
                    width: selectedForecast.confidence + '%',
                    background: confidenceColor(selectedForecast.confidence)
                  }"
                ></div>
              </div>
            </div>
          </div>

          <!-- Weather card (always shown, with empty state) -->
          <div class="detail-card detail-card--meteo">
            <h3>
              Meteo
              <template v-if="selectedForecast.meteo">
                <span v-if="isSeasonalMeteo(selectedForecast.meteo)" class="meteo-source-badge meteo-source--seasonal">
                  Moy. saisonniere
                </span>
                <span v-else-if="isFutureDate(selectedForecast.date) && meteoHorizon(selectedForecast.date) > 7" class="meteo-source-badge meteo-source--extended">
                  Prevision etendue
                </span>
              </template>
            </h3>
            <div v-if="selectedForecast.meteo" class="meteo-detail">
              <span class="meteo-icon-large">
                {{ weatherCodeToEmoji(selectedForecast.meteo.code_meteo) }}
              </span>
              <div class="meteo-data">
                <div v-if="selectedForecast.meteo.temperature_max !== null" class="meteo-row">
                  <span class="meteo-label">Max</span>
                  <span class="meteo-val">{{ selectedForecast.meteo.temperature_max!.toFixed(0) }}&#176;C</span>
                </div>
                <div v-if="selectedForecast.meteo.temperature_min !== null" class="meteo-row">
                  <span class="meteo-label">Min</span>
                  <span class="meteo-val">{{ selectedForecast.meteo.temperature_min!.toFixed(0) }}&#176;C</span>
                </div>
                <div v-if="selectedForecast.meteo.precipitation_mm !== null" class="meteo-row">
                  <span class="meteo-label">Pluie</span>
                  <span class="meteo-val">{{ selectedForecast.meteo.precipitation_mm!.toFixed(1) }} mm</span>
                </div>
                <div v-if="selectedForecast.meteo.ensoleillement_secondes !== null" class="meteo-row">
                  <span class="meteo-label">Soleil</span>
                  <span class="meteo-val">
                    {{ (selectedForecast.meteo.ensoleillement_secondes! / 3600).toFixed(1) }}h
                  </span>
                </div>
                <div v-if="selectedForecast.meteo.couverture_nuageuse_pct !== null" class="meteo-row">
                  <span class="meteo-label">Nuages</span>
                  <span class="meteo-val">{{ selectedForecast.meteo.couverture_nuageuse_pct }}%</span>
                </div>
              </div>
            </div>
            <div v-else class="meteo-empty">
              <p v-if="isFutureDate(selectedForecast.date)">
                Previsions meteo non disponibles. Elles seront synchronisees automatiquement.
              </p>
              <template v-else>
                <p>Pas de donnees meteo pour cette date.</p>
                <button
                  v-if="meteoBackfillStatus !== 'running'"
                  class="btn-backfill"
                  @click="backfillMeteo"
                >
                  Importer l'historique meteo
                </button>
                <p v-if="meteoBackfillMsg" class="backfill-msg" :class="meteoBackfillStatus">
                  {{ meteoBackfillMsg }}
                </p>
              </template>
            </div>
          </div>

          <!-- Events card -->
          <div
            v-if="selectedForecast.evenements.length > 0"
            class="detail-card detail-card--events"
          >
            <h3>Evenements</h3>
            <div
              v-for="evt in selectedForecast.evenements"
              :key="evt.id"
              class="event-detail"
            >
              <span class="event-tag" :class="'event-' + evt.type">{{ evt.nom }}</span>
              <span class="event-coeff">
                {{ evt.coefficient > 1 ? '+' : '' }}{{ ((evt.coefficient - 1) * 100).toFixed(0) }}% de frequentation
              </span>
              <span v-if="evt.notes" class="event-notes">{{ evt.notes }}</span>
            </div>
          </div>

          <!-- Waterfall factors card (replaces the old x0.86 style) -->
          <div
            v-if="selectedForecast.factors.length > 0"
            class="detail-card detail-card--factors"
          >
            <h3>Comment est calcule le CA prevu</h3>
            <div class="waterfall">
              <div
                v-for="(step, sIdx) in getWaterfallSteps(selectedForecast)"
                :key="sIdx"
                class="waterfall-step"
                :class="{ 'waterfall-step--base': step.type === 'base' }"
              >
                <div class="waterfall-step-header">
                  <span v-if="step.type !== 'base'" class="factor-type-badge" :class="'factor-type-' + step.type">
                    {{ step.type === 'meteo' ? 'Meteo'
                      : step.type === 'evenement' ? 'Evenement'
                      : step.type === 'tendance' ? 'Tendance'
                      : step.type === 'rupture_meteo' ? 'Rupture'
                      : step.type === 'temperature' ? 'Temperature'
                      : '' }}
                  </span>
                  <span class="waterfall-label">{{ step.label }}</span>
                  <span
                    class="waterfall-impact"
                    :class="step.type === 'base' ? '' : step.value >= 0 ? 'impact-positive' : 'impact-negative'"
                  >
                    {{ step.type === 'base' ? formatEuros(step.value) : (step.value >= 0 ? '+' : '') + formatEuros(step.value) }}
                  </span>
                </div>
                <div class="waterfall-step-detail">
                  <span class="waterfall-detail-text">{{ step.detail }}</span>
                  <span v-if="step.type !== 'base'" class="waterfall-running">= {{ formatEuros(step.cumul) }}</span>
                </div>
              </div>
              <!-- Final result -->
              <div class="waterfall-step waterfall-step--result">
                <div class="waterfall-step-header">
                  <span class="waterfall-label">CA prevu final</span>
                  <span class="waterfall-impact waterfall-impact--final">{{ formatEuros(selectedForecast.ca_prevision) }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- Hourly distribution (Section 7.6) -->
          <div class="detail-card detail-card--repartition">
            <h3>Repartition horaire prevue du CA</h3>
            <div v-if="repartitionHoraire.length > 0" class="hourly-chart">
              <div
                v-for="slot in repartitionHoraire"
                :key="slot.heure"
                class="hourly-bar-wrapper"
              >
                <span class="hourly-ca">{{ formatEuros(slot.ca) }}</span>
                <div class="hourly-bar-container">
                  <div
                    class="hourly-bar"
                    :style="{
                      height: (slot.pourcentage / maxRepartitionPct) * 100 + '%',
                    }"
                  >
                    <span class="hourly-pct">{{ slot.pourcentage.toFixed(0) }}%</span>
                  </div>
                </div>
                <span class="hourly-label">{{ formatHeure(slot.heure) }}</span>
              </div>
            </div>
            <div v-else class="empty-repartition">
              <p>Pas de donnees de repartition horaire disponibles.</p>
              <p class="empty-repartition-hint">La repartition horaire necessite l'import des tickets Zelty horodates.</p>
            </div>
          </div>

        </div>
      </div>

      <!-- Empty day view fallback -->
      <div v-if="viewMode === 'jour' && !selectedForecast" class="empty-state">
        <p>Selectionnez un jour pour voir le detail</p>
      </div>

    </template>

    <!-- No data -->
    <div v-else class="empty-state">
      <p>Aucune donnee historique disponible pour generer des previsions.</p>
      <p class="empty-hint">Les previsions necessitent des donnees de ventes validees (clotures Zelty).</p>
      <p class="empty-hint">Verifiez que la synchronisation quotidienne Zelty fonctionne dans Parametres &gt; Zelty.</p>
    </div>
  </div>
</template>

<style scoped>
/* --- Page layout --- */
.previsions {
  max-width: 1280px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 28px;
  color: var(--text-primary);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* --- Data warning --- */
.data-warning {
  display: flex;
  gap: 12px;
  padding: 14px 18px;
  background: #fffbeb;
  border: 1px solid #fcd34d;
  border-radius: var(--radius-md);
  margin-bottom: 16px;
  align-items: flex-start;
}

.data-warning-icon {
  font-size: 24px;
  line-height: 1;
  flex-shrink: 0;
}

.data-warning-content {
  flex: 1;
}

.data-warning-content strong {
  display: block;
  font-size: 15px;
  color: #92400e;
  margin-bottom: 4px;
}

.data-warning-content p {
  font-size: 13px;
  color: #78350f;
  margin: 0 0 4px 0;
  line-height: 1.4;
}

.data-warning-hint {
  font-size: 12px;
  color: #a16207;
  margin-top: 6px;
}

.sync-status {
  padding: 8px 16px;
  background: #eff6ff;
  border: 1px solid #bfdbfe;
  border-radius: var(--radius-md);
  color: #1e40af;
  font-size: 13px;
  margin-bottom: 16px;
  text-align: center;
}

/* --- View toggle --- */
.view-toggle {
  display: flex;
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 4px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.toggle-btn {
  padding: 10px 20px;
  border: none;
  background: transparent;
  font-size: 15px;
  font-weight: 600;
  color: var(--text-secondary);
  border-radius: var(--radius-sm);
  cursor: pointer;
  min-height: 48px;
  transition: all 0.2s;
}

.toggle-btn.active {
  background: var(--color-primary);
  color: white;
}

/* --- Loading --- */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 80px 20px;
  gap: 16px;
  color: var(--text-secondary);
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid var(--border);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

/* --- Error --- */
.error-state {
  text-align: center;
  padding: 40px 20px;
  color: var(--color-danger);
}

.btn-retry {
  margin-top: 16px;
  padding: 12px 28px;
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  min-height: 48px;
}

/* --- Shared navigation --- */
.nav-arrow-btn {
  width: 48px;
  height: 48px;
  border: 1px solid var(--border);
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  font-size: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-primary);
  flex-shrink: 0;
}

.nav-arrow-btn:active:not(:disabled) {
  background: var(--bg-hover);
}

.nav-arrow-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.week-nav,
.month-nav,
.day-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.nav-center {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.nav-label {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
}

.btn-today-link {
  border: none;
  background: none;
  color: var(--color-primary);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  text-decoration: underline;
  padding: 0;
}

.today-badge {
  background: var(--color-primary);
  color: white;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 700;
}

/* ============================= */
/* SHARED SUMMARY                */
/* ============================= */
.summary-row {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.summary-card {
  flex: 1;
  min-width: 140px;
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 14px 18px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.summary-card--primary {
  border-left: 4px solid var(--color-primary);
}

.summary-card-label {
  display: block;
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.summary-card-value {
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
}

.summary-card-sub {
  margin-top: 4px;
}

.evo-badge {
  font-size: 13px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 6px;
}

.summary-sub-text {
  font-size: 12px;
  color: var(--text-tertiary);
}

/* ============================= */
/* MONTH VIEW                    */
/* ============================= */
.month-calendar {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  overflow: hidden;
}

.month-header-row {
  display: grid;
  grid-template-columns: repeat(7, 1fr) 80px;
  background: var(--bg-hover, #f9fafb);
  border-bottom: 1px solid var(--border);
}

.month-header-cell {
  padding: 10px 4px;
  text-align: center;
  font-size: 13px;
  font-weight: 700;
  color: var(--text-secondary);
  text-transform: uppercase;
}

.month-header-total {
  background: var(--bg-hover, #f3f4f6);
}

.month-week-row {
  display: grid;
  grid-template-columns: repeat(7, 1fr) 80px;
  border-bottom: 1px solid var(--border);
}

.month-week-row:last-child {
  border-bottom: none;
}

.month-cell {
  padding: 8px 6px;
  min-height: 90px;
  border-right: 1px solid var(--border);
  cursor: pointer;
  transition: background 0.15s;
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.month-cell:hover:not(.month-cell--empty) {
  background: #f0f7ff;
}

.month-cell--empty {
  background: var(--bg-hover, #f9fafb);
  cursor: default;
}

.month-cell--today {
  background: #fff7ed;
  box-shadow: inset 0 0 0 2px var(--color-primary);
}

.month-cell--ferme {
  opacity: 0.5;
}

.month-cell--weekend {
  background: var(--bg-hover, #fafafa);
}

.month-cell--weekend.month-cell--today {
  background: #fff7ed;
}

.month-cell--total {
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-hover, #f9fafb);
  border-right: none;
  min-height: 90px;
  cursor: default;
}

.month-cell-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.month-cell-day {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-primary);
}

.month-cell--today .month-cell-day {
  color: var(--color-primary);
}

.month-cell-weather {
  display: flex;
  align-items: center;
  gap: 2px;
}

.month-cell-meteo {
  font-size: 14px;
}

.month-cell-temp {
  font-size: 11px;
  color: var(--text-secondary);
  font-weight: 500;
}

.month-cell-body {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.month-cell-ca {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
}

.month-cell-ca--realise {
  color: var(--color-primary);
}

.mini-confidence-bar {
  height: 3px;
  background: var(--border);
  border-radius: 2px;
  overflow: hidden;
}

.mini-confidence-fill {
  height: 100%;
  border-radius: inherit;
}

.month-cell-events {
  margin-top: 1px;
}

.mini-event-tag {
  display: inline-block;
  padding: 1px 4px;
  border-radius: 3px;
  font-size: 9px;
  font-weight: 600;
}

.month-cell-n1 {
  margin-top: 1px;
}

.mini-evo {
  font-size: 10px;
  font-weight: 700;
  padding: 0px 4px;
  border-radius: 3px;
}

.month-cell-ferme {
  font-size: 11px;
  color: var(--text-tertiary);
  font-style: italic;
  text-align: center;
  padding: 8px 0;
}

.month-week-total {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-primary);
}

/* --- Sync section --- */
.sync-section {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 16px;
  padding: 12px 16px;
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.btn-sync-calendars {
  padding: 8px 16px;
  border: 1px solid var(--border);
  background: white;
  border-radius: var(--radius-md);
  font-size: 13px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  min-height: 40px;
  white-space: nowrap;
}

.btn-sync-calendars:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-sync-calendars:active:not(:disabled) {
  background: var(--bg-hover);
}

.sync-hint {
  font-size: 12px;
  color: var(--text-tertiary);
}

/* ============================= */
/* WEEK VIEW                     */
/* ============================= */

/* --- Day cards grid --- */
.day-cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(155px, 1fr));
  gap: 12px;
}

.day-card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  cursor: pointer;
  transition: box-shadow 0.15s, transform 0.15s;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.day-card:active {
  transform: scale(0.98);
}

.day-card--today {
  border: 2px solid var(--color-primary);
}

.day-card--ferme {
  opacity: 0.5;
}

.day-card-header {
  display: flex;
  align-items: center;
  gap: 6px;
  flex-wrap: wrap;
}

.day-name {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
}

.day-date {
  font-size: 13px;
  color: var(--text-secondary);
}

.day-closed {
  text-align: center;
  color: var(--text-tertiary);
  font-size: 14px;
  font-style: italic;
  padding: 12px 0;
}

/* --- Day card: weather --- */
.day-meteo {
  display: flex;
  align-items: center;
  gap: 6px;
}

.meteo-icon {
  font-size: 22px;
}

.meteo-temp {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

/* --- Day card: CA --- */
.day-ca {
  display: flex;
  flex-direction: column;
}

.ca-value {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
}

.ca-value--realise {
  color: var(--color-primary);
}

.ca-sub {
  font-size: 11px;
  color: var(--text-tertiary);
}

.ca-tickets {
  font-size: 13px;
  color: var(--text-secondary);
}

/* --- N-1 comparison --- */
.day-n1 {
  display: flex;
  align-items: center;
  gap: 4px;
  flex-wrap: wrap;
}

.n1-label {
  font-size: 12px;
  color: var(--text-tertiary);
}

.n1-value {
  font-size: 12px;
  color: var(--text-secondary);
}

.n1-evo {
  font-size: 12px;
  font-weight: 700;
  padding: 1px 6px;
  border-radius: 6px;
}

.evo-positive {
  color: var(--color-success);
  background: #dcfce7;
}

.evo-negative {
  color: var(--color-danger);
  background: #fee2e2;
}

.evo-neutral {
  color: var(--text-secondary);
  background: #f3f4f6;
}

/* --- Confidence --- */
.day-confidence {
  display: flex;
  align-items: center;
  gap: 6px;
}

.confidence-bar {
  flex: 1;
  height: 6px;
  background: var(--border);
  border-radius: 3px;
  overflow: hidden;
}

.confidence-bar--large {
  height: 10px;
  border-radius: 5px;
  margin-top: 8px;
}

.confidence-fill {
  height: 100%;
  border-radius: inherit;
  transition: width 0.4s ease;
}

.confidence-label {
  font-size: 11px;
  font-weight: 600;
  color: var(--text-tertiary);
  min-width: 30px;
  text-align: right;
}

/* --- Events --- */
.day-events {
  display: flex;
  flex-wrap: wrap;
  gap: 4px;
}

.event-tag {
  display: inline-block;
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 600;
}

.event-ferie {
  background: #fef3c7;
  color: #92400e;
}

.event-vacances {
  background: #dbeafe;
  color: #1e40af;
}

.event-soldes {
  background: #fce7f3;
  color: #9d174d;
}

.event-custom {
  background: #e5e7eb;
  color: #374151;
}

/* --- Factors toggle --- */
.factors-toggle {
  border: none;
  background: none;
  color: var(--color-primary);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  padding: 4px 0;
  text-align: left;
  min-height: auto;
}

.factors-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  border-top: 1px solid var(--border);
  padding-top: 8px;
}

.factor-item {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.factor-header {
  display: flex;
  align-items: center;
  gap: 8px;
}

.factor-label {
  font-size: 13px;
  font-weight: 600;
  color: var(--text-primary);
}

.factor-coeff {
  font-size: 13px;
  font-weight: 700;
  margin-left: auto;
}

.coeff-positive { color: var(--color-success); }
.coeff-negative { color: var(--color-danger); }
.coeff-neutral { color: var(--text-secondary); }

.factor-detail {
  font-size: 12px;
  color: var(--text-secondary);
  line-height: 1.3;
}

.factor-type-badge {
  padding: 1px 6px;
  border-radius: 4px;
  font-size: 10px;
  font-weight: 700;
  text-transform: uppercase;
}

.factor-type-meteo { background: #dbeafe; color: #1e40af; }
.factor-type-evenement { background: #fef3c7; color: #92400e; }
.factor-type-tendance { background: #e5e7eb; color: #374151; }
.factor-type-rupture_meteo { background: #fee2e2; color: #991b1b; }
.factor-type-temperature { background: #fce7f3; color: #9d174d; }

/* --- Waterfall chart --- */
.waterfall {
  display: flex;
  flex-direction: column;
  gap: 0;
}

.waterfall-step {
  padding: 10px 12px;
  border-bottom: 1px solid var(--border);
}

.waterfall-step:last-child {
  border-bottom: none;
}

.waterfall-step--base {
  background: #f8fafc;
  border-radius: var(--radius-sm) var(--radius-sm) 0 0;
}

.waterfall-step--result {
  background: #f0fdf4;
  border-radius: 0 0 var(--radius-sm) var(--radius-sm);
  border-top: 2px solid var(--color-success);
}

.waterfall-step-header {
  display: flex;
  align-items: center;
  gap: 8px;
}

.waterfall-label {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  flex: 1;
}

.waterfall-impact {
  font-size: 15px;
  font-weight: 700;
  white-space: nowrap;
}

.impact-positive {
  color: var(--color-success);
}

.impact-negative {
  color: var(--color-danger);
}

.waterfall-impact--final {
  font-size: 18px;
  color: var(--text-primary);
}

.waterfall-step-detail {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-top: 2px;
}

.waterfall-detail-text {
  font-size: 12px;
  color: var(--text-tertiary);
  flex: 1;
}

.waterfall-running {
  font-size: 12px;
  color: var(--text-secondary);
  font-weight: 600;
}

/* --- Backfill buttons --- */
.btn-backfill {
  padding: 8px 16px;
  border: 1px solid var(--color-primary);
  background: white;
  color: var(--color-primary);
  border-radius: var(--radius-md);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  min-height: 40px;
}

.btn-backfill:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-backfill:active:not(:disabled) {
  background: #fff7ed;
}

.backfill-msg,
.backfill-inline-msg {
  font-size: 12px;
  margin-top: 6px;
}

.backfill-msg.success,
.backfill-inline-msg.success {
  color: var(--color-success);
}

.backfill-msg.error,
.backfill-inline-msg.error {
  color: var(--color-danger);
}

.backfill-msg.running,
.backfill-inline-msg.running {
  color: #1e40af;
}

.backfill-inline-msg {
  display: block;
}

.data-warning-action {
  margin-top: 8px;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
}

.data-warning-action p {
  width: 100%;
  margin: 0;
}

/* --- CA realise --- */
.metric-value--realise {
  color: var(--color-primary);
}

.metric-value--missing {
  color: var(--text-tertiary);
}

.metric-ecart {
  display: block;
  font-size: 13px;
  font-weight: 600;
  margin-top: 4px;
  padding: 2px 8px;
  border-radius: 6px;
}

.metric-missing-hint {
  display: block;
  font-size: 12px;
  color: var(--text-tertiary);
  margin-top: 4px;
}

/* --- Meteo empty state --- */
.meteo-empty {
  text-align: center;
  padding: 16px 0;
  color: var(--text-tertiary);
}

.meteo-empty p {
  margin: 0 0 10px 0;
  font-size: 14px;
}

.empty-repartition-hint {
  font-size: 12px;
  color: var(--text-tertiary);
  margin-top: 4px;
}

/* ============================= */
/* DAY VIEW                       */
/* ============================= */

/* --- Detail cards --- */
.detail-cards {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
}

.detail-card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.detail-card h3 {
  font-size: 18px;
  color: var(--text-primary);
  margin-bottom: 14px;
}

/* --- Main card --- */
.detail-row {
  display: flex;
  gap: 24px;
}

.detail-metric {
  flex: 1;
}

.metric-label {
  display: block;
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.metric-value--large {
  display: block;
  font-size: 32px;
  font-weight: 700;
  color: var(--text-primary);
}

.detail-n1 {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid var(--border);
}

.n1-label-full {
  font-size: 15px;
  color: var(--text-secondary);
}

.n1-value-full {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

.n1-evo--large {
  font-size: 15px;
  padding: 3px 10px;
}

.detail-confidence {
  margin-top: 16px;
}

.confidence-text {
  font-size: 14px;
  color: var(--text-secondary);
}

/* --- Weather detail --- */
.meteo-detail {
  display: flex;
  gap: 20px;
  align-items: flex-start;
}

.meteo-icon-large {
  font-size: 48px;
}

.meteo-data {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.meteo-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.meteo-label {
  font-size: 14px;
  color: var(--text-secondary);
}

.meteo-val {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

.empty-meteo {
  color: var(--text-secondary);
  font-size: 14px;
  text-align: center;
  padding: 12px 0;
}

.meteo-source-badge {
  font-size: 11px;
  font-weight: 500;
  padding: 2px 8px;
  border-radius: 10px;
  margin-left: 8px;
  vertical-align: middle;
}

.meteo-source--seasonal {
  background: #fef3c7;
  color: #92400e;
}

.meteo-source--extended {
  background: #dbeafe;
  color: #1e40af;
}

/* --- Events detail --- */
.event-detail {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 10px 0;
  border-bottom: 1px solid var(--border);
}

.event-detail:last-child {
  border-bottom: none;
}

.event-coeff {
  font-size: 14px;
  color: var(--text-secondary);
}

.event-notes {
  font-size: 13px;
  color: var(--text-tertiary);
  font-style: italic;
}

/* --- Hourly chart (Section 7.6) --- */
.hourly-chart {
  display: flex;
  align-items: flex-end;
  gap: 6px;
  height: 240px;
  padding-top: 24px;
}

.hourly-bar-wrapper {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  height: 100%;
  min-width: 0;
}

.hourly-ca {
  font-size: 10px;
  font-weight: 600;
  color: var(--text-secondary);
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 100%;
}

.hourly-bar-container {
  flex: 1;
  width: 100%;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}

.hourly-bar {
  width: 100%;
  max-width: 40px;
  min-height: 4px;
  background: var(--color-primary);
  border-radius: 4px 4px 0 0;
  position: relative;
  transition: height 0.4s ease;
  display: flex;
  align-items: flex-start;
  justify-content: center;
}

.hourly-pct {
  font-size: 10px;
  font-weight: 700;
  color: white;
  padding-top: 2px;
  white-space: nowrap;
}

.hourly-label {
  font-size: 11px;
  color: var(--text-secondary);
  margin-top: 6px;
  font-weight: 600;
}

.empty-repartition {
  text-align: center;
  color: var(--text-tertiary);
  font-size: 14px;
  padding: 24px 0;
}

/* --- Empty state --- */
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: var(--text-secondary);
}

.empty-hint {
  font-size: 14px;
  color: var(--text-tertiary);
  margin-top: 8px;
}

/* --- Responsive: iPad landscape --- */
@media (min-width: 1024px) {
  .day-cards {
    grid-template-columns: repeat(7, 1fr);
  }

  .detail-cards {
    grid-template-columns: repeat(2, 1fr);
  }

  .detail-card--repartition {
    grid-column: 1 / -1;
  }

  .detail-card--main {
    grid-column: 1 / -1;
  }
}

/* --- Responsive: iPad portrait --- */
@media (min-width: 700px) and (max-width: 1023px) {
  .day-cards {
    grid-template-columns: repeat(4, 1fr);
  }

  .detail-cards {
    grid-template-columns: repeat(2, 1fr);
  }

  .detail-card--repartition,
  .detail-card--main {
    grid-column: 1 / -1;
  }

  .month-header-row,
  .month-week-row {
    grid-template-columns: repeat(7, 1fr) 60px;
  }

  .month-cell-ca {
    font-size: 14px;
  }
}

/* --- Responsive: phone --- */
@media (max-width: 699px) {
  .day-cards {
    grid-template-columns: repeat(2, 1fr);
  }

  .summary-row {
    flex-direction: column;
  }

  .hourly-chart {
    height: 180px;
  }

  .hourly-ca {
    display: none;
  }

  /* Month view: scroll horizontally on small screens */
  .month-calendar {
    overflow-x: auto;
  }

  .month-header-row,
  .month-week-row {
    min-width: 700px;
  }

  .month-cell {
    min-height: 70px;
  }
}
</style>
