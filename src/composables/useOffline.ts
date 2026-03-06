import { ref, onMounted, onUnmounted } from 'vue'

const isOnline = ref(navigator.onLine)

export function useOffline() {
  let onHandler: (() => void) | null = null
  let offHandler: (() => void) | null = null

  onMounted(() => {
    onHandler = () => { isOnline.value = true }
    offHandler = () => { isOnline.value = false }
    window.addEventListener('online', onHandler)
    window.addEventListener('offline', offHandler)
  })

  onUnmounted(() => {
    if (onHandler) window.removeEventListener('online', onHandler)
    if (offHandler) window.removeEventListener('offline', offHandler)
  })

  return { isOnline }
}
