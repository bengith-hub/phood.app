import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import type { Notification } from '@/types/database'

export const useNotificationsStore = defineStore('notifications', () => {
  const notifications = ref<Notification[]>([])
  const loading = ref(false)

  const unread = computed(() => notifications.value.filter(n => !n.lue))
  const unreadCount = computed(() => unread.value.length)

  async function fetchAll() {
    loading.value = true
    try {
      if (navigator.onLine) {
        const data = await restCall<Notification[]>('GET', 'notifications?select=*&order=created_at.desc&limit=100')
        notifications.value = data
        await db.notifications.clear()
        await db.notifications.bulkPut(data)
      } else {
        notifications.value = await db.notifications.reverse().sortBy('created_at')
      }
    } catch {
      notifications.value = await db.notifications.reverse().sortBy('created_at')
    } finally {
      loading.value = false
    }
  }

  async function markAsRead(id: string) {
    await restCall('PATCH', `notifications?id=eq.${id}`, { lue: true })
    const n = notifications.value.find(n => n.id === id)
    if (n) n.lue = true
  }

  async function markAllAsRead() {
    const ids = unread.value.map(n => n.id)
    if (ids.length === 0) return
    await restCall('PATCH', `notifications?id=in.(${ids.join(',')})`, { lue: true })
    notifications.value.forEach(n => { n.lue = true })
  }

  return { notifications, loading, unread, unreadCount, fetchAll, markAsRead, markAllAsRead }
})
