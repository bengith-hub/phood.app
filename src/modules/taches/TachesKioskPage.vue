<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useTachesStore } from '@/stores/taches'
import { useTaskRealtime } from '@/composables/useTaskRealtime'
import { useAuth } from '@/composables/useAuth'
import { restCall } from '@/lib/rest-client'
import TacheCardKiosk from './TacheCardKiosk.vue'
import TachePhotoCapture from './TachePhotoCapture.vue'
import type { TacheInstance, Station } from '@/types/database'

const route = useRoute()
const store = useTachesStore()
const { profile } = useAuth()

// Station from route param or 'all' for roaming iPad
const station = ref<Station | 'all'>(
  (route.params.station as Station) || 'all'
)

// Active station for display (when 'all', user toggles between salle/cuisine)
const activeStation = ref<Station>(
  station.value === 'all' ? 'salle' : station.value
)

// Subscribe to Realtime
useTaskRealtime(station)

// Current task index for carousel
const currentIndex = ref(0)

// Plans de salle URLs from config
const planSalleUrl = ref<string | null>(null)
const planTerrasseUrl = ref<string | null>(null)
const showPlan = ref(false)
const activePlan = ref<'salle' | 'terrasse'>('salle')
const hasAnyPlan = computed(() => !!planSalleUrl.value || !!planTerrasseUrl.value)
const activePlanUrl = computed(() =>
  activePlan.value === 'salle' ? planSalleUrl.value : planTerrasseUrl.value
)

// Bottom sheet state
const showPhotoCapture = ref(false)
const showRejectForm = ref(false)
const pendingTask = ref<TacheInstance | null>(null)
const rejectReason = ref('')

// Filtered tasks for current station
const tasks = computed(() => {
  const s = activeStation.value
  return store.todayInstances.filter(i => i.station === s)
})

const currentTask = computed(() => tasks.value[currentIndex.value])

const doneCount = computed(() => tasks.value.filter(t => t.statut !== 'en_attente').length)

// Today's date formatted
const todayFormatted = computed(() => {
  const d = new Date()
  return d.toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
})

// Wake Lock
let wakeLock: WakeLockSentinel | null = null

async function requestWakeLock() {
  try {
    if ('wakeLock' in navigator) {
      wakeLock = await navigator.wakeLock.request('screen')
    }
  } catch {
    // Silently fail (not supported or denied)
  }
}

// Navigation
function prev() {
  if (currentIndex.value > 0) currentIndex.value--
}

function next() {
  if (currentIndex.value < tasks.value.length - 1) currentIndex.value++
}

// Clamp index when tasks change
watch(tasks, (list) => {
  if (currentIndex.value >= list.length) {
    currentIndex.value = Math.max(0, list.length - 1)
  }
})

// Validation handlers
function onValidate(task: TacheInstance) {
  pendingTask.value = task
  showPhotoCapture.value = true
}

async function onPhotoCaptured(url: string) {
  if (!pendingTask.value || !profile.value) return
  await store.validateTask(pendingTask.value.id, 'fait', url, undefined, profile.value.id)
  showPhotoCapture.value = false
  pendingTask.value = null
}

function onReject(task: TacheInstance) {
  pendingTask.value = task
  rejectReason.value = ''
  showRejectForm.value = true
}

async function confirmReject() {
  if (!pendingTask.value || !profile.value || rejectReason.value.length < 20) return
  await store.validateTask(pendingTask.value.id, 'non_fait', undefined, rejectReason.value, profile.value.id)
  showRejectForm.value = false
  pendingTask.value = null
  rejectReason.value = ''
}

async function onUndo(task: TacheInstance) {
  if (!profile.value) return
  await store.validateTask(task.id, 'en_attente', undefined, undefined, undefined)
}

function cancelBottomSheet() {
  showPhotoCapture.value = false
  showRejectForm.value = false
  pendingTask.value = null
  rejectReason.value = ''
}

// Station toggle (roaming iPad)
function toggleStation() {
  activeStation.value = activeStation.value === 'salle' ? 'cuisine' : 'salle'
  currentIndex.value = 0
}

// Fetch config for plan URLs
async function fetchConfig() {
  try {
    const config = await restCall<{ plan_salle_url: string | null; plan_terrasse_url: string | null }[]>(
      'GET',
      'config?select=plan_salle_url,plan_terrasse_url&limit=1'
    )
    if (config?.[0]) {
      planSalleUrl.value = config[0].plan_salle_url
      planTerrasseUrl.value = config[0].plan_terrasse_url
    }
  } catch { /* ignore */ }
}

onMounted(async () => {
  await store.fetchTodayInstances()
  await fetchConfig()
  requestWakeLock()
})

onUnmounted(() => {
  if (wakeLock) {
    wakeLock.release().catch(() => {})
    wakeLock = null
  }
})

// Re-acquire wake lock on visibility change (iOS drops it when backgrounded)
function handleVisibilityChange() {
  if (document.visibilityState === 'visible') {
    requestWakeLock()
  }
}
onMounted(() => document.addEventListener('visibilitychange', handleVisibilityChange))
onUnmounted(() => document.removeEventListener('visibilitychange', handleVisibilityChange))
</script>

<template>
  <div class="kiosk-page">
    <!-- Header -->
    <header class="kiosk-header">
      <div class="header-left">
        <span class="station-label" :class="activeStation">
          {{ activeStation === 'salle' ? 'SALLE' : 'CUISINE' }}
        </span>
        <!-- Toggle for roaming iPad -->
        <button
          v-if="station === 'all'"
          class="toggle-station"
          @click="toggleStation"
        >
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4"/>
          </svg>
        </button>
      </div>

      <span class="header-date">{{ todayFormatted }}</span>

      <div class="header-right">
        <!-- Plan de salle button -->
        <button
          v-if="hasAnyPlan"
          class="plan-btn"
          title="Plans"
          @click="showPlan = true"
        >
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="3" y="3" width="18" height="18" rx="2"/>
            <path d="M3 9h18M9 3v18"/>
          </svg>
        </button>

        <span class="progress-badge">{{ doneCount }}/{{ tasks.length }}</span>
      </div>
    </header>

    <!-- Loading -->
    <div v-if="store.loading && tasks.length === 0" class="kiosk-empty">
      Chargement...
    </div>

    <!-- Empty state -->
    <div v-else-if="tasks.length === 0" class="kiosk-empty">
      <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="#d1d5db" stroke-width="1.5">
        <path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
        <path d="M9 14l2 2 4-4"/>
      </svg>
      <p>Aucune tâche pour {{ activeStation === 'salle' ? 'la salle' : 'la cuisine' }} aujourd'hui</p>
    </div>

    <!-- Task carousel -->
    <main v-else class="kiosk-main">
      <TacheCardKiosk
        v-if="currentTask"
        :task="currentTask"
        @validate="onValidate"
        @reject="onReject"
        @undo="onUndo"
      />
    </main>

    <!-- Navigation arrows -->
    <div v-if="tasks.length > 1" class="kiosk-nav">
      <button class="nav-btn" :disabled="currentIndex === 0" @click="prev">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="15 18 9 12 15 6"/>
        </svg>
        Précédent
      </button>

      <div class="nav-dots">
        <span
          v-for="(t, idx) in tasks"
          :key="t.id"
          class="dot"
          :class="{
            active: idx === currentIndex,
            done: t.statut === 'fait',
            rejected: t.statut === 'non_fait'
          }"
          @click="currentIndex = idx"
        />
      </div>

      <button class="nav-btn" :disabled="currentIndex === tasks.length - 1" @click="next">
        Suivante
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="9 18 15 12 9 6"/>
        </svg>
      </button>
    </div>

    <!-- Bottom sheet: Photo capture -->
    <div v-if="showPhotoCapture" class="bottom-sheet-overlay" @click.self="cancelBottomSheet">
      <div class="bottom-sheet">
        <TachePhotoCapture
          :instance-id="pendingTask?.id || ''"
          @captured="onPhotoCaptured"
          @cancel="cancelBottomSheet"
        />
      </div>
    </div>

    <!-- Bottom sheet: Reject reason -->
    <div v-if="showRejectForm" class="bottom-sheet-overlay" @click.self="cancelBottomSheet">
      <div class="bottom-sheet">
        <div class="reject-form">
          <p class="reject-title">Raison du non-fait</p>
          <textarea
            v-model="rejectReason"
            class="reject-textarea"
            placeholder="Expliquez pourquoi cette tâche n'a pas été faite (min. 20 caractères)..."
            rows="4"
          />
          <p class="reject-counter" :class="{ valid: rejectReason.length >= 20 }">
            {{ rejectReason.length }} / 20 caractères minimum
          </p>
          <div class="reject-actions">
            <button class="reject-cancel" @click="cancelBottomSheet">Annuler</button>
            <button
              class="reject-confirm"
              :disabled="rejectReason.length < 20"
              @click="confirmReject"
            >
              Confirmer
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Plan de salle fullscreen overlay -->
    <div v-if="showPlan" class="plan-overlay">
      <div class="plan-header">
        <!-- Tab toggle (only if both plans exist) -->
        <div v-if="planSalleUrl && planTerrasseUrl" class="plan-tabs">
          <button
            :class="['plan-tab', { active: activePlan === 'salle' }]"
            @click="activePlan = 'salle'"
          >Salle</button>
          <button
            :class="['plan-tab', { active: activePlan === 'terrasse' }]"
            @click="activePlan = 'terrasse'"
          >Terrasse</button>
        </div>
        <span v-else class="plan-title">{{ planSalleUrl ? 'Plan salle' : 'Plan terrasse' }}</span>
        <button class="plan-close" @click="showPlan = false">
          <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round">
            <line x1="18" y1="6" x2="6" y2="18"/>
            <line x1="6" y1="6" x2="18" y2="18"/>
          </svg>
        </button>
      </div>
      <iframe
        v-if="activePlanUrl"
        :key="activePlan"
        :src="activePlanUrl"
        class="plan-iframe"
        frameborder="0"
        allowfullscreen
      />
      <div v-else class="plan-empty">Aucun plan configuré pour cette vue.</div>
    </div>
  </div>
</template>

<style scoped>
.kiosk-page {
  display: flex;
  flex-direction: column;
  height: 100vh;
  height: 100dvh;
  background: #f9fafb;
  overflow: hidden;
  user-select: none;
  -webkit-user-select: none;
}

/* Header */
.kiosk-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 20px;
  background: white;
  border-bottom: 1px solid var(--border, #D1D5DB);
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 8px;
}

.station-label {
  font-size: 18px;
  font-weight: 800;
  letter-spacing: 1px;
  padding: 6px 16px;
  border-radius: 20px;
  color: white;
}

.station-label.salle { background: #E85D2C; }
.station-label.cuisine { background: #2563eb; }

.toggle-station {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: 8px;
  background: white;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}

.header-date {
  font-size: 16px;
  color: var(--text-secondary, #4B5563);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.plan-btn {
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: 8px;
  background: white;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}
.plan-btn:active { background: #f3f4f6; }

.progress-badge {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary, #111);
  background: #f3f4f6;
  padding: 6px 14px;
  border-radius: 20px;
}

/* Main content */
.kiosk-main {
  flex: 1;
  min-height: 0;
  overflow: hidden;
}

.kiosk-empty {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  color: var(--text-secondary, #4B5563);
  font-size: 20px;
}

/* Navigation */
.kiosk-nav {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 20px;
  background: white;
  border-top: 1px solid var(--border, #D1D5DB);
  flex-shrink: 0;
}

.nav-btn {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 12px 20px;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  background: white;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-primary, #111);
}
.nav-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}
.nav-btn:not(:disabled):active { background: #f3f4f6; }

.nav-dots {
  display: flex;
  gap: 8px;
  align-items: center;
}

.dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #d1d5db;
  cursor: pointer;
  transition: transform 0.15s;
}
.dot.active { transform: scale(1.4); background: #6b7280; }
.dot.done { background: #16a34a; }
.dot.rejected { background: #dc2626; }

/* Bottom sheets */
.bottom-sheet-overlay {
  position: fixed;
  inset: 0;
  z-index: 100;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: flex-end;
  justify-content: center;
}

.bottom-sheet {
  width: 100%;
  max-width: 600px;
  background: white;
  border-radius: 20px 20px 0 0;
  padding: 8px 0;
  max-height: 70vh;
  overflow-y: auto;
}

/* Reject form */
.reject-form {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.reject-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary, #111);
  margin: 0;
}

.reject-textarea {
  width: 100%;
  padding: 14px;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  font-size: 18px;
  resize: none;
  font-family: inherit;
}
.reject-textarea:focus {
  outline: none;
  border-color: var(--color-primary, #E85D2C);
}

.reject-counter {
  font-size: 14px;
  color: #dc2626;
  margin: 0;
}
.reject-counter.valid { color: #16a34a; }

.reject-actions {
  display: flex;
  gap: 12px;
}

.reject-cancel {
  flex: 1;
  padding: 14px;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  background: white;
  font-size: 18px;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}

.reject-confirm {
  flex: 1;
  padding: 14px;
  border: none;
  border-radius: var(--radius-sm, 8px);
  background: #dc2626;
  color: white;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
}
.reject-confirm:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

/* Plan de salle overlay */
.plan-overlay {
  position: fixed;
  inset: 0;
  z-index: 200;
  background: rgba(0, 0, 0, 0.95);
  display: flex;
  flex-direction: column;
}

.plan-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  flex-shrink: 0;
}

.plan-tabs {
  display: flex;
  gap: 4px;
  background: rgba(255, 255, 255, 0.15);
  border-radius: 10px;
  padding: 3px;
}

.plan-tab {
  padding: 10px 24px;
  border: none;
  border-radius: 8px;
  background: transparent;
  color: rgba(255, 255, 255, 0.7);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}
.plan-tab.active {
  background: white;
  color: #111;
}

.plan-title {
  color: white;
  font-size: 18px;
  font-weight: 600;
}

.plan-close {
  background: rgba(255, 255, 255, 0.15);
  border: none;
  border-radius: 50%;
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  flex-shrink: 0;
}

.plan-iframe {
  flex: 1;
  width: 100%;
  border: none;
  background: white;
}

.plan-empty {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  color: rgba(255, 255, 255, 0.5);
  font-size: 18px;
}
</style>
