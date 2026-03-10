<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { usePrevisionsStore, weatherCodeToEmoji } from '@/stores/previsions'
import type { ForecastResult } from '@/stores/previsions'
import { syncCalendriers } from '@/lib/calendriers'

const store = usePrevisionsStore()

// --- State ---
const viewMode = ref<'semaine' | 'jour'>('semaine')
const selectedDayIndex = ref(0)
const expandedFactorsIndex = ref<number | null>(null)
const weekOffset = ref(0) // 0 = current week, -1 = prev, +1 = next

// --- Data ---
const forecasts = ref<ForecastResult[]>([])
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

function isToday(dateStr: string): boolean {
  return dateStr === new Date().toISOString().split('T')[0]
}

const calendarSyncStatus = ref<string | null>(null)

async function syncCalendars() {
  calendarSyncStatus.value = 'Synchronisation calendriers...'
  try {
    const stats = await syncCalendriers()
    calendarSyncStatus.value = `Calendriers synchro : ${stats.joursFeries} feries, ${stats.vacances} vacances, ${stats.soldes} soldes`
    // Reload events after sync
    await store.fetchEvenements()
    forecasts.value = store.calculateWeekForecast()
    setTimeout(() => { calendarSyncStatus.value = null }, 5000)
  } catch {
    calendarSyncStatus.value = 'Erreur sync calendriers'
    setTimeout(() => { calendarSyncStatus.value = null }, 5000)
  }
}

// --- Lifecycle ---
onMounted(async () => {
  await store.fetchAll()
  recalculateForecasts()
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
        <button class="btn-sync" @click="syncCalendars" title="Sync calendriers">&#x1F4C5; Sync</button>
        <div class="view-toggle">
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
    <template v-else-if="forecasts.length > 0">

      <!-- === WEEK VIEW === -->
      <div v-if="viewMode === 'semaine'" class="week-view">

        <!-- Week navigation -->
        <div class="week-nav">
          <button class="week-nav-arrow" @click="goToPrevWeek">&larr;</button>
          <div class="week-nav-center">
            <span class="week-nav-label">{{ weekLabel }}</span>
            <button
              v-if="!isCurrentWeek"
              class="btn-today-link"
              @click="goToCurrentWeek"
            >
              Semaine actuelle
            </button>
          </div>
          <button class="week-nav-arrow" @click="goToNextWeek">&rarr;</button>
        </div>

        <!-- Week summary -->
        <div class="week-summary">
          <div class="summary-item">
            <span class="summary-label">CA semaine (prevu)</span>
            <span class="summary-value">{{ formatEuros(weekTotalCA) }}</span>
            <div v-if="weekN1Evolution !== null" class="summary-sub">
              <span
                class="summary-evo"
                :class="weekN1Evolution > 2 ? 'evo-positive' : weekN1Evolution < -2 ? 'evo-negative' : 'evo-neutral'"
              >
                {{ weekN1Evolution >= 0 ? '+' : '' }}{{ weekN1Evolution.toFixed(0) }}% vs N-1
              </span>
            </div>
          </div>
          <div class="summary-item">
            <span class="summary-label">N-1 semaine</span>
            <span class="summary-value">{{ weekN1Total !== null ? formatEuros(weekN1Total) : '--' }}</span>
          </div>
          <div class="summary-item">
            <span class="summary-label">Tickets semaine</span>
            <span class="summary-value">{{ weekTotalTickets }}</span>
          </div>
          <div v-if="precisionS1" class="summary-item">
            <span class="summary-label">Precision S-1</span>
            <span
              class="summary-value"
              :style="{ color: precisionS1.precision >= 85 ? 'var(--color-success)' : precisionS1.precision >= 70 ? 'var(--color-warning)' : 'var(--color-danger)' }"
            >
              {{ precisionS1.precision }}%
            </span>
            <div class="summary-sub">
              <span class="summary-sub-text">Prevu {{ formatEuros(precisionS1.caPrevu) }} / Realise {{ formatEuros(precisionS1.caRealise) }}</span>
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

              <!-- CA forecast -->
              <div class="day-ca">
                <span class="ca-value">{{ formatEuros(fc.ca_prevision) }}</span>
                <span class="ca-tickets">{{ fc.nb_tickets_prevision }} tickets</span>
              </div>

              <!-- N-1 comparison (always visible) -->
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
            class="nav-arrow"
            :disabled="selectedDayIndex === 0"
            @click="selectedDayIndex--"
          >
            &larr;
          </button>
          <div class="day-nav-title">
            <span class="day-nav-name">
              {{ JOURS_LONGS[selectedForecast.jour_semaine] }}
            </span>
            <span class="day-nav-date">{{ formatDateFr(selectedForecast.date) }}</span>
            <span v-if="isToday(selectedForecast.date)" class="today-badge">Aujourd'hui</span>
          </div>
          <button
            class="nav-arrow"
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
              <div class="detail-metric">
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

          <!-- Weather card -->
          <div v-if="selectedForecast.meteo" class="detail-card detail-card--meteo">
            <h3>Meteo</h3>
            <div class="meteo-detail">
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
              <span class="event-coeff">Coefficient : {{ evt.coefficient.toFixed(2) }}</span>
              <span v-if="evt.notes" class="event-notes">{{ evt.notes }}</span>
            </div>
          </div>

          <!-- Factors card -->
          <div
            v-if="selectedForecast.factors.length > 0"
            class="detail-card detail-card--factors"
          >
            <h3>Facteurs de prevision</h3>
            <div
              v-for="(factor, fIdx) in selectedForecast.factors"
              :key="fIdx"
              class="factor-item"
            >
              <div class="factor-header">
                <span class="factor-type-badge" :class="'factor-type-' + factor.type">
                  {{ factor.type === 'meteo' ? 'Meteo'
                    : factor.type === 'evenement' ? 'Evenement'
                    : factor.type === 'tendance' ? 'Tendance'
                    : factor.type === 'rupture_meteo' ? 'Rupture'
                    : 'Temperature' }}
                </span>
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

          <!-- Hourly distribution (Section 7.6) -->
          <div class="detail-card detail-card--repartition">
            <h3>Repartition horaire du CA</h3>
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
              Pas de donnees de repartition horaire disponibles
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
    </div>
  </div>
</template>

<style scoped>
/* --- Page layout --- */
.previsions {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
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

.btn-sync {
  padding: 10px 16px;
  border: 1px solid var(--border);
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  min-height: 48px;
}

.btn-sync:active {
  background: var(--bg-hover);
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
  padding: 10px 24px;
  border: none;
  background: transparent;
  font-size: 16px;
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

/* --- Week navigation --- */
.week-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
}

.week-nav-arrow {
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
}

.week-nav-arrow:active {
  background: var(--bg-hover);
}

.week-nav-center {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.week-nav-label {
  font-size: 17px;
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

/* --- Week summary --- */
.week-summary {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.summary-item {
  flex: 1;
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 16px 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.summary-label {
  display: block;
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 4px;
}

.summary-value {
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
}

.summary-sub {
  margin-top: 4px;
}

.summary-evo {
  font-size: 13px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 6px;
}

.summary-sub-text {
  font-size: 12px;
  color: var(--text-tertiary);
}

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

.today-badge {
  background: var(--color-primary);
  color: white;
  padding: 2px 8px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 700;
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

/* ============================= */
/* DAY VIEW                       */
/* ============================= */
.day-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 20px;
}

.nav-arrow {
  width: 56px;
  height: 56px;
  border: 1px solid var(--border);
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  font-size: 22px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-primary);
}

.nav-arrow:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.nav-arrow:active:not(:disabled) {
  background: var(--bg-hover);
}

.day-nav-title {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 2px;
}

.day-nav-name {
  font-size: 22px;
  font-weight: 700;
  color: var(--text-primary);
}

.day-nav-date {
  font-size: 15px;
  color: var(--text-secondary);
}

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
}

/* --- Responsive: phone --- */
@media (max-width: 699px) {
  .day-cards {
    grid-template-columns: repeat(2, 1fr);
  }

  .week-summary {
    flex-direction: column;
  }

  .hourly-chart {
    height: 180px;
  }

  .hourly-ca {
    display: none;
  }
}
</style>
