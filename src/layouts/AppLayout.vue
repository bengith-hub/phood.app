<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useOffline } from '@/composables/useOffline'
import { useNotificationsStore } from '@/stores/notifications'

const route = useRoute()
const router = useRouter()
const { profile, signOut } = useAuth()
const { isOnline } = useOffline()
const notificationsStore = useNotificationsStore()

const navItems = computed(() => [
  { name: 'Dashboard', icon: '📊', route: '/' },
  { name: 'Commandes', icon: '📦', route: '/commandes' },
  { name: 'Réception', icon: '📋', route: '/reception' },
  { name: 'Recettes', icon: '🍜', route: '/recettes' },
  { name: 'Plus', icon: '⋯', route: '/fournisseurs' },
])

function isActive(path: string) {
  if (path === '/') return route.path === '/'
  return route.path.startsWith(path)
}

async function handleSignOut() {
  await signOut()
  router.push('/login')
}
</script>

<template>
  <div class="app-layout">
    <!-- Top bar -->
    <header class="top-bar">
      <div class="top-bar-left">
        <span class="brand">Phood</span>
        <span v-if="!isOnline" class="offline-badge">Hors-ligne</span>
      </div>
      <div class="top-bar-right">
        <span class="user-name">{{ profile?.nom }}</span>
        <button class="btn-icon notif-btn" title="Notifications">
          🔔
          <span v-if="notificationsStore.unreadCount > 0" class="notif-count">
            {{ notificationsStore.unreadCount > 99 ? '99+' : notificationsStore.unreadCount }}
          </span>
        </button>
        <button class="btn-icon" @click="handleSignOut" title="Déconnexion">⏻</button>
      </div>
    </header>

    <!-- Main content -->
    <main class="main-content">
      <router-view />
    </main>

    <!-- Bottom navigation (iPad-first) -->
    <nav class="bottom-nav">
      <router-link
        v-for="item in navItems"
        :key="item.route"
        :to="item.route"
        class="nav-item"
        :class="{ active: isActive(item.route) }"
      >
        <span class="nav-icon">{{ item.icon }}</span>
        <span class="nav-label">{{ item.name }}</span>
      </router-link>
    </nav>
  </div>
</template>

<style scoped>
.app-layout {
  display: flex;
  flex-direction: column;
  height: 100dvh;
  background: var(--bg-main);
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 20px;
  background: var(--bg-surface);
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}

.top-bar-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.brand {
  font-size: 22px;
  font-weight: 700;
  color: var(--color-primary);
}

.offline-badge {
  background: var(--color-warning);
  color: white;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 600;
}

.top-bar-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-name {
  font-size: 16px;
  color: var(--text-secondary);
}

.btn-icon {
  width: 48px;
  height: 48px;
  border: none;
  background: transparent;
  font-size: 22px;
  border-radius: 12px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-icon:active {
  background: var(--bg-hover);
}

.notif-btn { position: relative; }
.notif-count {
  position: absolute;
  top: 4px;
  right: 4px;
  background: #ef4444;
  color: white;
  font-size: 11px;
  font-weight: 700;
  min-width: 18px;
  height: 18px;
  border-radius: 9px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 4px;
}

.main-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  -webkit-overflow-scrolling: touch;
}

.bottom-nav {
  display: flex;
  justify-content: space-around;
  background: var(--bg-surface);
  border-top: 1px solid var(--border);
  padding: 8px 0 env(safe-area-inset-bottom, 8px);
  flex-shrink: 0;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  padding: 8px 16px;
  text-decoration: none;
  color: var(--text-tertiary);
  border-radius: 12px;
  min-width: 72px;
  transition: color 0.15s;
}

.nav-item.active {
  color: var(--color-primary);
}

.nav-icon {
  font-size: 24px;
}

.nav-label {
  font-size: 12px;
  font-weight: 600;
}
</style>
