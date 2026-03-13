<script setup lang="ts">
import type { TacheInstance } from '@/types/database'

defineProps<{
  task: TacheInstance
}>()

const emit = defineEmits<{
  validate: [task: TacheInstance]
  reject: [task: TacheInstance]
  undo: [task: TacheInstance]
}>()
</script>

<template>
  <div class="kiosk-card" :class="{ done: task.statut === 'fait', rejected: task.statut === 'non_fait' }">
    <!-- Priority badge -->
    <div v-if="task.priorite" class="priority-badge">PRIORITAIRE</div>

    <!-- Reference photo -->
    <div class="photo-zone">
      <img
        v-if="task.photo_reference_url"
        :src="task.photo_reference_url"
        :alt="task.nom"
        class="ref-photo"
      >
      <div v-else class="no-photo">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
          <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
          <circle cx="8.5" cy="8.5" r="1.5"/>
          <path d="M21 15l-5-5L5 21"/>
        </svg>
      </div>

      <!-- Done overlay -->
      <div v-if="task.statut === 'fait'" class="done-overlay" @click="emit('undo', task)">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="20 6 9 17 4 12"/>
        </svg>
        <span class="undo-hint">Tap pour annuler</span>
      </div>

      <!-- Rejected overlay -->
      <div v-if="task.statut === 'non_fait'" class="rejected-overlay" @click="emit('undo', task)">
        <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
          <line x1="18" y1="6" x2="6" y2="18"/>
          <line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
        <span class="undo-hint">Tap pour annuler</span>
      </div>
    </div>

    <!-- Task info -->
    <div class="task-info">
      <h2 class="task-name">{{ task.nom }}</h2>
      <p v-if="task.description" class="task-desc">{{ task.description }}</p>
    </div>

    <!-- Action buttons (only when en_attente) -->
    <div v-if="task.statut === 'en_attente'" class="action-buttons">
      <button class="btn-fait" @click="emit('validate', task)">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
          <polyline points="20 6 9 17 4 12"/>
        </svg>
        FAIT
      </button>
      <button class="btn-non-fait" @click="emit('reject', task)">
        <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
          <line x1="18" y1="6" x2="6" y2="18"/>
          <line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
        NON FAIT
      </button>
    </div>
  </div>
</template>

<style scoped>
.kiosk-card {
  display: flex;
  flex-direction: column;
  height: 100%;
  background: white;
  position: relative;
}

.priority-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  z-index: 5;
  background: #E85D2C;
  color: white;
  font-size: 14px;
  font-weight: 700;
  padding: 6px 14px;
  border-radius: 20px;
  letter-spacing: 0.5px;
}

.photo-zone {
  position: relative;
  flex: 1;
  min-height: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f9fafb;
  overflow: hidden;
}

.ref-photo {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.no-photo {
  color: #d1d5db;
}

.done-overlay,
.rejected-overlay {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  cursor: pointer;
}

.done-overlay {
  background: rgba(22, 163, 74, 0.6);
}

.rejected-overlay {
  background: rgba(220, 38, 38, 0.6);
}

.undo-hint {
  color: white;
  font-size: 16px;
  font-weight: 600;
  opacity: 0.9;
}

.task-info {
  padding: 16px 20px 12px;
}

.task-name {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-primary, #111);
  margin: 0;
  line-height: 1.2;
}

.task-desc {
  font-size: 20px;
  color: var(--text-secondary, #4B5563);
  margin: 8px 0 0;
  line-height: 1.4;
}

.action-buttons {
  display: flex;
  gap: 16px;
  padding: 12px 20px 20px;
}

.btn-fait,
.btn-non-fait {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  height: 56px;
  border-radius: var(--radius-md, 12px);
  font-size: 20px;
  font-weight: 700;
  border: none;
  cursor: pointer;
  letter-spacing: 0.5px;
}

.btn-fait {
  background: #16a34a;
  color: white;
}

.btn-non-fait {
  background: #dc2626;
  color: white;
}

.btn-fait:active { background: #15803d; }
.btn-non-fait:active { background: #b91c1c; }
</style>
