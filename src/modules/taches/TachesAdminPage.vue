<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useTachesStore } from '@/stores/taches'
import { useAuth } from '@/composables/useAuth'
import { compressImage, blobToBase64 } from '@/lib/image-compress'
import TacheTemplateModal from './TacheTemplateModal.vue'
import type { TacheTemplate, Station } from '@/types/database'

const store = useTachesStore()
const { profile } = useAuth()

const JOURS_SHORT = ['D', 'L', 'M', 'M', 'J', 'V', 'S']

// --- Templates tab ---
const showModal = ref(false)
const editingTemplate = ref<TacheTemplate | null>(null)
const activeTab = ref<'templates' | 'prioritaire' | 'aujourdhui'>('templates')
const filterStation = ref<Station | 'all'>('all')

const filteredTemplates = computed(() => {
  let list = store.templates.filter(t => !t.priorite)
  if (filterStation.value !== 'all') {
    list = list.filter(t => t.station === filterStation.value)
  }
  return list.sort((a, b) => {
    if (a.station !== b.station) return a.station.localeCompare(b.station)
    return a.ordre - b.ordre
  })
})

function openNewTemplate() {
  editingTemplate.value = null
  showModal.value = true
}

function openEditTemplate(t: TacheTemplate) {
  editingTemplate.value = t
  showModal.value = true
}

async function handleSaveTemplate(data: Partial<TacheTemplate>, photoFile?: File) {
  // Upload photo if provided
  if (photoFile) {
    const compressed = await compressImage(photoFile, 2048, 0.75)
    const base64 = await blobToBase64(compressed)
    const resp = await fetch('/.netlify/functions/upload-photo', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        image_base64: base64,
        bucket: 'taches-photos',
        path: `reference/${editingTemplate.value?.id || crypto.randomUUID()}_${Date.now()}.jpg`,
      }),
    })
    if (resp.ok) {
      const result = await resp.json()
      data.photo_reference_url = result.url
    }
  }

  if (editingTemplate.value) {
    await store.updateTemplate(editingTemplate.value.id, data)
  } else {
    data.created_by = profile.value?.id
    await store.createTemplate(data)
  }

  showModal.value = false
}

async function handleDeleteTemplate(t: TacheTemplate) {
  if (!confirm(`Supprimer la tâche "${t.nom}" ?`)) return
  await store.deleteTemplate(t.id)
}

async function toggleActif(t: TacheTemplate) {
  await store.updateTemplate(t.id, { actif: !t.actif })
}

// --- Priority task tab ---
const prioNom = ref('')
const prioDescription = ref('')
const prioStation = ref<Station>('salle')
const prioPhotoFile = ref<File | null>(null)
const prioPhotoPreview = ref<string | null>(null)
const prioSending = ref(false)
const prioMsg = ref('')

function handlePrioPhoto(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  prioPhotoFile.value = file
  prioPhotoPreview.value = URL.createObjectURL(file)
}

async function sendPriorityTask() {
  if (!prioNom.value.trim() || !profile.value) return
  prioSending.value = true
  prioMsg.value = ''

  try {
    let photoUrl: string | null = null
    if (prioPhotoFile.value) {
      const compressed = await compressImage(prioPhotoFile.value, 2048, 0.75)
      const base64 = await blobToBase64(compressed)
      const resp = await fetch('/.netlify/functions/upload-photo', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          image_base64: base64,
          bucket: 'taches-photos',
          path: `reference/prio_${Date.now()}.jpg`,
        }),
      })
      if (resp.ok) {
        const result = await resp.json()
        photoUrl = result.url
      }
    }

    await store.pushPriorityTask(
      prioNom.value.trim(),
      prioDescription.value.trim() || null,
      prioStation.value,
      photoUrl,
      profile.value.id
    )

    prioMsg.value = 'Tâche envoyée !'
    prioNom.value = ''
    prioDescription.value = ''
    prioPhotoFile.value = null
    prioPhotoPreview.value = null
    setTimeout(() => { prioMsg.value = '' }, 3000)
  } catch (err: any) {
    prioMsg.value = `Erreur : ${err.message}`
  } finally {
    prioSending.value = false
  }
}

// --- Today tab ---
const todaySalle = store.byStation('salle')
const todayCuisine = store.byStation('cuisine')

onMounted(async () => {
  await Promise.all([store.fetchTemplates(), store.fetchTodayInstances()])
})
</script>

<template>
  <div class="taches-admin-page">
    <h1>Tâches équipe</h1>

    <!-- Tabs -->
    <div class="tabs">
      <button :class="['tab', { active: activeTab === 'templates' }]" @click="activeTab = 'templates'">
        Récurrentes
      </button>
      <button :class="['tab', { active: activeTab === 'prioritaire' }]" @click="activeTab = 'prioritaire'">
        Prioritaire
      </button>
      <button :class="['tab', { active: activeTab === 'aujourdhui' }]" @click="activeTab = 'aujourdhui'">
        Aujourd'hui
      </button>
    </div>

    <!-- ═══ Templates récurrents ═══ -->
    <div v-if="activeTab === 'templates'" class="tab-content">
      <div class="toolbar">
        <div class="filter-btns">
          <button :class="['filter-btn', { active: filterStation === 'all' }]" @click="filterStation = 'all'">Toutes</button>
          <button :class="['filter-btn', { active: filterStation === 'salle' }]" @click="filterStation = 'salle'">Salle</button>
          <button :class="['filter-btn', { active: filterStation === 'cuisine' }]" @click="filterStation = 'cuisine'">Cuisine</button>
        </div>
        <button class="btn-add" @click="openNewTemplate">+ Nouvelle tâche</button>
      </div>

      <div v-if="filteredTemplates.length === 0" class="empty-state">
        Aucune tâche récurrente configurée.
      </div>

      <div v-else class="template-list">
        <div
          v-for="t in filteredTemplates"
          :key="t.id"
          :class="['template-card', { inactive: !t.actif }]"
        >
          <div class="template-top-row">
            <img v-if="t.photo_reference_url" :src="t.photo_reference_url" class="template-photo" alt="">
            <div class="template-info">
              <div class="template-header">
                <span :class="['station-badge', t.station]">{{ t.station }}</span>
                <span class="template-nom">{{ t.nom }}</span>
                <span v-if="!t.actif" class="inactive-badge">Inactif</span>
              </div>
              <p v-if="t.description" class="template-desc">{{ t.description }}</p>
              <div class="template-jours">
                <span
                  v-for="(label, idx) in JOURS_SHORT"
                  :key="idx"
                  :class="['jour-chip', { active: t.jours_semaine.includes(idx) }]"
                >{{ label }}</span>
              </div>
            </div>
          </div>
          <div class="template-actions">
            <button class="action-btn" @click="openEditTemplate(t)" title="Modifier">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 00-2 2v14a2 2 0 002 2h14a2 2 0 002-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 013 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
            </button>
            <button class="action-btn" @click="toggleActif(t)" :title="t.actif ? 'Désactiver' : 'Activer'">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" :stroke="t.actif ? '#16a34a' : '#9ca3af'" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
            <button class="action-btn danger" @click="handleDeleteTemplate(t)" title="Supprimer">
              <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M19 6v14a2 2 0 01-2 2H7a2 2 0 01-2-2V6m3 0V4a2 2 0 012-2h4a2 2 0 012 2v2"/></svg>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- ═══ Tâche prioritaire ═══ -->
    <div v-if="activeTab === 'prioritaire'" class="tab-content">
      <div class="prio-form">
        <h3>Envoyer une tâche prioritaire</h3>
        <p class="prio-subtitle">Apparaît immédiatement en haut de la liste sur la tablette.</p>

        <label class="field-label">Nom *</label>
        <input v-model="prioNom" type="text" class="field-input" placeholder="Ex: Nettoyer le congélateur">

        <label class="field-label">Description</label>
        <textarea v-model="prioDescription" class="field-input" rows="2" placeholder="Détails..." />

        <label class="field-label">Station</label>
        <div class="station-toggle">
          <button :class="['station-btn', { active: prioStation === 'salle' }]" @click="prioStation = 'salle'">Salle</button>
          <button :class="['station-btn', { active: prioStation === 'cuisine' }]" @click="prioStation = 'cuisine'">Cuisine</button>
        </div>

        <label class="field-label">Photo (montrer où/quoi)</label>
        <div v-if="prioPhotoPreview" class="prio-photo-container">
          <img :src="prioPhotoPreview" class="prio-photo">
          <button class="photo-remove" @click="prioPhotoFile = null; prioPhotoPreview = null">Supprimer</button>
        </div>
        <label v-else class="photo-upload-btn">
          + Ajouter une photo
          <input type="file" accept="image/*" capture="environment" hidden @change="handlePrioPhoto">
        </label>

        <button
          class="btn-send"
          :disabled="!prioNom.trim() || prioSending"
          @click="sendPriorityTask"
        >
          {{ prioSending ? 'Envoi...' : 'Envoyer maintenant' }}
        </button>

        <p v-if="prioMsg" :class="['prio-msg', { success: prioMsg.startsWith('Tâche') }]">{{ prioMsg }}</p>
      </div>
    </div>

    <!-- ═══ Aujourd'hui ═══ -->
    <div v-if="activeTab === 'aujourdhui'" class="tab-content">
      <div v-for="[station, tasks] of [['Salle', todaySalle], ['Cuisine', todayCuisine]]" :key="station as string">
        <h3 v-if="(tasks as any).value?.length > 0">{{ station }}</h3>
        <div v-for="task in (tasks as any).value" :key="task.id" class="today-task">
          <span :class="['status-dot', task.statut]" />
          <span class="today-nom">{{ task.nom }}</span>
          <span v-if="task.priorite" class="prio-badge">PRIO</span>
          <span :class="['status-label', task.statut]">
            {{ task.statut === 'fait' ? 'Fait' : task.statut === 'non_fait' ? 'Non fait' : 'En attente' }}
          </span>
        </div>
        <p v-if="(tasks as any).value?.length === 0" class="empty-state">Aucune tâche {{ (station as string).toLowerCase() }} aujourd'hui.</p>
      </div>
    </div>

    <!-- Modal -->
    <TacheTemplateModal
      :show="showModal"
      :template="editingTemplate"
      @close="showModal = false"
      @save="handleSaveTemplate"
    />
  </div>
</template>

<style scoped>
.taches-admin-page {
  padding: 16px;
  max-width: 800px;
  margin: 0 auto;
}
.taches-admin-page h1 {
  font-size: 26px;
  margin: 0 0 16px;
  color: var(--text-primary, #111);
}
/* Tabs */
.tabs {
  display: flex;
  gap: 4px;
  border-bottom: 2px solid var(--border, #D1D5DB);
  margin-bottom: 20px;
}
.tab {
  padding: 10px 20px;
  border: none;
  background: none;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-tertiary, #6B7280);
  cursor: pointer;
  border-bottom: 3px solid transparent;
  margin-bottom: -2px;
}
.tab.active {
  color: var(--color-primary, #E85D2C);
  border-bottom-color: var(--color-primary, #E85D2C);
}
/* Toolbar */
.toolbar {
  display: flex;
  flex-direction: column;
  gap: 12px;
  margin-bottom: 16px;
}
@media (min-width: 600px) {
  .toolbar {
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
  }
}
.filter-btns {
  display: flex;
  gap: 6px;
}
.filter-btn {
  padding: 10px 18px;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: 20px;
  background: white;
  font-size: 15px;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}
.filter-btn.active {
  border-color: var(--color-primary, #E85D2C);
  background: #fef3f0;
  color: var(--color-primary, #E85D2C);
}
.btn-add {
  padding: 14px 20px;
  border: none;
  border-radius: var(--radius-sm, 8px);
  background: var(--color-primary, #E85D2C);
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  width: 100%;
  min-height: 48px;
}
@media (min-width: 600px) {
  .btn-add { width: auto; }
}
/* Template list */
.template-list { display: flex; flex-direction: column; gap: 12px; }
.template-card {
  display: flex;
  flex-direction: column;
  gap: 12px;
  padding: 14px;
  background: var(--bg-surface, #fff);
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: var(--radius-md, 12px);
}
@media (min-width: 600px) {
  .template-card {
    flex-direction: row;
    align-items: center;
    gap: 14px;
  }
}
.template-card.inactive { opacity: 0.5; }
.template-top-row {
  display: flex;
  align-items: center;
  gap: 12px;
}
.template-photo {
  width: 72px;
  height: 54px;
  object-fit: cover;
  border-radius: var(--radius-sm, 8px);
  border: 1px solid var(--border, #D1D5DB);
  flex-shrink: 0;
}
.template-info { flex: 1; min-width: 0; }
.template-header {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.station-badge {
  display: inline-block;
  padding: 2px 10px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
}
.station-badge.salle { background: #dbeafe; color: #1d4ed8; }
.station-badge.cuisine { background: #fef3c7; color: #92400e; }
.template-nom { font-weight: 600; font-size: 16px; color: var(--text-primary, #111); }
.inactive-badge { font-size: 12px; color: #9ca3af; }
.template-desc { margin: 4px 0 0; font-size: 14px; color: var(--text-tertiary, #6B7280); }
.template-jours { display: flex; gap: 3px; margin-top: 6px; }
.jour-chip {
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 11px;
  font-weight: 600;
  background: #f3f4f6;
  color: #9ca3af;
}
.jour-chip.active { background: var(--color-primary, #E85D2C); color: white; }
.template-actions { display: flex; gap: 8px; }
.action-btn {
  width: 48px;
  height: 48px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  background: white;
  cursor: pointer;
}
.action-btn.danger:active { border-color: #dc2626; background: #fef2f2; }
.action-btn.danger svg { stroke: #dc2626; }
/* Priority form */
.prio-form { max-width: 500px; }
.prio-form h3 { margin: 0 0 4px; font-size: 20px; }
.prio-subtitle { margin: 0 0 16px; color: var(--text-tertiary, #6B7280); font-size: 14px; }
.field-label {
  display: block;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary, #4B5563);
  margin: 14px 0 6px;
}
.field-input {
  display: block;
  width: 100%;
  padding: 12px 14px;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  font-size: 16px;
  background: white;
  box-sizing: border-box;
}
.field-input:focus { outline: none; border-color: var(--color-primary, #E85D2C); }
.station-toggle { display: flex; gap: 8px; }
.station-btn {
  flex: 1;
  padding: 12px;
  border: 2px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  background: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}
.station-btn.active {
  border-color: var(--color-primary, #E85D2C);
  background: #fef3f0;
  color: var(--color-primary, #E85D2C);
}
.prio-photo-container { display: flex; align-items: center; gap: 12px; }
.prio-photo {
  width: 120px;
  height: 90px;
  object-fit: cover;
  border-radius: var(--radius-sm, 8px);
  border: 1px solid var(--border, #D1D5DB);
}
.photo-remove {
  font-size: 15px;
  color: #dc2626;
  background: #fef2f2;
  border: 1.5px solid #fca5a5;
  border-radius: var(--radius-sm, 8px);
  padding: 10px 16px;
  cursor: pointer;
  font-weight: 600;
}
.photo-upload-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px 20px;
  border: 2px dashed var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  cursor: pointer;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-secondary, #4B5563);
  min-height: 56px;
}
.btn-send {
  margin-top: 20px;
  padding: 16px 32px;
  border: none;
  border-radius: var(--radius-sm, 8px);
  background: #f97316;
  color: white;
  font-size: 18px;
  font-weight: 700;
  cursor: pointer;
  width: 100%;
  min-height: 56px;
}
.btn-send:disabled { opacity: 0.5; cursor: not-allowed; }
.prio-msg { margin-top: 12px; font-size: 15px; color: #dc2626; }
.prio-msg.success { color: #16a34a; }
/* Today */
.today-task {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 14px;
  border-bottom: 1px solid var(--border, #D1D5DB);
}
.status-dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  flex-shrink: 0;
}
.status-dot.fait { background: #16a34a; }
.status-dot.non_fait { background: #dc2626; }
.status-dot.en_attente { background: #d1d5db; }
.today-nom { flex: 1; font-size: 16px; font-weight: 500; }
.prio-badge {
  background: #f97316;
  color: white;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 11px;
  font-weight: 700;
}
.status-label { font-size: 14px; font-weight: 600; }
.status-label.fait { color: #16a34a; }
.status-label.non_fait { color: #dc2626; }
.status-label.en_attente { color: #9ca3af; }
.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: var(--text-tertiary, #6B7280);
  font-size: 16px;
}
</style>
