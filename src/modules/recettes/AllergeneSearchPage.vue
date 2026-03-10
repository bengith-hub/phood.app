<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRecettesStore } from '@/stores/recettes'
import { useIngredientsStore } from '@/stores/ingredients'

const recettesStore = useRecettesStore()
const ingredientsStore = useIngredientsStore()

const query = ref('')
const hasSearched = ref(false)
const showSafe = ref(false) // false = "contient", true = "ne contient PAS"

const ALLERGEN_LABELS: Record<string, string> = {
  gluten: 'Gluten', crustaces: 'Crustacés', oeufs: 'Oeufs', poissons: 'Poissons',
  arachides: 'Arachides', soja: 'Soja', lait: 'Lait', fruits_a_coque: 'Fruits à coque',
  celeri: 'Céleri', moutarde: 'Moutarde', sesame: 'Sésame', sulfites: 'Sulfites',
  lupin: 'Lupin', mollusques: 'Mollusques',
}

const ALLERGEN_SHORTCUTS = Object.entries(ALLERGEN_LABELS)

function getIngredient(id: string) {
  const ing = ingredientsStore.getById(id)
  if (!ing || !ing.actif) return undefined
  return { allergenes: ing.allergenes, contient: ing.contient }
}

// Count ingredients missing composition (no allergenes AND no contient)
const ingredientsSansCompo = computed(() => {
  return ingredientsStore.ingredients.filter(i =>
    i.actif && (!i.allergenes || i.allergenes.length === 0) && !i.contient
  ).length
})

// Recipes WITH the allergen
const resultsContient = computed(() => {
  const q = query.value.trim()
  if (!q) return []
  return recettesStore.findRecipesWithAllergen(q, getIngredient)
})

// Recipes WITHOUT the allergen (safe to propose)
const resultsSans = computed(() => {
  const q = query.value.trim()
  if (!q) return []
  const withAllergen = new Set(resultsContient.value.map(r => r.recette.id))
  return recettesStore.plats
    .filter(p => !withAllergen.has(p.id))
    .map(p => ({ recette: p }))
})

const results = computed(() => showSafe.value ? resultsSans.value : resultsContient.value)

// Debounce search feedback
let debounceTimer: ReturnType<typeof setTimeout>
watch(query, () => {
  hasSearched.value = false
  clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => {
    hasSearched.value = query.value.trim().length > 0
  }, 200)
})

function setQuery(allergen: string) {
  query.value = allergen
  hasSearched.value = true
}

onMounted(async () => {
  await Promise.all([
    recettesStore.fetchAll(),
    ingredientsStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="allergene-search">
    <h1>Verification allergenes</h1>
    <p class="subtitle">Recherchez un allergene pour voir quelles recettes le contiennent</p>

    <!-- Warning: missing compositions -->
    <div v-if="ingredientsSansCompo > 0" class="compo-warning" @click="$router.push('/recettes')">
      ⚠️ <strong>{{ ingredientsSansCompo }} ingredient{{ ingredientsSansCompo > 1 ? 's' : '' }}</strong> sans composition connue — les resultats peuvent etre incomplets
    </div>

    <input
      v-model="query"
      type="search"
      placeholder="Ex: gluten, sesame, lait..."
      class="search-input"
      autofocus
    />

    <div class="quick-tags">
      <button
        v-for="[key, label] in ALLERGEN_SHORTCUTS"
        :key="key"
        :class="['tag', { active: query.toLowerCase() === key }]"
        @click="setQuery(key)"
      >
        {{ label }}
      </button>
    </div>

    <div v-if="recettesStore.loading || ingredientsStore.loading" class="loading">
      Chargement des donnees...
    </div>

    <template v-else-if="hasSearched">
      <!-- Toggle: contient / ne contient pas -->
      <div class="mode-toggle">
        <button :class="['toggle-btn', { active: !showSafe }]" @click="showSafe = false">
          Contient ({{ resultsContient.length }})
        </button>
        <button :class="['toggle-btn safe', { active: showSafe }]" @click="showSafe = true">
          Sans ({{ resultsSans.length }})
        </button>
      </div>

      <div class="results-header">
        <template v-if="!showSafe">
          <span class="results-count">{{ results.length }} recette{{ results.length !== 1 ? 's' : '' }}</span>
          contenant <strong>{{ ALLERGEN_LABELS[query.toLowerCase()] || query }}</strong>
        </template>
        <template v-else>
          <span class="results-count results-safe">{{ results.length }} recette{{ results.length !== 1 ? 's' : '' }}</span>
          <strong>sans {{ ALLERGEN_LABELS[query.toLowerCase()] || query }}</strong> — a proposer au client
        </template>
      </div>

      <div v-if="results.length === 0" class="no-results">
        {{ showSafe ? 'Toutes les recettes contiennent cet allergene.' : 'Aucune recette ne contient cet allergene.' }}
      </div>

      <div v-else class="results-list">
        <div v-for="item in results" :key="item.recette.id" class="result-card" :class="{ 'result-safe': showSafe }">
          <div class="result-main">
            <span class="result-name">{{ item.recette.nom }}</span>
            <span v-if="item.recette.categorie" class="result-cat">{{ item.recette.categorie }}</span>
          </div>
          <div v-if="!showSafe && 'allergens' in item" class="result-allergens">
            <span
              v-for="a in Array.from((item as { allergens: Set<string> }).allergens)"
              :key="a"
              :class="['allergen-badge', { highlight: a.includes(query.toLowerCase()) }]"
            >
              {{ ALLERGEN_LABELS[a] || a }}
            </span>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<style scoped>
h1 { font-size: 28px; margin-bottom: 8px; }
.subtitle { color: var(--text-secondary); margin-bottom: 16px; font-size: 16px; }

.compo-warning {
  background: #fef3cd;
  border: 1px solid #ffc107;
  border-radius: var(--radius-md);
  padding: 12px 16px;
  margin-bottom: 16px;
  font-size: 14px;
  color: #856404;
  cursor: pointer;
}

.search-input {
  width: 100%;
  height: 56px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 20px;
  font-size: 20px;
  background: var(--bg-surface);
  color: var(--text-primary);
  caret-color: var(--text-primary);
}
.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.quick-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 16px 0 24px;
}
.tag {
  padding: 8px 14px;
  border-radius: 20px;
  border: 1px solid var(--border);
  background: var(--bg-surface);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
}
.tag.active {
  background: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}

.loading {
  text-align: center;
  color: var(--text-tertiary);
  padding: 40px;
}

.mode-toggle {
  display: flex;
  gap: 0;
  margin-bottom: 16px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  overflow: hidden;
}
.toggle-btn {
  flex: 1;
  padding: 12px;
  font-size: 15px;
  font-weight: 600;
  border: none;
  background: var(--bg-surface);
  color: var(--text-secondary);
  cursor: pointer;
}
.toggle-btn.active {
  background: var(--color-primary);
  color: white;
}
.toggle-btn.safe.active {
  background: #16a34a;
}

.results-header {
  font-size: 16px;
  color: var(--text-secondary);
  margin-bottom: 16px;
}
.results-count {
  font-weight: 700;
  color: var(--text-primary);
}
.results-safe {
  color: #16a34a;
}

.no-results {
  text-align: center;
  color: var(--text-tertiary);
  padding: 40px;
  font-size: 16px;
}

.results-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.result-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 14px 16px;
}
.result-safe {
  border-left: 4px solid #16a34a;
}
.result-main {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 8px;
}
.result-name {
  font-size: 16px;
  font-weight: 600;
}
.result-cat {
  font-size: 13px;
  color: var(--text-tertiary);
}
.result-allergens {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}
.allergen-badge {
  background: #f3f4f6;
  color: #6b7280;
  padding: 4px 10px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
}
.allergen-badge.highlight {
  background: #fef3c7;
  color: #92400e;
}
</style>
