<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import type { TacheTemplate, Station } from '@/types/database'
import { compressImage, blobToBase64 } from '@/lib/image-compress'

const props = defineProps<{
  template?: TacheTemplate | null
  show: boolean
}>()

const emit = defineEmits<{
  close: []
  save: [data: Partial<TacheTemplate>, photoFile?: File]
}>()

const JOURS = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']

const nom = ref('')
const description = ref('')
const station = ref<Station>('salle')
const joursSelectionnes = ref<number[]>([])
const ordre = ref(0)
const photoFile = ref<File | null>(null)
const photoPreview = ref<string | null>(null)

const isEditing = computed(() => !!props.template)

watch(() => props.show, (visible) => {
  if (visible && props.template) {
    nom.value = props.template.nom
    description.value = props.template.description || ''
    station.value = props.template.station
    joursSelectionnes.value = [...props.template.jours_semaine]
    ordre.value = props.template.ordre
    photoPreview.value = props.template.photo_reference_url
    photoFile.value = null
  } else if (visible) {
    nom.value = ''
    description.value = ''
    station.value = 'salle'
    joursSelectionnes.value = [1, 2, 3, 4, 5, 6] // Lun-Sam par défaut
    ordre.value = 0
    photoPreview.value = null
    photoFile.value = null
  }
})

function toggleJour(j: number) {
  const idx = joursSelectionnes.value.indexOf(j)
  if (idx >= 0) joursSelectionnes.value.splice(idx, 1)
  else joursSelectionnes.value.push(j)
}

function handlePhoto(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  photoFile.value = file
  photoPreview.value = URL.createObjectURL(file)
}

function removePhoto() {
  photoFile.value = null
  photoPreview.value = null
}

const canSave = computed(() => nom.value.trim().length > 0 && joursSelectionnes.value.length > 0)

function handleSave() {
  const data: Partial<TacheTemplate> = {
    nom: nom.value.trim(),
    description: description.value.trim() || null,
    station: station.value,
    jours_semaine: joursSelectionnes.value.sort((a, b) => a - b),
    ordre: ordre.value,
    actif: true,
  }
  emit('save', data, photoFile.value || undefined)
}
</script>

<template>
  <Teleport to="body">
    <div v-if="show" class="modal-overlay" @click.self="emit('close')">
      <div class="modal-content">
        <h2>{{ isEditing ? 'Modifier la tâche' : 'Nouvelle tâche récurrente' }}</h2>

        <!-- Nom -->
        <label class="field-label">Nom de la tâche *</label>
        <input
          v-model="nom"
          type="text"
          class="field-input"
          placeholder="Ex: Nettoyer les chaises bébé"
          autocomplete="off"
        >

        <!-- Description -->
        <label class="field-label">Description (optionnel)</label>
        <textarea
          v-model="description"
          class="field-input field-textarea"
          placeholder="Détail de la tâche..."
          rows="2"
        />

        <!-- Station -->
        <label class="field-label">Station *</label>
        <div class="station-toggle">
          <button
            :class="['station-btn', { active: station === 'salle' }]"
            @click="station = 'salle'"
          >Salle</button>
          <button
            :class="['station-btn', { active: station === 'cuisine' }]"
            @click="station = 'cuisine'"
          >Cuisine</button>
        </div>

        <!-- Jours de la semaine -->
        <label class="field-label">Jours *</label>
        <div class="jours-grid">
          <button
            v-for="(label, idx) in JOURS"
            :key="idx"
            :class="['jour-btn', { active: joursSelectionnes.includes(idx) }]"
            @click="toggleJour(idx)"
          >{{ label }}</button>
        </div>

        <!-- Photo référence -->
        <label class="field-label">Photo référence</label>
        <div v-if="photoPreview" class="photo-preview-container">
          <img :src="photoPreview" alt="Référence" class="photo-preview">
          <button class="photo-remove-btn" @click="removePhoto">Supprimer</button>
        </div>
        <label v-else class="photo-upload-btn">
          + Ajouter une photo
          <input type="file" accept="image/*" capture="environment" hidden @change="handlePhoto">
        </label>

        <!-- Ordre -->
        <label class="field-label">Ordre d'affichage</label>
        <input
          v-model.number="ordre"
          type="number"
          class="field-input"
          min="0"
          style="width: 100px;"
        >

        <!-- Actions -->
        <div class="modal-actions">
          <button class="btn-secondary" @click="emit('close')">Annuler</button>
          <button class="btn-primary" :disabled="!canSave" @click="handleSave">
            {{ isEditing ? 'Enregistrer' : 'Créer' }}
          </button>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<style scoped>
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 16px;
}
.modal-content {
  background: white;
  border-radius: var(--radius-lg, 16px);
  padding: 24px;
  width: 100%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
}
.modal-content h2 {
  margin: 0 0 20px;
  font-size: 22px;
  color: var(--text-primary, #111);
}
.field-label {
  display: block;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary, #4B5563);
  margin: 16px 0 6px;
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
.field-input:focus {
  outline: none;
  border-color: var(--color-primary, #E85D2C);
}
.field-textarea {
  resize: vertical;
  min-height: 56px;
}
.station-toggle {
  display: flex;
  gap: 8px;
}
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
.jours-grid {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}
.jour-btn {
  width: 52px;
  height: 44px;
  border: 2px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  background: white;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}
.jour-btn.active {
  border-color: var(--color-primary, #E85D2C);
  background: var(--color-primary, #E85D2C);
  color: white;
}
.photo-preview-container {
  display: flex;
  align-items: center;
  gap: 12px;
}
.photo-preview {
  width: 120px;
  height: 90px;
  object-fit: cover;
  border-radius: var(--radius-sm, 8px);
  border: 1px solid var(--border, #D1D5DB);
}
.photo-remove-btn {
  font-size: 14px;
  color: #dc2626;
  background: none;
  border: none;
  cursor: pointer;
  text-decoration: underline;
}
.photo-upload-btn {
  display: inline-flex;
  align-items: center;
  padding: 10px 16px;
  border: 2px dashed var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  cursor: pointer;
  font-size: 15px;
  color: var(--text-secondary, #4B5563);
}
.modal-actions {
  display: flex;
  gap: 12px;
  justify-content: flex-end;
  margin-top: 24px;
}
.btn-secondary {
  padding: 12px 24px;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  background: white;
  font-size: 16px;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}
.btn-primary {
  padding: 12px 24px;
  border: none;
  border-radius: var(--radius-sm, 8px);
  background: var(--color-primary, #E85D2C);
  color: white;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}
.btn-primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
</style>
