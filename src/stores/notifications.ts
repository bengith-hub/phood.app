import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
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
        const { data, error } = await supabase
          .from('notifications')
          .select('*')
          .order('created_at', { ascending: false })
          .limit(100)
        if (error) throw error
        notifications.value = data as Notification[]
        await db.notifications.clear()
        await db.notifications.bulkPut(data as Notification[])
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
    await supabase.from('notifications').update({ lue: true }).eq('id', id)
    const n = notifications.value.find(n => n.id === id)
    if (n) n.lue = true
  }

  async function markAllAsRead() {
    const ids = unread.value.map(n => n.id)
    if (ids.length === 0) return
    await supabase.from('notifications').update({ lue: true }).in('id', ids)
    notifications.value.forEach(n => { n.lue = true })
  }

  return { notifications, loading, unread, unreadCount, fetchAll, markAsRead, markAllAsRead }
})
