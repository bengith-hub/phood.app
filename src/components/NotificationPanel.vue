<script setup lang="ts">
import { computed, ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useNotificationsStore } from '@/stores/notifications'
import type { Notification, NotificationType } from '@/types/database'

const emit = defineEmits<{
  close: []
}>()

const router = useRouter()
const store = useNotificationsStore()
const panelRef = ref<HTMLElement | null>(null)

const TYPE_ICONS: Record<NotificationType, string> = {
  prix_ecart: '\uD83D\uDCB0',
  avoir_sans_reponse: '\uD83D\uDCE9',
  stock_bas: '\uD83D\uDCC9',
  zelty_non_associe: '\uD83D\uDD17',
  composition_manquante: '\u26A0\uFE0F',
  commande_rappel: '\uD83D\uDCE6',
}

const TYPE_ROUTES: Record<NotificationType, string> = {
  prix_ecart: '/recettes/cout-matiere',
  avoir_sans_reponse: '/reception',
  stock_bas: '/stocks',
  zelty_non_associe: '/recettes',
  composition_manquante: '/recettes',
  commande_rappel: '/commandes',
}

function timeAgo(dateStr: string): string {
  const now = Date.now()
  const date = new Date(dateStr).getTime()
  const diffMs = now - date
  const diffMin = Math.floor(diffMs / 60000)
  const diffH = Math.floor(diffMs / 3600000)
  const diffD = Math.floor(diffMs / 86400000)

  if (diffMin < 1) return "A l'instant"
  if (diffMin < 60) return `Il y a ${diffMin} min`
  if (diffH < 24) return `Il y a ${diffH}h`
  if (diffD < 7) return `Il y a ${diffD}j`
  return new Date(dateStr).toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })
}

function getDateGroup(dateStr: string): string {
  const now = new Date()
  const date = new Date(dateStr)
  const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
  const yesterday = new Date(today.getTime() - 86400000)
  const notifDate = new Date(date.getFullYear(), date.getMonth(), date.getDate())

  if (notifDate.getTime() === today.getTime()) return "Aujourd'hui"
  if (notifDate.getTime() === yesterday.getTime()) return 'Hier'
  return 'Plus ancien'
}

interface NotificationGroup {
  label: string
  items: Notification[]
}

const grouped = computed<NotificationGroup[]>(() => {
  const groups: Record<string, Notification[]> = {}
  const order = ["Aujourd'hui", 'Hier', 'Plus ancien']

  for (const n of store.notifications) {
    const label = getDateGroup(n.created_at)
    if (!groups[label]) groups[label] = []
    groups[label].push(n)
  }

  return order
    .filter(label => groups[label] && groups[label].length > 0)
    .map(label => ({ label, items: groups[label] }))
})

const isEmpty = computed(() => store.notifications.length === 0)

async function handleClickNotif(notif: Notification) {
  if (!notif.lue) {
    await store.markAsRead(notif.id)
  }
  const route = TYPE_ROUTES[notif.type] || '/'
  router.push(route)
  emit('close')
}

async function handleMarkAllRead() {
  await store.markAllAsRead()
}

function handleClickOutside(e: MouseEvent) {
  if (panelRef.value && !panelRef.value.contains(e.target as Node)) {
    emit('close')
  }
}

onMounted(() => {
  // Delay to avoid the opening click triggering close
  setTimeout(() => {
    document.addEventListener('click', handleClickOutside, true)
  }, 50)
})

onUnmounted(() => {
  document.removeEventListener('click', handleClickOutside, true)
})
</script>

<template>
  <div ref="panelRef" class="notif-panel">
    <div class="notif-header">
      <h3 class="notif-title">Notifications</h3>
      <button
        v-if="store.unreadCount > 0"
        class="btn-mark-all"
        @click="handleMarkAllRead"
      >
        Tout marquer comme lu
      </button>
    </div>

    <!-- Empty state -->
    <div v-if="isEmpty" class="notif-empty">
      <span class="notif-empty-icon">&#x1F514;</span>
      <p>Aucune notification</p>
    </div>

    <!-- Notification list -->
    <div v-else class="notif-list">
      <div v-for="group in grouped" :key="group.label" class="notif-group">
        <div class="notif-group-label">{{ group.label }}</div>
        <button
          v-for="notif in group.items"
          :key="notif.id"
          class="notif-item"
          :class="{ unread: !notif.lue }"
          @click="handleClickNotif(notif)"
        >
          <span class="notif-icon">{{ TYPE_ICONS[notif.type] }}</span>
          <div class="notif-body">
            <span class="notif-item-title">{{ notif.titre }}</span>
            <span class="notif-message">{{ notif.message }}</span>
          </div>
          <span class="notif-time">{{ timeAgo(notif.created_at) }}</span>
          <span v-if="!notif.lue" class="notif-dot" />
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.notif-panel {
  position: absolute;
  top: calc(100% + 8px);
  right: 0;
  width: min(420px, calc(100vw - 32px));
  max-height: 520px;
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15), 0 2px 8px rgba(0, 0, 0, 0.08);
  border: 1px solid var(--border);
  overflow: hidden;
  display: flex;
  flex-direction: column;
  z-index: 1000;
  animation: slideDown 0.2s ease-out;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.notif-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}

.notif-title {
  font-size: 18px;
  font-weight: 700;
  margin: 0;
  color: var(--text-primary);
}

.btn-mark-all {
  border: none;
  background: none;
  color: var(--color-primary);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  padding: 6px 10px;
  border-radius: var(--radius-sm);
}

.btn-mark-all:active {
  background: rgba(232, 93, 44, 0.08);
}

/* Empty */
.notif-empty {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 48px 20px;
  gap: 12px;
}

.notif-empty-icon {
  font-size: 40px;
  opacity: 0.3;
}

.notif-empty p {
  color: var(--text-tertiary);
  font-size: 16px;
  margin: 0;
}

/* List */
.notif-list {
  overflow-y: auto;
  flex: 1;
  -webkit-overflow-scrolling: touch;
}

.notif-group-label {
  font-size: 12px;
  font-weight: 700;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 12px 20px 6px;
}

.notif-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 14px 20px;
  width: 100%;
  border: none;
  background: transparent;
  text-align: left;
  cursor: pointer;
  transition: background 0.1s;
  position: relative;
}

.notif-item:active {
  background: var(--bg-main);
}

.notif-item.unread {
  background: rgba(232, 93, 44, 0.04);
}

.notif-icon {
  font-size: 24px;
  flex-shrink: 0;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-main);
  border-radius: var(--radius-sm);
}

.notif-body {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.notif-item-title {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
  display: block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.notif-message {
  font-size: 13px;
  color: var(--text-secondary);
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.35;
}

.notif-time {
  font-size: 12px;
  color: var(--text-tertiary);
  white-space: nowrap;
  flex-shrink: 0;
  padding-top: 2px;
}

.notif-dot {
  position: absolute;
  top: 18px;
  right: 12px;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--color-primary);
}
</style>
