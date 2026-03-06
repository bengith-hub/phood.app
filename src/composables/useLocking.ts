import { ref, onUnmounted } from 'vue'
import { supabase } from '@/lib/supabase'
import type { RealtimeChannel } from '@supabase/supabase-js'

interface LockInfo {
  user_id: string
  user_name: string
  editing_since: string
}

export function useLocking(resourceType: string) {
  const lockedBy = ref<LockInfo | null>(null)
  const isLocked = ref(false)
  const isMyLock = ref(false)
  let channel: RealtimeChannel | null = null
  let heartbeatTimer: ReturnType<typeof setInterval> | null = null

  async function acquireLock(resourceId: string, userId: string, userName: string) {
    const channelName = `${resourceType}:${resourceId}`
    channel = supabase.channel(channelName)

    return new Promise<boolean>((resolve) => {
      channel!
        .on('presence', { event: 'sync' }, () => {
          const state = channel!.presenceState()
          const presences = Object.values(state).flat() as unknown as LockInfo[]

          if (presences.length === 0) {
            lockedBy.value = null
            isLocked.value = false
            isMyLock.value = false
          } else {
            const firstPresence = presences[0]!
            lockedBy.value = firstPresence
            isLocked.value = true
            isMyLock.value = firstPresence.user_id === userId
          }
        })
        .subscribe(async (status) => {
          if (status === 'SUBSCRIBED') {
            await channel!.track({
              user_id: userId,
              user_name: userName,
              editing_since: new Date().toISOString(),
            })

            // Heartbeat every 30s
            heartbeatTimer = setInterval(async () => {
              await channel!.track({
                user_id: userId,
                user_name: userName,
                editing_since: new Date().toISOString(),
              })
            }, 30000)

            resolve(true)
          }
        })
    })
  }

  async function releaseLock() {
    if (heartbeatTimer) {
      clearInterval(heartbeatTimer)
      heartbeatTimer = null
    }
    if (channel) {
      await channel.untrack()
      await supabase.removeChannel(channel)
      channel = null
    }
    lockedBy.value = null
    isLocked.value = false
    isMyLock.value = false
  }

  onUnmounted(() => {
    releaseLock()
  })

  return {
    lockedBy,
    isLocked,
    isMyLock,
    acquireLock,
    releaseLock,
  }
}
