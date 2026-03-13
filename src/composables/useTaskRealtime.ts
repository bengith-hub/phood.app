import { onMounted, onUnmounted, watch, type Ref } from 'vue'
import { supabase } from '@/lib/supabase'
import { useTachesStore } from '@/stores/taches'
import type { RealtimeChannel } from '@supabase/supabase-js'
import type { TacheInstance, Station } from '@/types/database'

function todayISO() {
  return new Date().toISOString().split('T')[0]
}

/**
 * Subscribe to Supabase Realtime postgres_changes on tache_instances.
 * Updates the taches store in real-time when tasks are created, validated, or deleted
 * on another device.
 *
 * @param station - Reactive ref: 'salle', 'cuisine', or 'all' (for roaming iPad)
 */
export function useTaskRealtime(station: Ref<Station | 'all'>) {
  const store = useTachesStore()
  let channel: RealtimeChannel | null = null

  function subscribe() {
    // Unsubscribe previous channel if exists
    if (channel) {
      supabase.removeChannel(channel)
      channel = null
    }

    channel = supabase
      .channel(`taches-realtime-${Date.now()}`)
      .on(
        'postgres_changes',
        {
          event: '*',
          schema: 'public',
          table: 'tache_instances',
          filter: `date=eq.${todayISO()}`,
        },
        (payload) => {
          const newRecord = payload.new as TacheInstance | null
          const oldRecord = payload.old as { id: string } | null

          // Filter by station if not 'all'
          if (station.value !== 'all' && newRecord && newRecord.station !== station.value) {
            return
          }

          store.handleRealtimeEvent(payload.eventType, newRecord, oldRecord)
        }
      )
      .subscribe((status) => {
        if (status === 'CHANNEL_ERROR' || status === 'TIMED_OUT') {
          console.warn(`[TaskRealtime] Channel ${status}, reconnecting in 3s...`)
          setTimeout(() => subscribe(), 3000)
        }
      })
  }

  onMounted(() => subscribe())
  onUnmounted(() => {
    if (channel) {
      supabase.removeChannel(channel)
      channel = null
    }
  })

  // Re-subscribe if station changes (roaming iPad switching)
  watch(station, () => subscribe())
}
