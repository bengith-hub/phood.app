<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRecettesStore } from '@/stores/recettes'
import { useIngredientsStore } from '@/stores/ingredients'

const recettesStore = useRecettesStore()
const ingredientsStore = useIngredientsStore()

const query = ref('')
const hasSearched = ref(false)
const showSafe = ref(false)
const showSuggestions = ref(false)

function normalize(s: string): string {
  return s.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toLowerCase()
}

function getIngredientInfo(id: string) {
  const ing = ingredientsStore.getById(id)
  if (!ing || !ing.actif) return undefined
  return { nom: ing.nom, contient: ing.contient }
}

// Count ingredients missing composition
const ingredientsSansCompo = computed(() => {
  return ingredientsStore.ingredients.filter(i =>
    i.actif && (!i.allergenes || i.allergenes.length === 0) && !i.contient
  ).length
})

// Autocomplete suggestions from ingredient names
const suggestions = computed(() => {
  const q = normalize(query.value.trim())
  if (q.length < 2) return []
  const seen = new Set<string>()
  return ingredientsStore.ingredients
    .filter(i => {
      if (!i.actif) return false
      const n = normalize(i.nom)
      if (!n.includes(q)) return false
      if (seen.has(n)) return false
      seen.add(n)
      return true
    })
    .map(i => i.nom)
    .sort((a, b) => {
      // Exact start match first
      const aStart = normalize(a).startsWith(q) ? 0 : 1
      const bStart = normalize(b).startsWith(q) ? 0 : 1
      if (aStart !== bStart) return aStart - bStart
      return a.localeCompare(b, 'fr')
    })
    .slice(0, 8)
})

// Recipes WITH the ingredient
const resultsContient = computed(() => {
  const q = query.value.trim()
  if (!q || q.length < 2) return []
  return recettesStore.findRecipesWithIngredient(q, getIngredientInfo)
})

// Recipes WITHOUT the ingredient (safe to propose)
const resultsSans = computed(() => {
  const q = query.value.trim()
  if (!q || q.length < 2) return []
  const withIngredient = new Set(resultsContient.value.map(r => r.recette.id))
  return recettesStore.plats
    .filter(p => {
      if (withIngredient.has(p.id)) return false
      const ris = recettesStore.getIngredients(p.id)
      if (ris.length === 0) return false
      if (/EMP\/LIV|EMP\b.*\bLIV\b/i.test(p.nom)) return false
      const cat = p.categorie
      if (cat === 'Test' || cat === 'Kit boitage') return false
      return true
    })
    .map(p => ({ recette: p }))
})

const results = computed(() => showSafe.value ? resultsSans.value : resultsContient.value)

// Debounce search
let debounceTimer: ReturnType<typeof setTimeout>
watch(query, () => {
  hasSearched.value = false
  clearTimeout(debounceTimer)
  debounceTimer = setTimeout(() => {
    hasSearched.value = query.value.trim().length >= 2
  }, 300)
})

function selectSuggestion(name: string) {
  query.value = name
  hasSearched.value = true
  showSuggestions.value = false
}

function onBlur() {
  // Delay to allow click on suggestion
  setTimeout(() => (showSuggestions.value = false), 200)
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
    <h1>Recherche ingredients</h1>
    <p class="subtitle">Tapez un ingredient pour voir quels plats le contiennent</p>

    <!-- Warning: missing compositions -->
    <div v-if="ingredientsSansCompo > 0" class="compo-warning" @click="$router.push('/recettes')">
      ⚠️ <strong>{{ ingredientsSansCompo }} ingredient{{ ingredientsSansCompo > 1 ? 's' : '' }}</strong>
      sans composition connue — les resultats peuvent etre incomplets
    </div>

    <!-- Search with autocomplete -->
    <div class="search-wrapper">
      <input
        v-model="query"
        type="search"
        placeholder="Ex: carotte, poulet, coriandre, gluten..."
        class="search-input"
        autofocus
        @focus="showSuggestions = true"
        @blur="onBlur"
      />
      <div v-if="showSuggestions && suggestions.length > 0 && !hasSearched" class="suggestions">
        <button
          v-for="s in suggestions"
          :key="s"
          class="suggestion-item"
          @mousedown.prevent="selectSuggestion(s)"
        >
          {{ s }}
        </button>
      </div>
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
          <span class="results-count">{{ results.length }} plat{{ results.length !== 1 ? 's' : '' }}</span>
          contenant <strong>{{ query }}</strong>
        </template>
        <template v-else>
          <span class="results-count results-safe">{{ results.length }} plat{{ results.length !== 1 ? 's' : '' }}</span>
          <strong>sans {{ query }}</strong> — a proposer au client
        </template>
      </div>

      <div v-if="results.length === 0" class="no-results">
        {{ showSafe ? 'Tous les plats contiennent cet ingredient.' : 'Aucun plat ne contient cet ingredient.' }}
      </div>

      <div v-else class="results-list">
        <div v-for="item in results" :key="item.recette.id" class="result-card" :class="{ 'result-safe': showSafe }">
          <div class="result-main">
            <span class="result-name">{{ item.recette.nom }}</span>
            <span v-if="item.recette.categorie" class="result-cat">{{ item.recette.categorie }}</span>
          </div>
          <div v-if="!showSafe && 'matchedIngredients' in item" class="result-ingredients">
            <span
              v-for="ing in (item as { matchedIngredients: string[] }).matchedIngredients"
              :key="ing"
              class="ingredient-badge"
            >
              {{ ing }}
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

.search-wrapper {
  position: relative;
  margin-bottom: 24px;
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

.suggestions {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  z-index: 50;
  background: var(--bg-surface);
  border: 2px solid var(--color-primary);
  border-top: none;
  border-radius: 0 0 var(--radius-md) var(--radius-md);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
  max-height: 320px;
  overflow-y: auto;
}
.suggestion-item {
  display: block;
  width: 100%;
  text-align: left;
  padding: 14px 20px;
  font-size: 17px;
  border: none;
  background: none;
  color: var(--text-primary);
  cursor: pointer;
  border-bottom: 1px solid var(--border);
}
.suggestion-item:last-child {
  border-bottom: none;
}
.suggestion-item:hover,
.suggestion-item:focus {
  background: #fff7ed;
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
  margin-bottom: 6px;
}
.result-name {
  font-size: 16px;
  font-weight: 600;
}
.result-cat {
  font-size: 13px;
  color: var(--text-tertiary);
}
.result-ingredients {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}
.ingredient-badge {
  background: #fef3c7;
  color: #92400e;
  padding: 4px 10px;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
}
</style>
