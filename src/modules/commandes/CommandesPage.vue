<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCommandesStore } from '@/stores/commandes'
import { useFournisseursStore } from '@/stores/fournisseurs'
import type { StatutCommande } from '@/types/database'

const router = useRouter()
const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()

const search = ref('')
const statutFilter = ref<StatutCommande | ''>('')

const STATUT_CONFIG: Record<StatutCommande, { label: string; color: string }> = {
  brouillon: { label: 'Brouillon', color: '#9CA3AF' },
  envoyee: { label: 'Envoyée', color: '#3B82F6' },
  receptionnee: { label: 'Réceptionnée', color: '#8B5CF6' },
  controlee: { label: 'Contrôlée', color: '#F59E0B' },
  validee: { label: 'Validée', color: '#22C55E' },
  avoir_en_cours: { label: 'Avoir en cours', color: '#EF4444' },
  cloturee: { label: 'Clôturée', color: '#6B7280' },
}

const filtered = computed(() => {
  let results = commandesStore.commandes
  if (statutFilter.value) {
    results = results.filter(c => c.statut === statutFilter.value)
  }
  if (search.value) {
    const q = search.value.toLowerCase()
    results = results.filter(c =>
      c.numero.toLowerCase().includes(q) ||
      fournisseursStore.getById(c.fournisseur_id)?.nom.toLowerCase().includes(q)
    )
  }
  return results
})

function getFournisseurNom(id: string) {
  return fournisseursStore.getById(id)?.nom || '—'
}

function formatDate(date: string | null) {
  if (!date) return '—'
  return new Date(date).toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })
}

function formatMontant(montant: number) {
  return `${montant.toFixed(2)} €`
}

onMounted(async () => {
  await Promise.all([
    commandesStore.fetchAll(),
    fournisseursStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="commandes-page">
    <div class="page-header">
      <h1>Commandes</h1>
      <button class="btn-primary" @click="router.push('/commandes/new')">
        + Nouvelle commande
      </button>
    </div>

    <div class="filters">
      <input
        v-model="search"
        type="search"
        placeholder="Rechercher..."
        class="search-input"
      />
      <div class="statut-filters">
        <button
          class="filter-btn"
          :class="{ active: !statutFilter }"
          @click="statutFilter = ''"
        >
          Toutes
        </button>
        <button
          v-for="(conf, statut) in STATUT_CONFIG"
          :key="statut"
          class="filter-btn"
          :class="{ active: statutFilter === statut }"
          @click="statutFilter = statut as StatutCommande"
        >
          {{ conf.label }}
        </button>
      </div>
    </div>

    <div v-if="commandesStore.loading" class="loading">Chargement...</div>

    <div v-else-if="filtered.length === 0" class="empty">
      <p>Aucune commande{{ search || statutFilter ? ' trouvée' : '' }}.</p>
      <p v-if="!search && !statutFilter">Créez votre première commande.</p>
    </div>

    <div v-else class="commande-list">
      <div
        v-for="c in filtered"
        :key="c.id"
        class="commande-card"
        @click="router.push(`/commandes/${c.id}`)"
      >
        <div class="card-top">
          <span class="card-numero">{{ c.numero }}</span>
          <span
            class="badge-statut"
            :style="{ background: STATUT_CONFIG[c.statut].color }"
          >
            {{ STATUT_CONFIG[c.statut].label }}
          </span>
        </div>
        <div class="card-fournisseur">{{ getFournisseurNom(c.fournisseur_id) }}</div>
        <div class="card-bottom">
          <span class="card-date">{{ formatDate(c.date_commande || c.created_at) }}</span>
          <span v-if="c.date_livraison_prevue" class="card-livraison">
            Livr. {{ formatDate(c.date_livraison_prevue) }}
          </span>
          <span class="card-montant">{{ formatMontant(c.montant_total_ht) }} HT</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 { font-size: 28px; }

.btn-primary {
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 24px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}

.filters {
  margin-bottom: 20px;
}

.search-input {
  width: 100%;
  max-width: 400px;
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-surface);
  margin-bottom: 12px;
}

.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.statut-filters {
  display: flex;
  gap: 6px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 4px;
}

.filter-btn {
  flex-shrink: 0;
  height: 40px;
  padding: 0 14px;
  border: 2px solid var(--border);
  border-radius: 20px;
  background: var(--bg-surface);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}

.filter-btn.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.loading, .empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 60px 20px;
  font-size: 16px;
}

.commande-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.commande-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px 20px;
  cursor: pointer;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.15s;
}

.commande-card:active {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.card-numero {
  font-size: 16px;
  font-weight: 700;
  font-family: monospace;
}

.badge-statut {
  padding: 3px 10px;
  border-radius: 10px;
  color: white;
  font-size: 12px;
  font-weight: 700;
}

.card-fournisseur {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 8px;
}

.card-bottom {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: var(--text-secondary);
}

.card-montant {
  margin-left: auto;
  font-weight: 700;
  color: var(--text-primary);
}
</style>
