<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useRecettesStore } from '@/stores/recettes'
import { useIngredientsStore } from '@/stores/ingredients'

const router = useRouter()
const recettesStore = useRecettesStore()
const ingredientsStore = useIngredientsStore()

const search = ref('')
const tab = ref<'recettes' | 'ingredients' | 'sous_recettes'>('recettes')
const catFilter = ref('')
const showInactifs = ref(false)

const filteredRecettes = computed(() => {
  const q = search.value.toLowerCase()
  const list = tab.value === 'sous_recettes'
    ? recettesStore.sousRecettes
    : recettesStore.plats

  if (!q) return list
  return list.filter(r =>
    r.nom.toLowerCase().includes(q) ||
    r.categorie?.toLowerCase().includes(q)
  )
})

const filteredIngredients = computed(() => {
  if (tab.value !== 'ingredients') return []
  let list = showInactifs.value ? ingredientsStore.ingredients : ingredientsStore.actifs
  if (catFilter.value) {
    list = list.filter(i => i.categorie === catFilter.value)
  }
  const q = search.value.toLowerCase()
  if (q) {
    list = list.filter(i =>
      i.nom.toLowerCase().includes(q) ||
      i.categorie?.toLowerCase().includes(q) ||
      i.allergenes.some(a => a.toLowerCase().includes(q)) ||
      i.contient?.toLowerCase().includes(q)
    )
  }
  return list
})

const ALLERGEN_LABELS: Record<string, string> = {
  gluten: 'Gluten', crustaces: 'Crustacés', oeufs: 'Oeufs', poissons: 'Poissons',
  arachides: 'Arachides', soja: 'Soja', lait: 'Lait', fruits_a_coque: 'Fruits à coque',
  celeri: 'Céleri', moutarde: 'Moutarde', sesame: 'Sésame', sulfites: 'Sulfites',
  lupin: 'Lupin', mollusques: 'Mollusques',
}

onMounted(async () => {
  await Promise.all([
    recettesStore.fetchAll(),
    ingredientsStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="recettes-page">
    <div class="page-header">
      <h1>Recettes & Ingrédients</h1>
      <div class="header-actions">
        <button class="btn-allergenes" @click="router.push('/recettes/allergenes')">
          Vérif allergènes
        </button>
        <button class="btn-rentabilite" @click="router.push('/recettes/rentabilite')">
          Rentabilité
        </button>
      </div>
    </div>

    <!-- Quick actions -->
    <div class="quick-actions">
      <button class="action-btn" @click="router.push('/recettes/new')">
        + Nouvelle recette
      </button>
      <button class="action-btn action-ia" @click="router.push('/recettes/creation-ia')">
        Création IA
      </button>
    </div>

    <div class="tabs">
      <button :class="{ active: tab === 'recettes' }" @click="tab = 'recettes'">
        Recettes ({{ recettesStore.plats.length }})
      </button>
      <button :class="{ active: tab === 'ingredients' }" @click="tab = 'ingredients'">
        Ingrédients ({{ ingredientsStore.actifs.length }})
      </button>
      <button :class="{ active: tab === 'sous_recettes' }" @click="tab = 'sous_recettes'">
        Sous-recettes ({{ recettesStore.sousRecettes.length }})
      </button>
    </div>

    <input
      v-model="search"
      type="search"
      :placeholder="tab === 'ingredients' ? 'Rechercher un ingrédient...' : 'Rechercher une recette...'"
      class="search-input"
    />

    <!-- Ingredient filters -->
    <div v-if="tab === 'ingredients'" class="ing-filters">
      <select v-model="catFilter" class="filter-select">
        <option value="">Toutes catégories</option>
        <option v-for="c in ingredientsStore.categories" :key="c" :value="c">{{ c }}</option>
      </select>
      <label class="toggle-label">
        <input type="checkbox" v-model="showInactifs" class="toggle-check" />
        Inclure inactifs
      </label>
      <span class="result-count">{{ filteredIngredients.length }} résultat{{ filteredIngredients.length > 1 ? 's' : '' }}</span>
    </div>

    <div v-if="recettesStore.loading || ingredientsStore.loading" class="loading">Chargement...</div>

    <div v-else-if="tab !== 'ingredients'" class="item-list">
      <div v-if="filteredRecettes.length === 0" class="empty">Aucun résultat</div>
      <div
        v-for="r in filteredRecettes"
        :key="r.id"
        class="item-card clickable"
        @click="router.push(`/recettes/${r.id}`)"
      >
        <div class="item-main">
          <span class="item-name">{{ r.nom }}</span>
          <span v-if="r.categorie" class="item-cat">{{ r.categorie }}</span>
        </div>
        <div class="item-meta">
          <span v-if="r.cout_matiere > 0" class="item-cost">{{ r.cout_matiere.toFixed(2) }} €</span>
          <span v-if="r.zelty_product_id" class="badge-zelty">Zelty</span>
        </div>
      </div>
    </div>

    <div v-else class="item-list">
      <div v-if="filteredIngredients.length === 0" class="empty">Aucun résultat</div>
      <div
        v-for="ing in filteredIngredients"
        :key="ing.id"
        class="item-card clickable"
        :class="{ inactive: !ing.actif }"
        @click="router.push(`/recettes/ingredient/${ing.id}`)"
      >
        <div class="ing-row">
          <div class="ing-photo">
            <img v-if="ing.photo_url || ing.mercuriale_photo_url" :src="(ing.photo_url || ing.mercuriale_photo_url)!" :alt="ing.nom" />
            <svg v-else width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
          </div>
          <div class="ing-content">
            <div class="item-main">
              <span class="item-name">{{ ing.nom }}</span>
              <span v-if="ing.categorie" class="item-cat">{{ ing.categorie }}</span>
            </div>
            <div class="item-meta">
              <span v-if="ing.mercuriale_sku" class="item-sku">{{ ing.mercuriale_sku }}</span>
              <span class="item-unit">{{ ing.unite_stock }}</span>
              <span v-if="ing.cout_unitaire > 0" class="item-cost">{{ ing.cout_unitaire.toFixed(2) }} €/{{ ing.unite_stock }}</span>
              <span v-if="!ing.actif" class="badge-inactif">Inactif</span>
            </div>
            <div v-if="ing.allergenes.length > 0" class="item-allergens">
              <span v-for="a in ing.allergenes" :key="a" class="allergen-badge">
                {{ ALLERGEN_LABELS[a] || a }}
              </span>
            </div>
          </div>
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
  margin-bottom: 16px;
}
h1 { font-size: 28px; }
.header-actions {
  display: flex;
  gap: 8px;
}
.btn-allergenes {
  background: var(--color-warning);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}
.btn-rentabilite {
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}

.quick-actions {
  display: flex;
  gap: 10px;
  margin-bottom: 16px;
}
.action-btn {
  flex: 1;
  height: 52px;
  border: 2px dashed var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-surface);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
}
.action-btn:active {
  border-color: var(--color-primary);
  color: var(--color-primary);
}
.action-btn.action-ia {
  border-style: dashed;
  color: #6366f1;
  border-color: #6366f1;
}

.tabs {
  display: flex;
  gap: 4px;
  margin-bottom: 16px;
  background: var(--bg-main);
  border-radius: var(--radius-md);
  padding: 4px;
}
.tabs button {
  flex: 1;
  height: 48px;
  border: none;
  border-radius: var(--radius-sm);
  background: transparent;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
}
.tabs button.active {
  background: var(--bg-surface);
  color: var(--text-primary);
  box-shadow: 0 1px 3px rgba(0,0,0,0.08);
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

.item-list { display: flex; flex-direction: column; gap: 6px; }
.item-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 14px 16px;
}
.item-card.clickable {
  cursor: pointer;
  transition: box-shadow 0.15s;
}
.item-card.clickable:active {
  box-shadow: 0 0 0 2px var(--color-primary);
}
.item-main { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 4px; }
.item-name { font-size: 16px; font-weight: 600; }
.item-cat { font-size: 13px; color: var(--text-tertiary); }
.item-meta { display: flex; gap: 12px; font-size: 14px; }
.item-cost { color: var(--color-primary); font-weight: 600; }
.item-sku { color: var(--color-primary); font-weight: 600; font-size: 13px; }
.item-unit { color: var(--text-tertiary); }
.badge-zelty {
  background: #6366f1; color: white; padding: 2px 6px; border-radius: 6px;
  font-size: 11px; font-weight: 600;
}
.item-allergens { display: flex; gap: 4px; flex-wrap: wrap; margin-top: 6px; }
.allergen-badge {
  background: #fef3c7; color: #92400e; padding: 2px 8px; border-radius: 6px;
  font-size: 12px; font-weight: 600;
}

/* Ingredient filters */
.ing-filters {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}
.filter-select {
  height: 48px;
  padding: 0 14px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-surface);
  font-size: 16px;
  min-width: 180px;
}
.filter-select:focus { outline: none; border-color: var(--color-primary); }
.toggle-label {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  color: var(--text-secondary);
  cursor: pointer;
  white-space: nowrap;
}
.toggle-check {
  width: 20px;
  height: 20px;
  cursor: pointer;
}
.result-count {
  margin-left: auto;
  font-size: 14px;
  color: var(--text-tertiary);
  white-space: nowrap;
}

/* Ingredient row with photo */
.ing-row {
  display: flex;
  gap: 12px;
  align-items: flex-start;
}
.ing-photo {
  width: 52px;
  height: 52px;
  min-width: 52px;
  border-radius: var(--radius-sm);
  border: 2px solid var(--border);
  background: var(--bg-main);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  color: var(--text-tertiary);
}
.ing-photo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.ing-content {
  flex: 1;
  min-width: 0;
}
.item-card.inactive {
  opacity: 0.55;
}
.badge-inactif {
  background: var(--bg-main);
  color: var(--text-tertiary);
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
}
</style>
