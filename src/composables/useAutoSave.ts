import { ref, watch, onUnmounted, type Ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { db } from '@/lib/dexie'

export type SaveStatus = 'saved' | 'saving' | 'offline' | 'error'

export function useAutoSave<T extends Record<string, unknown>>(
  data: Ref<T>,
  options: {
    table: string
    id: Ref<string | null>
    dexieTable?: string
    intervalMs?: number
  }
) {
  const status = ref<SaveStatus>('saved')
  let timer: ReturnType<typeof setInterval> | null = null

  async function save() {
    if (!options.id.value || !data.value) {
      // No ID yet (new order before supplier selection) — not an error
      if (status.value === 'saving') status.value = 'saved'
      return
    }

    status.value = 'saving'

    // Always save to IndexedDB first
    try {
      const dexieTableName = options.dexieTable || options.table
      const dexieTable = (db as unknown as Record<string, unknown>)[dexieTableName]
      if (dexieTable && typeof (dexieTable as { put: Function }).put === 'function') {
        await (dexieTable as { put: Function }).put({
          ...data.value,
          id: options.id.value,
        })
      }
    } catch {
      // IndexedDB save failed, continue to try Supabase
    }

    // Then sync to Supabase if online
    if (navigator.onLine) {
      try {
        const { error } = await supabase
          .from(options.table)
          .upsert({ ...data.value, id: options.id.value })
        if (error) throw error
        status.value = 'saved'
      } catch {
        status.value = 'error'
      }
    } else {
      status.value = 'offline'
    }
  }

  // Auto-save every 5 seconds (configurable)
  timer = setInterval(save, options.intervalMs ?? 5000)

  // Also save on data change (debounced by the interval)
  watch(data, () => {
    if (status.value === 'saved') status.value = 'saving'
  }, { deep: true })

  onUnmounted(() => {
    if (timer) clearInterval(timer)
  })

  return { status, save }
}
