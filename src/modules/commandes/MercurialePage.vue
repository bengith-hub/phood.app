<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useFournisseursStore } from '@/stores/fournisseurs'
import type { Conditionnement } from '@/types/database'

const route = useRoute()
const mercurialeStore = useMercurialeStore()
const fournisseursStore = useFournisseursStore()

const search = ref('')
const selectedFournisseurId = ref<string | null>(null)
const expandedCategories = ref<Set<string>>(new Set())

// Initialize from route param
watch(() => route.params.fournisseurId, (id) => {
  if (id) selectedFournisseurId.value = id as string
}, { immediate: true })

const fournisseurs = computed(() => fournisseursStore.actifs)

const displayedGroups = computed(() => {
  if (!selectedFournisseurId.value) return []

  const groups = mercurialeStore.groupedByCategorie(selectedFournisseurId.value)

  if (!search.value) return groups

  const q = search.value.toLowerCase()
  return groups
    .map(g => ({
      categorie: g.categorie,
      produits: g.produits.filter(p =>
        p.designation.toLowerCase().includes(q) ||
        p.ref_fournisseur?.toLowerCase().includes(q)
      ),
    }))
    .filter(g => g.produits.length > 0)
})

const totalProducts = computed(() =>
  displayedGroups.value.reduce((acc, g) => acc + g.produits.length, 0)
)

function toggleCategory(cat: string) {
  if (expandedCategories.value.has(cat)) {
    expandedCategories.value.delete(cat)
  } else {
    expandedCategories.value.add(cat)
  }
}

function isCategoryExpanded(cat: string) {
  // Expand all if searching, otherwise respect toggle
  if (search.value) return true
  return expandedCategories.value.has(cat)
}

function formatConditionnement(cond: Conditionnement) {
  return `${cond.nom} (${cond.quantite} ${cond.unite})`
}

function formatPrix(prix: number, unite: string) {
  return `${prix.toFixed(2)} €/${unite}`
}

function selectFournisseur(id: string) {
  selectedFournisseurId.value = id
  // Expand all categories by default
  expandedCategories.value = new Set(
    mercurialeStore.groupedByCategorie(id).map(g => g.categorie)
  )
}

onMounted(async () => {
  await Promise.all([
    fournisseursStore.fetchAll(),
    mercurialeStore.fetchAll(),
  ])
  // Auto-select first fournisseur if none selected
  if (!selectedFournisseurId.value && fournisseurs.value.length > 0) {
    selectFournisseur(fournisseurs.value[0]!.id)
  } else if (selectedFournisseurId.value) {
    selectFournisseur(selectedFournisseurId.value)
  }
})
</script>

<template>
  <div class="mercuriale-page">
    <h1>Mercuriale</h1>

    <!-- Fournisseur selector -->
    <div class="fournisseur-tabs">
      <button
        v-for="f in fournisseurs"
        :key="f.id"
        class="tab-btn"
        :class="{ active: selectedFournisseurId === f.id }"
        @click="selectFournisseur(f.id)"
      >
        {{ f.nom }}
      </button>
    </div>

    <!-- Search -->
    <div class="search-bar">
      <input
        v-model="search"
        type="search"
        placeholder="Rechercher un produit..."
        class="search-input"
      />
      <span class="result-count">{{ totalProducts }} produits</span>
    </div>

    <div v-if="mercurialeStore.loading" class="loading">Chargement...</div>

    <div v-else-if="!selectedFournisseurId" class="empty">
      Sélectionnez un fournisseur
    </div>

    <div v-else-if="displayedGroups.length === 0" class="empty">
      Aucun produit trouvé
    </div>

    <!-- Accordion by category -->
    <div v-else class="category-list">
      <div v-for="group in displayedGroups" :key="group.categorie" class="category-group">
        <button
          class="category-header"
          @click="toggleCategory(group.categorie)"
        >
          <span class="category-name">{{ group.categorie }}</span>
          <span class="category-count">{{ group.produits.length }}</span>
          <span class="chevron" :class="{ expanded: isCategoryExpanded(group.categorie) }">▶</span>
        </button>

        <div v-if="isCategoryExpanded(group.categorie)" class="category-products">
          <div v-for="p in group.produits" :key="p.id" class="product-card">
            <div class="product-header">
              <span class="product-name">{{ p.designation }}</span>
              <span v-if="p.ref_fournisseur" class="product-sku">{{ p.ref_fournisseur }}</span>
            </div>
            <div class="product-details">
              <span class="product-price">{{ formatPrix(p.prix_unitaire, p.unite_stock) }}</span>
              <span v-if="p.tva_taux" class="product-tva">TVA {{ p.tva_taux }}%</span>
            </div>
            <div v-if="p.conditionnements && (p.conditionnements as Conditionnement[]).length > 0" class="product-cond">
              <span
                v-for="(c, i) in (p.conditionnements as Conditionnement[])"
                :key="i"
                class="cond-badge"
                :class="{ primary: i === p.conditionnement_commande_idx }"
              >
                {{ formatConditionnement(c) }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
h1 {
  font-size: 28px;
  margin-bottom: 16px;
}

.fournisseur-tabs {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 8px;
  margin-bottom: 16px;
}

.tab-btn {
  flex-shrink: 0;
  height: 48px;
  padding: 0 20px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-surface);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
  white-space: nowrap;
}

.tab-btn.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.search-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
}

.search-input {
  flex: 1;
  max-width: 480px;
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-surface);
}

.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.result-count {
  color: var(--text-tertiary);
  font-size: 15px;
  white-space: nowrap;
}

.loading, .empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 60px 20px;
}

.category-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.category-header {
  display: flex;
  align-items: center;
  width: 100%;
  padding: 16px 20px;
  background: var(--bg-surface);
  border: none;
  border-radius: var(--radius-md);
  cursor: pointer;
  font-size: 17px;
  gap: 12px;
}

.category-header:active {
  background: var(--bg-hover);
}

.category-name {
  font-weight: 700;
  flex: 1;
  text-align: left;
}

.category-count {
  color: var(--text-tertiary);
  font-size: 14px;
}

.chevron {
  font-size: 12px;
  color: var(--text-tertiary);
  transition: transform 0.15s;
}

.chevron.expanded {
  transform: rotate(90deg);
}

.category-products {
  display: flex;
  flex-direction: column;
  gap: 8px;
  padding: 8px 0 8px 16px;
}

.product-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.product-header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 8px;
}

.product-name {
  font-size: 16px;
  font-weight: 600;
}

.product-sku {
  font-size: 13px;
  color: var(--text-tertiary);
  font-family: monospace;
}

.product-details {
  display: flex;
  gap: 12px;
  margin-bottom: 8px;
}

.product-price {
  font-size: 18px;
  font-weight: 700;
  color: var(--color-primary);
}

.product-tva {
  font-size: 13px;
  color: var(--text-tertiary);
  align-self: center;
}

.product-cond {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.cond-badge {
  font-size: 12px;
  padding: 4px 8px;
  border-radius: 6px;
  background: var(--bg-main);
  color: var(--text-secondary);
}

.cond-badge.primary {
  background: var(--color-primary);
  color: white;
  font-weight: 600;
}
</style>
