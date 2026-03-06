<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { useCommandesStore } from '@/stores/commandes'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useIngredientsStore } from '@/stores/ingredients'
import { useStocksStore } from '@/stores/stocks'
import { useNotificationsStore } from '@/stores/notifications'

const router = useRouter()
const { profile } = useAuth()
const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()
const ingredientsStore = useIngredientsStore()
const stocksStore = useStocksStore()
const notificationsStore = useNotificationsStore()

const today = new Date().toISOString().split('T')[0]

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
})
</script>

<template>
  <div class="dashboard">
    <h1>Bonjour {{ profile?.nom || '' }}</h1>

    <div class="cards">
      <!-- Livraisons du jour -->
      <div class="card" @click="router.push('/reception')">
        <div class="card-header">
          <h2>Livraisons du jour</h2>
          <span v-if="livraisonsJour.length > 0" class="badge badge-primary">{{ livraisonsJour.length }}</span>
        </div>
        <div v-if="livraisonsJour.length === 0" class="empty">Aucune livraison prévue</div>
        <div v-for="c in livraisonsJour" :key="c.id" class="card-item">
          <span class="item-label">{{ fournisseurNom(c.fournisseur_id) }}</span>
          <span class="item-value">{{ c.montant_total_ht.toFixed(0) }} € HT</span>
        </div>
      </div>

      <!-- Commandes brouillon -->
      <div class="card" @click="router.push('/commandes')">
        <div class="card-header">
          <h2>Commandes en cours</h2>
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
          <h2>Stocks bas</h2>
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
          <h2>Alertes</h2>
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
          <h2>Avoirs en attente</h2>
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
  font-size: 28px;
  margin-bottom: 24px;
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
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 14px;
}

.card-header h2 {
  font-size: 18px;
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
</style>
