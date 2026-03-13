<script setup lang="ts">
import { ref } from 'vue'
import { compressImage, blobToBase64 } from '@/lib/image-compress'

const emit = defineEmits<{
  captured: [url: string]
  cancel: []
}>()

const props = defineProps<{
  instanceId: string
}>()

const uploading = ref(false)
const error = ref('')

async function handleCapture(e: Event) {
  const input = e.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  uploading.value = true
  error.value = ''

  try {
    // Compress image (same as ingredient photos)
    const compressed = await compressImage(file, 2048, 0.75)
    const base64 = await blobToBase64(compressed)

    // Upload via existing Netlify function
    const resp = await fetch('/.netlify/functions/upload-photo', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        image_base64: base64,
        bucket: 'taches-photos',
        path: `preuves/${props.instanceId}_${Date.now()}.jpg`,
      }),
    })

    if (!resp.ok) throw new Error('Upload échoué')
    const data = await resp.json()
    emit('captured', data.url)
  } catch (err: any) {
    error.value = err.message || 'Erreur lors de l\'upload'
  } finally {
    uploading.value = false
  }
}
</script>

<template>
  <div class="photo-capture">
    <p class="capture-title">Prendre une photo preuve</p>

    <label class="capture-btn" :class="{ disabled: uploading }">
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M23 19a2 2 0 01-2 2H3a2 2 0 01-2-2V8a2 2 0 012-2h4l2-3h6l2 3h4a2 2 0 012 2z"/>
        <circle cx="12" cy="13" r="4"/>
      </svg>
      <span v-if="!uploading">Ouvrir la caméra</span>
      <span v-else>Upload en cours...</span>
      <input
        type="file"
        accept="image/*"
        capture="environment"
        hidden
        :disabled="uploading"
        @change="handleCapture"
      >
    </label>

    <p v-if="error" class="capture-error">{{ error }}</p>

    <button class="capture-cancel" @click="emit('cancel')">Annuler</button>
  </div>
</template>

<style scoped>
.photo-capture {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 24px;
  gap: 16px;
}
.capture-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary, #111);
  margin: 0;
}
.capture-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 24px 40px;
  border: 3px dashed var(--color-primary, #E85D2C);
  border-radius: var(--radius-lg, 16px);
  background: #fef3f0;
  color: var(--color-primary, #E85D2C);
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
}
.capture-btn.disabled {
  opacity: 0.5;
  cursor: wait;
}
.capture-error {
  color: #dc2626;
  font-size: 14px;
  margin: 0;
}
.capture-cancel {
  padding: 12px 32px;
  border: 1.5px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  background: white;
  font-size: 16px;
  cursor: pointer;
  color: var(--text-secondary, #4B5563);
}
</style>
