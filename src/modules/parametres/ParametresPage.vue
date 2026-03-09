<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { supabase } from '@/lib/supabase'
import { useAuth } from '@/composables/useAuth'
import { syncCalendriers } from '@/lib/calendriers'
import type { Config, ZoneStockage, Profile } from '@/types/database'

const { profile: myProfile } = useAuth()

const config = ref<Config | null>(null)
const zones = ref<ZoneStockage[]>([])
const profiles = ref<Profile[]>([])
const loading = ref(true)
const saving = ref(false)
const saveMsg = ref('')
const activeTab = ref<'general' | 'zones' | 'users' | 'calendriers' | 'zelty'>('general')

// Calendar sync
const calSyncStatus = ref('')

// New zone form
const newZoneName = ref('')

// Zelty sync
interface CronLog {
  id: string
  job_name: string
  started_at: string
  finished_at: string | null
  status: 'running' | 'success' | 'error'
  duration_ms: number | null
  error_message: string | null
}
const cronLogs = ref<CronLog[]>([])
const zeltyBackfillFrom = ref('')
const zeltyBackfillTo = ref('')
const zeltyBackfillStatus = ref<'idle' | 'running' | 'success' | 'error'>('idle')
const zeltyBackfillMsg = ref('')

// Zelty photo sync
const zeltyPhotoStatus = ref<'idle' | 'running' | 'success' | 'error'>('idle')
const zeltyPhotoMsg = ref('')
const zeltyPhotoForce = ref(false)
const ventesCount = ref(0)

const lastSuccessSync = computed(() => {
  return cronLogs.value.find(l => l.job_name === 'sync-zelty-ca' && l.status === 'success') || null
})

onMounted(async () => {
  await Promise.all([loadConfig(), loadZones(), loadProfiles()])
  loading.value = false
})

// Lazy-load Zelty data when tab is activated
watch(activeTab, async (tab) => {
  if (tab === 'zelty' && cronLogs.value.length === 0) {
    await Promise.all([loadCronLogs(), loadVentesCount()])
  }
})

async function loadConfig() {
  const { data } = await supabase.from('config').select('*').single()
  if (data) config.value = data as Config
}

async function loadZones() {
  const { data } = await supabase.from('zones_stockage').select('*').order('ordre')
  if (data) zones.value = data as ZoneStockage[]
}

async function loadProfiles() {
  const { data } = await supabase.from('profiles').select('*').order('nom')
  if (data) profiles.value = data as Profile[]
}

async function saveConfig() {
  if (!config.value) return
  saving.value = true
  saveMsg.value = ''
  const { error } = await supabase
    .from('config')
    .update({
      seuil_ecart_prix_pct: config.value.seuil_ecart_prix_pct,
      delai_alerte_avoir_heures: config.value.delai_alerte_avoir_heures,
      delai_expiration_avoir_heures: config.value.delai_expiration_avoir_heures,
      destinataires_email_avoir: config.value.destinataires_email_avoir,
      destinataires_email_alertes: config.value.destinataires_email_alertes,
    })
    .eq('id', config.value.id)
  saving.value = false
  saveMsg.value = error ? `Erreur : ${error.message}` : 'Enregistré'
  if (!error) setTimeout(() => saveMsg.value = '', 3000)
}

async function addZone() {
  if (!newZoneName.value.trim()) return
  const ordre = zones.value.length + 1
  const { error } = await supabase
    .from('zones_stockage')
    .insert({ nom: newZoneName.value.trim(), ordre })
  if (!error) {
    newZoneName.value = ''
    await loadZones()
  }
}

async function deleteZone(id: string) {
  const { error } = await supabase.from('zones_stockage').delete().eq('id', id)
  if (!error) await loadZones()
}

async function updateRole(profileId: string, newRole: string) {
  if (profileId === myProfile.value?.id) return // Can't change own role
  await supabase.from('profiles').update({ role: newRole }).eq('id', profileId)
  await loadProfiles()
}

async function syncCalendars() {
  calSyncStatus.value = 'Synchronisation...'
  try {
    const stats = await syncCalendriers()
    calSyncStatus.value = `OK : ${stats.joursFeries} fériés, ${stats.vacances} vacances, ${stats.soldes} soldes`
    setTimeout(() => calSyncStatus.value = '', 5000)
  } catch {
    calSyncStatus.value = 'Erreur de synchronisation'
  }
}

// ── Zelty ──────────────────────────────────────────────────────────────
async function loadCronLogs() {
  const { data } = await supabase
    .from('cron_logs')
    .select('*')
    .order('started_at', { ascending: false })
    .limit(20)
  if (data) cronLogs.value = data as CronLog[]
}

async function loadVentesCount() {
  const { count } = await supabase
    .from('ventes_historique')
    .select('*', { count: 'exact', head: true })
  ventesCount.value = count || 0
}

async function startBackfill() {
  zeltyBackfillStatus.value = 'running'
  zeltyBackfillMsg.value = 'Import en cours...'

  try {
    const body: Record<string, string> = {}
    if (zeltyBackfillFrom.value) body.date_from = zeltyBackfillFrom.value
    if (zeltyBackfillTo.value) body.date_to = zeltyBackfillTo.value

    const resp = await fetch('/.netlify/functions/backfill-zelty-ca', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    })

    if (!resp.ok) {
      const errData = await resp.json().catch(() => ({ error: `HTTP ${resp.status}` }))
      throw new Error(errData.error || `Erreur ${resp.status}`)
    }

    const result = await resp.json()
    zeltyBackfillStatus.value = 'success'
    zeltyBackfillMsg.value = `Import terminé : ${result.imported} jours importés, ${result.skipped} ignorés, ${result.errors} erreurs (${result.date_from} → ${result.date_to})`

    // Reload data
    await Promise.all([loadCronLogs(), loadVentesCount()])
  } catch (e: unknown) {
    zeltyBackfillStatus.value = 'error'
    zeltyBackfillMsg.value = `Erreur : ${(e as Error).message || String(e)}`
  }
}

async function startPhotoSync() {
  zeltyPhotoStatus.value = 'running'
  zeltyPhotoMsg.value = 'Récupération des photos Zelty en cours...'

  try {
    const resp = await fetch('/.netlify/functions/sync-zelty-photos', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ force_overwrite: zeltyPhotoForce.value }),
    })

    if (!resp.ok) {
      const errData = await resp.json().catch(() => ({ error: `HTTP ${resp.status}` }))
      throw new Error(errData.error || `Erreur ${resp.status}`)
    }

    const r = await resp.json()
    zeltyPhotoStatus.value = 'success'
    zeltyPhotoMsg.value = `Terminé : ${r.synced} photos synchronisées, ${r.skipped_already_has_photo} déjà présentes, ${r.skipped_no_zelty_photo} sans photo Zelty. (${r.zelty_products_total} produits Zelty, ${r.zelty_products_with_photos} avec photo)`
  } catch (e: unknown) {
    zeltyPhotoStatus.value = 'error'
    zeltyPhotoMsg.value = `Erreur : ${(e as Error).message || String(e)}`
  }
}

function formatDate(iso: string | null) {
  if (!iso) return '—'
  const d = new Date(iso)
  return d.toLocaleDateString('fr-FR', {
    day: '2-digit', month: '2-digit', year: 'numeric',
    hour: '2-digit', minute: '2-digit',
  })
}

function formatDuration(ms: number | null) {
  if (!ms) return '—'
  if (ms < 1000) return `${ms}ms`
  return `${(ms / 1000).toFixed(1)}s`
}
</script>

<template>
  <div class="parametres-page">
    <h1 class="page-title">Paramètres</h1>

    <div v-if="loading" class="loading">Chargement...</div>

    <template v-else>
      <!-- Tabs -->
      <div class="tabs">
        <button
          v-for="tab in [
            { key: 'general', label: 'Général' },
            { key: 'zones', label: 'Zones de stockage' },
            { key: 'users', label: 'Utilisateurs' },
            { key: 'calendriers', label: 'Calendriers' },
            { key: 'zelty', label: 'Zelty' },
          ]"
          :key="tab.key"
          class="tab"
          :class="{ active: activeTab === tab.key }"
          @click="activeTab = tab.key as typeof activeTab"
        >
          {{ tab.label }}
        </button>
      </div>

      <!-- General settings -->
      <div v-if="activeTab === 'general'" class="tab-content">
        <div v-if="config" class="settings-form">
          <div class="field-group">
            <label>Seuil alerte écart prix (%)</label>
            <input
              v-model.number="config.seuil_ecart_prix_pct"
              type="number"
              inputmode="numeric"
              min="0"
              max="100"
              step="1"
            />
            <span class="hint">Alerte si prix BL dépasse ce % vs BC</span>
          </div>

          <div class="field-group">
            <label>Délai alerte avoir (heures)</label>
            <input
              v-model.number="config.delai_alerte_avoir_heures"
              type="number"
              inputmode="numeric"
              min="1"
            />
            <span class="hint">Rappel si demande d'avoir non résolue</span>
          </div>

          <div class="field-group">
            <label>Expiration avoir (heures)</label>
            <input
              v-model.number="config.delai_expiration_avoir_heures"
              type="number"
              inputmode="numeric"
              min="1"
            />
          </div>

          <div class="field-group">
            <label>Emails alertes (séparés par virgule)</label>
            <input
              :value="config.destinataires_email_alertes?.join(', ')"
              @change="config.destinataires_email_alertes = ($event.target as HTMLInputElement).value.split(',').map(e => e.trim()).filter(Boolean)"
            />
          </div>

          <div class="field-group">
            <label>Emails avoirs (séparés par virgule)</label>
            <input
              :value="config.destinataires_email_avoir?.join(', ')"
              @change="config.destinataires_email_avoir = ($event.target as HTMLInputElement).value.split(',').map(e => e.trim()).filter(Boolean)"
            />
          </div>

          <div class="actions">
            <button class="btn-save" :disabled="saving" @click="saveConfig">
              {{ saving ? 'Enregistrement...' : 'Enregistrer' }}
            </button>
            <span v-if="saveMsg" class="save-msg" :class="{ error: saveMsg.startsWith('Erreur') }">
              {{ saveMsg }}
            </span>
          </div>
        </div>
        <p v-else class="empty">Aucune configuration trouvée. Exécutez la migration initiale.</p>
      </div>

      <!-- Zones de stockage -->
      <div v-if="activeTab === 'zones'" class="tab-content">
        <div class="zones-list">
          <div v-for="zone in zones" :key="zone.id" class="zone-row">
            <span class="zone-name">{{ zone.nom }}</span>
            <button class="btn-delete" @click="deleteZone(zone.id)">Supprimer</button>
          </div>
          <div v-if="zones.length === 0" class="empty">Aucune zone définie</div>
        </div>
        <div class="add-zone">
          <input v-model="newZoneName" placeholder="Nouvelle zone..." @keyup.enter="addZone" />
          <button class="btn-add" @click="addZone">Ajouter</button>
        </div>
      </div>

      <!-- Users -->
      <div v-if="activeTab === 'users'" class="tab-content">
        <div class="users-list">
          <div v-for="p in profiles" :key="p.id" class="user-row">
            <div class="user-info">
              <span class="user-name">{{ p.nom }}</span>
              <span class="user-email">{{ p.email }}</span>
            </div>
            <select
              :value="p.role"
              :disabled="p.id === myProfile?.id"
              @change="updateRole(p.id, ($event.target as HTMLSelectElement).value)"
            >
              <option value="admin">Admin</option>
              <option value="manager">Manager</option>
              <option value="operator">Opérateur</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Calendriers -->
      <div v-if="activeTab === 'calendriers'" class="tab-content">
        <p class="section-desc">
          Synchronise les jours fériés, vacances scolaires (Zone A) et soldes pour l'année en cours et suivante.
        </p>
        <button class="btn-sync" @click="syncCalendars">
          Synchroniser les calendriers
        </button>
        <p v-if="calSyncStatus" class="sync-status">{{ calSyncStatus }}</p>
      </div>

      <!-- Zelty -->
      <div v-if="activeTab === 'zelty'" class="tab-content">
        <!-- Status cards -->
        <div class="zelty-status-cards">
          <div class="status-card">
            <span class="status-label">Données ventes</span>
            <span class="status-value">{{ ventesCount }} jours</span>
          </div>
          <div class="status-card" v-if="lastSuccessSync">
            <span class="status-label">Dernière sync</span>
            <span class="status-value status-ok">{{ formatDate(lastSuccessSync.started_at) }}</span>
          </div>
          <div class="status-card" v-else>
            <span class="status-label">Dernière sync</span>
            <span class="status-value status-none">Aucune</span>
          </div>
        </div>

        <!-- Backfill section -->
        <div class="zelty-section">
          <h3 class="section-title">Import historique Zelty</h3>
          <p class="section-desc">
            Récupère les clôtures de caisse depuis l'API Zelty et les importe dans la table ventes_historique.
            Par défaut : 18 derniers mois.
          </p>
          <div class="backfill-form">
            <div class="backfill-dates">
              <div class="field-group">
                <label>Du</label>
                <input v-model="zeltyBackfillFrom" type="date" />
              </div>
              <div class="field-group">
                <label>Au</label>
                <input v-model="zeltyBackfillTo" type="date" />
              </div>
            </div>
            <button
              class="btn-sync"
              :disabled="zeltyBackfillStatus === 'running'"
              @click="startBackfill"
            >
              {{ zeltyBackfillStatus === 'running' ? 'Import en cours...' : 'Lancer l\'import' }}
            </button>
          </div>
          <p v-if="zeltyBackfillMsg" class="backfill-msg" :class="zeltyBackfillStatus">
            {{ zeltyBackfillMsg }}
          </p>
        </div>

        <!-- Photo sync section -->
        <div class="zelty-section">
          <h3 class="section-title">Synchronisation photos produits</h3>
          <p class="section-desc">
            Récupère les photos des produits depuis Zelty et les associe aux recettes liées (via zelty_product_id).
            Par défaut, seules les recettes sans photo sont mises à jour.
          </p>
          <div class="backfill-form">
            <label class="checkbox-inline">
              <input type="checkbox" v-model="zeltyPhotoForce" />
              Écraser les photos existantes
            </label>
            <button
              class="btn-sync"
              :disabled="zeltyPhotoStatus === 'running'"
              @click="startPhotoSync"
            >
              {{ zeltyPhotoStatus === 'running' ? 'Sync en cours...' : 'Synchroniser les photos' }}
            </button>
          </div>
          <p v-if="zeltyPhotoMsg" class="backfill-msg" :class="zeltyPhotoStatus">
            {{ zeltyPhotoMsg }}
          </p>
        </div>

        <!-- Cron history -->
        <div class="zelty-section" v-if="cronLogs.length > 0">
          <h3 class="section-title">Historique des synchronisations</h3>
          <div class="cron-table-wrap">
            <table class="cron-table">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Job</th>
                  <th>Statut</th>
                  <th>Durée</th>
                  <th>Erreur</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="log in cronLogs" :key="log.id">
                  <td>{{ formatDate(log.started_at) }}</td>
                  <td>{{ log.job_name }}</td>
                  <td>
                    <span class="status-badge" :class="log.status">
                      {{ log.status === 'success' ? '✓' : log.status === 'error' ? '✗' : '⏳' }}
                      {{ log.status }}
                    </span>
                  </td>
                  <td>{{ formatDuration(log.duration_ms) }}</td>
                  <td class="error-cell">{{ log.error_message || '' }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<style scoped>
.parametres-page {
  max-width: 800px;
  margin: 0 auto;
}

.page-title {
  font-family: var(--font-brand, inherit);
  font-size: 24px;
  font-weight: 700;
  margin-bottom: 20px;
}

.loading, .empty {
  color: var(--text-secondary);
  padding: 20px 0;
}

.tabs {
  display: flex;
  gap: 4px;
  margin-bottom: 20px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.tab {
  padding: 12px 20px;
  border: none;
  background: var(--bg-surface);
  border-radius: var(--radius-md) var(--radius-md) 0 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  white-space: nowrap;
  min-height: 48px;
}

.tab.active {
  background: var(--bg-surface);
  color: var(--color-primary);
  box-shadow: inset 0 -3px 0 var(--color-primary);
}

.tab-content {
  background: var(--bg-surface);
  border-radius: 0 var(--radius-md) var(--radius-md) var(--radius-md);
  padding: 24px;
}

.settings-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.field-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-group label {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

.field-group input {
  height: 48px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 14px;
  font-size: 18px;
  background: var(--bg-main);
}

.field-group input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.hint {
  font-size: 13px;
  color: var(--text-tertiary);
}

.actions {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 8px;
}

.btn-save {
  padding: 12px 28px;
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-sm);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  min-height: 48px;
}

.btn-save:disabled {
  opacity: 0.6;
}

.save-msg {
  font-size: 14px;
  color: var(--color-success);
}

.save-msg.error {
  color: var(--color-danger);
}

/* Zones */
.zones-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 16px;
}

.zone-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  background: var(--bg-main);
  border-radius: var(--radius-sm);
}

.zone-name {
  font-size: 16px;
  font-weight: 500;
}

.btn-delete {
  padding: 8px 16px;
  border: 1px solid var(--color-danger);
  background: transparent;
  color: var(--color-danger);
  border-radius: var(--radius-sm);
  font-size: 14px;
  cursor: pointer;
  min-height: 40px;
}

.add-zone {
  display: flex;
  gap: 8px;
}

.add-zone input {
  flex: 1;
  height: 48px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 14px;
  font-size: 16px;
}

.add-zone input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.btn-add {
  padding: 0 24px;
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-sm);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  min-height: 48px;
}

/* Users */
.users-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.user-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 12px 16px;
  background: var(--bg-main);
  border-radius: var(--radius-sm);
}

.user-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.user-name {
  font-size: 16px;
  font-weight: 600;
}

.user-email {
  font-size: 14px;
  color: var(--text-secondary);
}

.user-row select {
  height: 44px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 12px;
  font-size: 16px;
  background: white;
}

/* Calendriers */
.section-desc {
  color: var(--text-secondary);
  margin-bottom: 16px;
}

.btn-sync {
  padding: 12px 28px;
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-sm);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  min-height: 48px;
}

.sync-status {
  margin-top: 12px;
  font-size: 14px;
  color: var(--color-success);
}

/* Zelty */
.zelty-status-cards {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
}

.status-card {
  flex: 1;
  background: var(--bg-main);
  border-radius: var(--radius-sm);
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.status-label {
  font-size: 13px;
  color: var(--text-tertiary);
  font-weight: 500;
}

.status-value {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
}

.status-ok {
  color: var(--color-success);
}

.status-none {
  color: var(--text-tertiary);
}

.zelty-section {
  margin-top: 24px;
}

.section-title {
  font-size: 18px;
  font-weight: 700;
  margin-bottom: 8px;
}

.backfill-form {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-top: 12px;
}

.backfill-dates {
  display: flex;
  gap: 12px;
}

.backfill-dates .field-group {
  flex: 1;
}

.backfill-dates input {
  width: 100%;
  height: 48px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 14px;
  font-size: 16px;
  background: var(--bg-main);
}

.backfill-dates input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.backfill-msg {
  margin-top: 12px;
  font-size: 14px;
  padding: 12px;
  border-radius: var(--radius-sm);
}

.backfill-msg.success {
  color: var(--color-success);
  background: rgba(34, 197, 94, 0.08);
}

.backfill-msg.error {
  color: var(--color-danger);
  background: rgba(239, 68, 68, 0.08);
}

.backfill-msg.running {
  color: var(--color-primary);
  background: rgba(232, 93, 44, 0.08);
}

.checkbox-inline {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  cursor: pointer;
  color: var(--text-secondary);
}

.checkbox-inline input[type="checkbox"] {
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.cron-table-wrap {
  overflow-x: auto;
  margin-top: 12px;
}

.cron-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.cron-table th {
  text-align: left;
  padding: 10px 12px;
  font-weight: 600;
  color: var(--text-secondary);
  border-bottom: 2px solid var(--border);
  white-space: nowrap;
}

.cron-table td {
  padding: 10px 12px;
  border-bottom: 1px solid var(--border);
  white-space: nowrap;
}

.cron-table tr:last-child td {
  border-bottom: none;
}

.status-badge {
  font-size: 13px;
  font-weight: 600;
  padding: 2px 8px;
  border-radius: 10px;
}

.status-badge.success {
  color: var(--color-success);
  background: rgba(34, 197, 94, 0.1);
}

.status-badge.error {
  color: var(--color-danger);
  background: rgba(239, 68, 68, 0.1);
}

.status-badge.running {
  color: var(--color-primary);
  background: rgba(232, 93, 44, 0.1);
}

.error-cell {
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  color: var(--color-danger);
  font-size: 13px;
}
</style>
