<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useOffline } from '@/composables/useOffline'
import { useNotificationsStore } from '@/stores/notifications'
import NotificationPanel from '@/components/NotificationPanel.vue'

const route = useRoute()
const router = useRouter()
const { profile, signOut } = useAuth()
const { isOnline } = useOffline()
const notificationsStore = useNotificationsStore()

const showNotifPanel = ref(false)
const showPlusMenu = ref(false)

const navItems = computed(() => [
  { name: 'Dashboard', icon: '\uD83D\uDCCA', route: '/' },
  { name: 'Commandes', icon: '\uD83D\uDCE6', route: '/commandes' },
  { name: 'R\u00E9ception', icon: '\uD83D\uDCCB', route: '/reception' },
  { name: 'Recettes', icon: '\uD83C\uDF5C', route: '/recettes' },
  { name: 'Plus', icon: '\u22EF', route: '' },
])

const plusMenuItems = computed(() => [
  { name: 'Fournisseurs', icon: '\uD83C\uDFED', route: '/fournisseurs' },
  { name: 'Stocks', icon: '\uD83D\uDCE6', route: '/stocks' },
  { name: 'Co\u00FBt mati\u00E8re', icon: '\uD83D\uDCB0', route: '/recettes/cout-matiere' },
  { name: 'Inventaire', icon: '\uD83D\uDCDD', route: '/inventaire' },
  { name: 'Allerg\u00E8nes', icon: '\u26A0\uFE0F', route: '/recettes/allergenes' },
  { name: 'Param\u00E8tres', icon: '\u2699\uFE0F', route: '/parametres' },
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
  router.push(item.route)
}

function handlePlusItemClick(item: { route: string }) {
  showPlusMenu.value = false
  router.push(item.route)
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
      </div>
      <div class="top-bar-right">
        <span class="user-name">{{ profile?.nom }}</span>
        <div class="notif-wrapper">
          <button
            class="btn-icon notif-btn"
            title="Notifications"
            @click.stop="toggleNotifPanel"
          >
            &#x1F514;
            <span v-if="notificationsStore.unreadCount > 0" class="notif-count">
              {{ notificationsStore.unreadCount > 99 ? '99+' : notificationsStore.unreadCount }}
            </span>
          </button>
          <NotificationPanel
            v-if="showNotifPanel"
            @close="showNotifPanel = false"
          />
        </div>
        <button class="btn-icon" @click="handleSignOut" title="D\u00E9connexion">&#x23FB;</button>
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
              <button class="plus-menu-close" @click="showPlusMenu = false">&#x2715;</button>
            </div>
            <div class="plus-menu-grid">
              <button
                v-for="item in plusMenuItems"
                :key="item.route"
                class="plus-menu-item"
                :class="{ active: route.path.startsWith(item.route) }"
                @click="handlePlusItemClick(item)"
              >
                <span class="plus-menu-icon">{{ item.icon }}</span>
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
        <span class="nav-icon">{{ item.icon }}</span>
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
  border: none;
  background: transparent;
  color: var(--text-tertiary);
  border-radius: 12px;
  min-width: 72px;
  cursor: pointer;
  transition: color 0.15s;
  text-decoration: none;
  font-family: inherit;
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
  font-size: 28px;
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
