<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useCommandesStore } from '@/stores/commandes'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useIngredientsStore } from '@/stores/ingredients'
import { useStocksStore } from '@/stores/stocks'
import { useNotificationsStore } from '@/stores/notifications'
import { restCall } from '@/lib/rest-client'
import { weatherCodeToEmoji } from '@/stores/previsions'
import type { MeteoDaily } from '@/types/database'

const router = useRouter()
const { profile } = useAuth()
const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()
const ingredientsStore = useIngredientsStore()
const stocksStore = useStocksStore()
const notificationsStore = useNotificationsStore()

function toLocalDateStr(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}
const today = toLocalDateStr(new Date())
const meteoToday = ref<MeteoDaily | null>(null)

// CA yesterday for quick KPI
const caHier = ref<number | null>(null)

// Orders needing attention today
const commandesBrouillon = computed(() => commandesStore.brouillons)
const commandesEnvoyees = computed(() => commandesStore.envoyees)

// Deliveries expected today
const livraisonsJour = computed(() =>
  commandesStore.commandes.filter(c =>
    c.date_livraison_prevue === today && c.statut === 'envoyee'
  )
)

// Low stocks
const stocksBas = computed(() =>
  stocksStore.stocksBas((id) => {
    const ing = ingredientsStore.getById(id)
    if (!ing) return undefined
    return { stock_tampon: ing.stock_tampon, nom: ing.nom, unite_stock: ing.unite_stock }
  })
)

// Next deliveries (J+1 and beyond, excludes today)
const prochainesLivraisons = computed(() =>
  commandesStore.commandes
    .filter(c => c.date_livraison_prevue && c.date_livraison_prevue > today && c.statut === 'envoyee')
    .sort((a, b) => (a.date_livraison_prevue || '').localeCompare(b.date_livraison_prevue || ''))
    .slice(0, 3)
)

// Pending avoirs (avoir_en_cours orders)
const avoirsEnCours = computed(() =>
  commandesStore.commandes.filter(c => c.statut === 'avoir_en_cours')
)

// Unread notifications
const unreadNotifs = computed(() => notificationsStore.unread.slice(0, 5))

function fournisseurNom(id: string) {
  return fournisseursStore.getById(id)?.nom || 'Fournisseur inconnu'
}

function formatDate(d: string | null) {
  if (!d) return ''
  return new Date(d).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short' })
}

onMounted(async () => {
  await Promise.all([
    commandesStore.fetchAll(),
    fournisseursStore.fetchAll(),
    ingredientsStore.fetchAll(),
    stocksStore.fetchAll(),
    notificationsStore.fetchAll(),
  ])

  // Load today's weather (non-blocking)
  try {
    const meteoArr = await restCall<MeteoDaily[]>('GET', `meteo_daily?date=eq.${today}&limit=1`)
    if (meteoArr.length > 0) meteoToday.value = meteoArr[0]!
  } catch { /* weather is optional */ }

  // Load yesterday's CA (non-blocking)
  try {
    const hier = new Date()
    hier.setDate(hier.getDate() - 1)
    const hierStr = toLocalDateStr(hier)
    const ventes = await restCall<{ ca_ttc: number }[]>('GET', `ventes_historique?date=eq.${hierStr}&select=ca_ttc&limit=1`)
    if (ventes.length > 0) caHier.value = ventes[0]!.ca_ttc
  } catch { /* CA is optional */ }
})
</script>

<template>
  <div class="dashboard">
    <h1>Bonjour {{ profile?.nom || '' }}</h1>

    <!-- Quick stats row -->
    <div class="quick-stats">
      <!-- Météo -->
      <div class="stat-chip" v-if="meteoToday">
        <span class="stat-emoji">{{ weatherCodeToEmoji(meteoToday.code_meteo) }}</span>
        <span class="stat-temp">
          {{ meteoToday.temperature_min?.toFixed(0) ?? '--' }}° / {{ meteoToday.temperature_max?.toFixed(0) ?? '--' }}°
        </span>
        <span v-if="meteoToday.precipitation_mm && meteoToday.precipitation_mm > 0" class="stat-rain">
          {{ meteoToday.precipitation_mm.toFixed(1) }}mm
        </span>
      </div>

      <!-- CA hier -->
      <div class="stat-chip" v-if="caHier !== null" @click="router.push('/reporting')">
        <span class="stat-label">CA hier</span>
        <span class="stat-value">{{ caHier.toLocaleString('fr-FR', { maximumFractionDigits: 0 }) }} €</span>
      </div>

      <!-- Stocks bas count -->
      <div class="stat-chip" :class="{ 'stat-alert': stocksBas.length > 0 }" @click="router.push('/stocks')">
        <span class="stat-label">Stocks bas</span>
        <span class="stat-value">{{ stocksBas.length }}</span>
      </div>
    </div>

    <div class="cards">
      <!-- Livraisons du jour -->
      <div class="card card-clickable" @click="router.push('/reception')">
        <div class="card-header">
          <div class="card-title">
            <span class="card-icon card-icon-primary">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 8h14M5 8a2 2 0 01-2-2V5a2 2 0 012-2h14a2 2 0 012 2v1a2 2 0 01-2 2M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4"/></svg>
            </span>
            <h2>Livraisons du jour</h2>
          </div>
          <span v-if="livraisonsJour.length > 0" class="badge badge-primary">{{ livraisonsJour.length }}</span>
        </div>
        <div v-if="livraisonsJour.length === 0" class="empty">Aucune livraison prévue</div>
        <div v-for="c in livraisonsJour" :key="c.id" class="card-item">
          <span class="item-label">{{ fournisseurNom(c.fournisseur_id) }}</span>
          <span class="item-value">{{ c.montant_total_ht.toFixed(0) }} € HT</span>
        </div>
      </div>

      <!-- Prochaines livraisons (J+1+) -->
      <div v-if="prochainesLivraisons.length > 0" class="card card-clickable" @click="router.push('/commandes')">
        <div class="card-header">
          <div class="card-title">
            <span class="card-icon card-icon-info">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            </span>
            <h2>Prochaines livraisons</h2>
          </div>
        </div>
        <div v-for="c in prochainesLivraisons" :key="c.id" class="card-item">
          <span class="item-label">{{ fournisseurNom(c.fournisseur_id) }}</span>
          <span class="item-value">{{ formatDate(c.date_livraison_prevue) }}</span>
        </div>
      </div>

      <!-- Commandes brouillon -->
      <div class="card card-clickable" @click="router.push('/commandes')">
        <div class="card-header">
          <div class="card-title">
            <span class="card-icon card-icon-warning">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01m-.01 4h.01"/></svg>
            </span>
            <h2>Commandes en cours</h2>
          </div>
          <span v-if="commandesBrouillon.length > 0" class="badge badge-warning">{{ commandesBrouillon.length }}</span>
        </div>
        <div v-if="commandesBrouillon.length === 0 && commandesEnvoyees.length === 0" class="empty">
          Aucune commande en cours
        </div>
        <div v-for="c in commandesBrouillon.slice(0, 3)" :key="c.id" class="card-item">
          <span class="item-label">{{ fournisseurNom(c.fournisseur_id) }}</span>
          <span class="status-badge brouillon">Brouillon</span>
        </div>
        <div v-for="c in commandesEnvoyees.slice(0, 3)" :key="c.id" class="card-item">
          <span class="item-label">{{ fournisseurNom(c.fournisseur_id) }} — {{ formatDate(c.date_livraison_prevue) }}</span>
          <span class="status-badge envoyee">Envoyée</span>
        </div>
      </div>

      <!-- Stocks bas -->
      <div class="card">
        <div class="card-header">
          <div class="card-title">
            <span class="card-icon card-icon-danger">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
            </span>
            <h2>Stocks bas</h2>
          </div>
          <span v-if="stocksBas.length > 0" class="badge badge-danger">{{ stocksBas.length }}</span>
        </div>
        <div v-if="stocksBas.length === 0" class="empty">Tous les stocks sont OK</div>
        <div v-for="s in stocksBas.slice(0, 6)" :key="s.ingredientId" class="card-item">
          <span class="item-label">{{ s.nom }}</span>
          <span class="item-value stock-low">
            {{ s.quantite.toFixed(1) }} / {{ s.tampon }} {{ s.unite }}
          </span>
        </div>
        <div v-if="stocksBas.length > 6" class="card-more">
          +{{ stocksBas.length - 6 }} autres
        </div>
      </div>

      <!-- Notifications -->
      <div class="card">
        <div class="card-header">
          <div class="card-title">
            <span class="card-icon card-icon-info">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/></svg>
            </span>
            <h2>Alertes</h2>
          </div>
          <span v-if="notificationsStore.unreadCount > 0" class="badge badge-danger">
            {{ notificationsStore.unreadCount }}
          </span>
        </div>
        <div v-if="unreadNotifs.length === 0" class="empty">Aucune alerte</div>
        <div
          v-for="n in unreadNotifs"
          :key="n.id"
          class="card-item notif-item"
          @click="notificationsStore.markAsRead(n.id)"
        >
          <div>
            <span class="notif-title">{{ n.titre }}</span>
            <span class="notif-msg">{{ n.message }}</span>
          </div>
        </div>
        <button
          v-if="notificationsStore.unreadCount > 5"
          class="card-link"
          @click="notificationsStore.markAllAsRead()"
        >
          Tout marquer comme lu
        </button>
      </div>

      <!-- Avoirs en attente -->
      <div v-if="avoirsEnCours.length > 0" class="card">
        <div class="card-header">
          <div class="card-title">
            <span class="card-icon card-icon-warning">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1"/></svg>
            </span>
            <h2>Avoirs en attente</h2>
          </div>
          <span class="badge badge-warning">{{ avoirsEnCours.length }}</span>
        </div>
        <div v-for="c in avoirsEnCours" :key="c.id" class="card-item">
          <span class="item-label">{{ fournisseurNom(c.fournisseur_id) }} — {{ c.numero }}</span>
          <span class="item-value">{{ formatDate(c.updated_at) }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard h1 {
  font-size: 26px;
  margin-bottom: 24px;
  color: var(--text-primary);
}

.cards {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 16px;
}

.card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  cursor: default;
  border: 1px solid var(--border);
  transition: box-shadow 0.15s, border-color 0.15s;
}

.card-clickable {
  cursor: pointer;
}
.card-clickable:active {
  border-color: var(--color-primary);
  box-shadow: 0 2px 8px rgba(232, 93, 44, 0.12);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
}

.card-title {
  display: flex;
  align-items: center;
  gap: 10px;
}

.card-icon {
  width: 36px;
  height: 36px;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.card-icon-primary { background: rgba(232, 93, 44, 0.1); color: var(--color-primary); }
.card-icon-warning { background: rgba(245, 158, 11, 0.1); color: var(--color-warning); }
.card-icon-danger { background: rgba(239, 68, 68, 0.1); color: #ef4444; }
.card-icon-info { background: rgba(59, 130, 246, 0.1); color: var(--color-info); }

.card-header h2 {
  font-size: 17px;
  color: var(--text-primary);
  margin: 0;
}

.badge {
  padding: 2px 10px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 700;
  color: white;
}
.badge-primary { background: var(--color-primary); }
.badge-warning { background: var(--color-warning); }
.badge-danger { background: #ef4444; }

.empty {
  color: var(--text-tertiary);
  font-size: 15px;
}

.card-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
  border-bottom: 1px solid var(--border);
}
.card-item:last-child { border-bottom: none; }

.item-label {
  font-size: 15px;
  font-weight: 500;
  color: var(--text-primary);
}

.item-value {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
}

.stock-low { color: #ef4444; }

.status-badge {
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
}
.status-badge.brouillon { background: #e5e7eb; color: #374151; }
.status-badge.envoyee { background: #dbeafe; color: #1e40af; }

.card-more {
  text-align: center;
  color: var(--text-tertiary);
  font-size: 13px;
  padding-top: 8px;
}

.notif-item { flex-direction: column; align-items: flex-start; gap: 2px; cursor: pointer; }
.notif-title { font-size: 14px; font-weight: 600; display: block; }
.notif-msg { font-size: 13px; color: var(--text-secondary); display: block; }

.card-link {
  background: none;
  border: none;
  color: var(--color-primary);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  padding: 8px 0 0;
}

/* ── Quick stats row ── */
.quick-stats {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.stat-chip {
  display: flex;
  align-items: center;
  gap: 8px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 10px 16px;
  cursor: pointer;
  transition: border-color 0.15s;
}
.stat-chip:active {
  border-color: var(--color-primary);
}

.stat-emoji {
  font-size: 24px;
  line-height: 1;
}

.stat-temp {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.stat-rain {
  font-size: 13px;
  color: #3b82f6;
  font-weight: 500;
}

.stat-label {
  font-size: 13px;
  color: var(--text-tertiary);
}

.stat-value {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
}

.stat-alert .stat-value {
  color: #ef4444;
}
</style>
