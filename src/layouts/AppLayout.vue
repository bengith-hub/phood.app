<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useOffline } from '@/composables/useOffline'
import { useNotificationsStore } from '@/stores/notifications'
import { getPendingCount, flushQueue } from '@/lib/sync-queue'
import NotificationPanel from '@/components/NotificationPanel.vue'

const route = useRoute()
const router = useRouter()
const { profile, signOut } = useAuth()
const { isOnline } = useOffline()
const notificationsStore = useNotificationsStore()

// Offline sync queue indicator
const pendingMutations = ref(0)
const isFlushing = ref(false)
let pendingInterval: ReturnType<typeof setInterval> | null = null

async function refreshPendingCount() {
  pendingMutations.value = await getPendingCount()
}

async function handleFlush() {
  if (isFlushing.value || !navigator.onLine) return
  isFlushing.value = true
  try {
    await flushQueue()
    await refreshPendingCount()
  } finally {
    isFlushing.value = false
  }
}

onMounted(() => {
  refreshPendingCount()
  pendingInterval = setInterval(refreshPendingCount, 5000)
})

onUnmounted(() => {
  if (pendingInterval) clearInterval(pendingInterval)
})

const showNotifPanel = ref(false)
const showPlusMenu = ref(false)

// SVG icon paths (24x24 viewBox, stroke-based)
const icons = {
  dashboard: '<path d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-4 0a1 1 0 01-1-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 01-1 1h-2"/>',
  commandes: '<path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01m-.01 4h.01"/>',
  reception: '<path d="M5 8h14M5 8a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v1a2 2 0 01-2 2M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4"/>',
  recettes: '<path d="M12 6.5c0-2.5-2-3.5-4-3.5s-4 1-4 3.5c0 2 1.5 3 3 3.5M12 6.5c0-2.5 2-3.5 4-3.5s4 1 4 3.5c0 2-1.5 3-3 3.5M12 6.5V21m-5-5h10"/>',
  plus: '<circle cx="5" cy="12" r="1.5"/><circle cx="12" cy="12" r="1.5"/><circle cx="19" cy="12" r="1.5"/>',
  fournisseurs: '<path d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0H5m14 0h2m-16 0H3m4-8h2m4 0h2m-8 4h2m4 0h2m-8-8h2m4 0h2"/>',
  stocks: '<path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>',
  coutMatiere: '<path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/>',
  inventaire: '<path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>',
  mercuriale: '<path d="M4 6h16M4 10h16M4 14h16M4 18h16"/><path d="M8 6v12"/>',
  allergenes: '<path d="M12 9v2m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>',
  previsions: '<path d="M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z"/>',
  factures: '<path d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l3.5-2 3.5 2 3.5-2 3.5 2z"/>',
  reporting: '<path d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>',
  parametres: '<path d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.573-1.066z"/><circle cx="12" cy="12" r="3"/>',
  bell: '<path d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>',
  logout: '<path d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/>',
}

const navItems = computed(() => [
  { name: 'Dashboard', icon: icons.dashboard, route: '/' },
  { name: 'Commandes', icon: icons.commandes, route: '/commandes' },
  { name: 'Réception', icon: icons.reception, route: '/reception' },
  { name: 'Recettes', icon: icons.recettes, route: '/recettes' },
  { name: 'Plus', icon: icons.plus, route: '' },
])

const plusMenuItems = computed(() => [
  { name: 'Fournisseurs', icon: icons.fournisseurs, route: '/fournisseurs' },
  { name: 'Produits fourn.', icon: icons.mercuriale, route: '/mercuriale' },
  { name: 'Avoirs', icon: icons.coutMatiere, route: '/avoirs' },
  { name: 'Stocks', icon: icons.stocks, route: '/stocks' },
  { name: 'Coût matière', icon: icons.coutMatiere, route: '/recettes/cout-matiere' },
  { name: 'Inventaire', icon: icons.inventaire, route: '/inventaire' },
  { name: 'Prévisions', icon: icons.previsions, route: '/previsions' },
  { name: 'Factures', icon: icons.factures, route: '/factures' },
  { name: 'Reporting', icon: icons.reporting, route: '/reporting' },
  { name: 'Allergènes', icon: icons.allergenes, route: '/recettes/allergenes' },
  { name: 'Paramètres', icon: icons.parametres, route: '/parametres' },
])

function isActive(path: string) {
  if (path === '/') return route.path === '/'
  if (path === '') return false
  return route.path.startsWith(path)
}

function isPlusActive() {
  return plusMenuItems.value.some(item => route.path.startsWith(item.route))
}

function toggleNotifPanel() {
  showNotifPanel.value = !showNotifPanel.value
  showPlusMenu.value = false
}

function handleNavClick(item: { name: string; route: string }) {
  if (item.name === 'Plus') {
    showPlusMenu.value = !showPlusMenu.value
    showNotifPanel.value = false
    return
  }
  showPlusMenu.value = false
  router.push(item.route).catch((err: unknown) => console.warn('Nav error:', err))
}

function handlePlusItemClick(item: { route: string }) {
  showPlusMenu.value = false
  router.push(item.route).catch((err: unknown) => console.warn('Nav error:', err))
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
        <img src="/assets/logos/phood-logo-compact.png" alt="Phood" class="brand-logo" />
        <span v-if="!isOnline" class="offline-badge">Hors-ligne</span>
        <button
          v-if="pendingMutations > 0"
          class="sync-badge"
          :class="{ flushing: isFlushing }"
          :disabled="isFlushing || !isOnline"
          @click="handleFlush"
          :title="isOnline ? 'Synchroniser maintenant' : 'En attente de connexion'"
        >
          {{ isFlushing ? 'Sync...' : `${pendingMutations} en attente` }}
        </button>
      </div>
      <div class="top-bar-right">
        <span class="user-name">{{ profile?.nom }}</span>
        <div class="notif-wrapper">
          <button
            class="btn-icon notif-btn"
            title="Notifications"
            @click.stop="toggleNotifPanel"
          >
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="icons.bell" />
            <span v-if="notificationsStore.unreadCount > 0" class="notif-count">
              {{ notificationsStore.unreadCount > 99 ? '99+' : notificationsStore.unreadCount }}
            </span>
          </button>
          <NotificationPanel
            v-if="showNotifPanel"
            @close="showNotifPanel = false"
          />
        </div>
        <button class="btn-icon" @click="handleSignOut" title="Déconnexion">
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="icons.logout" />
        </button>
      </div>
    </header>

    <!-- Main content -->
    <main class="main-content">
      <router-view />
    </main>

    <!-- Plus menu overlay -->
    <Teleport to="body">
      <Transition name="plus-menu">
        <div v-if="showPlusMenu" class="plus-overlay" @click="showPlusMenu = false">
          <div class="plus-menu" @click.stop>
            <div class="plus-menu-header">
              <span class="plus-menu-title">Plus</span>
              <button class="plus-menu-close" @click="showPlusMenu = false">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M18 6L6 18M6 6l12 12"/></svg>
              </button>
            </div>
            <div class="plus-menu-grid">
              <button
                v-for="item in plusMenuItems"
                :key="item.route"
                class="plus-menu-item"
                :class="{ active: route.path.startsWith(item.route) }"
                @click="handlePlusItemClick(item)"
              >
                <span class="plus-menu-icon">
                  <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round" v-html="item.icon" />
                </span>
                <span class="plus-menu-label">{{ item.name }}</span>
              </button>
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>

    <!-- Bottom navigation (iPad-first) -->
    <nav class="bottom-nav">
      <button
        v-for="item in navItems"
        :key="item.name"
        class="nav-item"
        :class="{ active: item.name === 'Plus' ? isPlusActive() || showPlusMenu : isActive(item.route) }"
        @click="handleNavClick(item)"
      >
        <span class="nav-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" v-html="item.icon" />
        </span>
        <span class="nav-label">{{ item.name }}</span>
      </button>
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

.brand-logo {
  height: 30px;
  width: auto;
  object-fit: contain;
}

.offline-badge {
  background: var(--color-warning);
  color: white;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 600;
}

.sync-badge {
  background: var(--color-info, #3b82f6);
  color: white;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 600;
  border: none;
  cursor: pointer;
}
.sync-badge:disabled {
  opacity: 0.6;
  cursor: default;
}
.sync-badge.flushing {
  animation: pulse-sync 1s infinite;
}
@keyframes pulse-sync {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
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

.notif-wrapper {
  position: relative;
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

/* Bottom nav */
.bottom-nav {
  display: flex;
  gap: 6px;
  background: var(--bg-surface);
  border-top: 1px solid var(--border);
  padding: 8px 8px env(safe-area-inset-bottom, 8px);
  flex-shrink: 0;
}

.nav-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 4px;
  padding: 10px 4px 12px;
  border: none;
  background: var(--bg-main);
  color: var(--text-tertiary);
  border-radius: 14px;
  cursor: pointer;
  transition: all 0.15s ease;
  text-decoration: none;
  font-family: inherit;
  position: relative;
  min-height: 64px;
}

.nav-item:active {
  transform: scale(0.95);
}

.nav-item.active {
  background: var(--color-primary);
  color: white;
  box-shadow: 0 2px 8px rgba(232, 93, 44, 0.3);
}

.nav-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 28px;
}

.nav-item.active .nav-icon svg {
  stroke: white;
}

.nav-label {
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 0.01em;
}

/* Plus menu */
.plus-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.35);
  z-index: 900;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}

.plus-menu {
  background: var(--bg-surface);
  border-radius: var(--radius-lg) var(--radius-lg) 0 0;
  width: 100%;
  max-width: 600px;
  padding: 0 20px 32px;
  padding-bottom: calc(32px + env(safe-area-inset-bottom, 0px));
}

.plus-menu-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 0 16px;
}

.plus-menu-title {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
}

.plus-menu-close {
  width: 40px;
  height: 40px;
  border: none;
  background: var(--bg-main);
  border-radius: 50%;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-secondary);
}

.plus-menu-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 12px;
}

.plus-menu-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 20px 12px;
  background: var(--bg-main);
  border: 2px solid transparent;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: border-color 0.15s;
}

.plus-menu-item.active {
  border-color: var(--color-primary);
  background: rgba(232, 93, 44, 0.06);
}

.plus-menu-item:active {
  border-color: var(--color-primary);
}

.plus-menu-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 48px;
  height: 48px;
  border-radius: 14px;
  background: var(--bg-surface);
  color: var(--color-primary);
}

.plus-menu-item.active .plus-menu-icon {
  background: rgba(232, 93, 44, 0.12);
}

.plus-menu-label {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  text-align: center;
}

/* Plus menu transition */
.plus-menu-enter-active,
.plus-menu-leave-active {
  transition: opacity 0.2s ease;
}
.plus-menu-enter-active .plus-menu,
.plus-menu-leave-active .plus-menu {
  transition: transform 0.25s ease;
}
.plus-menu-enter-from,
.plus-menu-leave-to {
  opacity: 0;
}
.plus-menu-enter-from .plus-menu,
.plus-menu-leave-to .plus-menu {
  transform: translateY(100%);
}
</style>
