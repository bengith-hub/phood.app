<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useIngredientsStore } from '@/stores/ingredients'
import { useStocksStore } from '@/stores/stocks'

const router = useRouter()
const ingredientsStore = useIngredientsStore()
const stocksStore = useStocksStore()

const search = ref('')
const filter = ref<'all' | 'low' | 'ok'>('all')

const stockItems = computed(() => {
  const ingredients = ingredientsStore.actifs
  const q = search.value.toLowerCase()

  const items = ingredients.map(ing => {
    const stock = stocksStore.getByIngredient(ing.id)
    const quantite = stock?.quantite ?? 0
    const isLow = quantite < ing.stock_tampon
    return {
      id: ing.id,
      nom: ing.nom,
      categorie: ing.categorie,
      quantite,
      tampon: ing.stock_tampon,
      unite: ing.unite_stock,
      isLow,
      lastUpdate: stock?.derniere_maj,
      source: stock?.source_maj,
    }
  })

  let filtered = items
  if (filter.value === 'low') filtered = items.filter(i => i.isLow)
  else if (filter.value === 'ok') filtered = items.filter(i => !i.isLow)

  if (q) {
    filtered = filtered.filter(i =>
      i.nom.toLowerCase().includes(q) ||
      i.categorie?.toLowerCase().includes(q)
    )
  }

  return filtered.sort((a, b) => {
    // Low stocks first
    if (a.isLow !== b.isLow) return a.isLow ? -1 : 1
    return a.nom.localeCompare(b.nom, 'fr')
  })
})

const lowCount = computed(() =>
  ingredientsStore.actifs.filter(ing => {
    const stock = stocksStore.getByIngredient(ing.id)
    return (stock?.quantite ?? 0) < ing.stock_tampon
  }).length
)

function formatDate(d: string | undefined) {
  if (!d) return ''
  return new Date(d).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', hour: '2-digit', minute: '2-digit' })
}

const SOURCE_LABELS: Record<string, string> = {
  reception: 'Réception',
  inventaire: 'Inventaire',
  vente: 'Vente',
  manuel: 'Manuel',
}

onMounted(async () => {
  await Promise.all([
    ingredientsStore.fetchAll(),
    stocksStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="stocks-page">
    <h1>Stocks</h1>

    <div class="filters">
      <button :class="['filter-btn', { active: filter === 'all' }]" @click="filter = 'all'">
        Tous ({{ ingredientsStore.actifs.length }})
      </button>
      <button :class="['filter-btn filter-low', { active: filter === 'low' }]" @click="filter = 'low'">
        Bas ({{ lowCount }})
      </button>
      <button :class="['filter-btn', { active: filter === 'ok' }]" @click="filter = 'ok'">
        OK ({{ ingredientsStore.actifs.length - lowCount }})
      </button>
    </div>

    <input
      v-model="search"
      type="search"
      placeholder="Rechercher un ingrédient..."
      class="search-input"
    />

    <div v-if="stocksStore.loading || ingredientsStore.loading" class="loading">Chargement...</div>

    <div v-else class="stock-list">
      <div v-if="stockItems.length === 0" class="empty">Aucun résultat</div>
      <div
        v-for="item in stockItems"
        :key="item.id"
        :class="['stock-card clickable', { low: item.isLow }]"
        @click="router.push(`/recettes/ingredient/${item.id}`)"
      >
        <div class="stock-main">
          <div class="stock-info">
            <span class="stock-name">{{ item.nom }}</span>
            <span v-if="item.categorie" class="stock-cat">{{ item.categorie }}</span>
          </div>
          <div class="stock-qty">
            <span :class="['qty-value', { 'qty-low': item.isLow }]">
              {{ item.quantite.toFixed(1) }}
            </span>
            <span class="qty-unit">{{ item.unite }}</span>
          </div>
        </div>
        <div class="stock-detail">
          <span class="stock-tampon">Tampon : {{ item.tampon }} {{ item.unite }}</span>
          <span v-if="item.lastUpdate" class="stock-updated">
            {{ SOURCE_LABELS[item.source || ''] || '' }} — {{ formatDate(item.lastUpdate) }}
          </span>
        </div>
        <div v-if="item.isLow" class="stock-bar">
          <div
            class="stock-bar-fill"
            :style="{ width: Math.min(100, (item.quantite / item.tampon) * 100) + '%' }"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
h1 { font-size: 28px; margin-bottom: 16px; }

.filters {
  display: flex;
  gap: 8px;
  margin-bottom: 12px;
}
.filter-btn {
  padding: 10px 18px;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-surface);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
}
.filter-btn.active {
  background: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}
.filter-low.active {
  background: #ef4444;
  border-color: #ef4444;
}

.search-input {
  width: 100%;
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-surface);
  margin-bottom: 16px;
}
.search-input:focus { outline: none; border-color: var(--color-primary); }

.loading, .empty { text-align: center; color: var(--text-tertiary); padding: 40px; }

.stock-list { display: flex; flex-direction: column; gap: 6px; }
.stock-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 14px 16px;
  border-left: 4px solid transparent;
  cursor: pointer;
  transition: box-shadow 0.15s;
}
.stock-card:active {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.stock-card.low { border-left-color: #ef4444; }

.stock-main {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}
.stock-info { display: flex; flex-direction: column; }
.stock-name { font-size: 16px; font-weight: 600; }
.stock-cat { font-size: 13px; color: var(--text-tertiary); }
.stock-qty { text-align: right; }
.qty-value { font-size: 20px; font-weight: 700; }
.qty-low { color: #ef4444; }
.qty-unit { font-size: 14px; color: var(--text-tertiary); margin-left: 4px; }

.stock-detail {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  color: var(--text-tertiary);
}

.stock-bar {
  height: 4px;
  background: #fee2e2;
  border-radius: 2px;
  margin-top: 8px;
  overflow: hidden;
}
.stock-bar-fill {
  height: 100%;
  background: #ef4444;
  border-radius: 2px;
  transition: width 0.3s;
}
</style>
