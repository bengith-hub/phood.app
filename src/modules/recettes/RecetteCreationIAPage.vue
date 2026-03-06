<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useRecettesStore } from '@/stores/recettes'
import { useIngredientsStore } from '@/stores/ingredients'
import { supabase } from '@/lib/supabase'
import type {
  IngredientRestaurant,
  RecetteType,
  PrixVenteCanal,
} from '@/types/database'

const router = useRouter()
const recettesStore = useRecettesStore()
const ingredientsStore = useIngredientsStore()

// --- Step 1: Paste raw text ---
const rawText = ref('')
const analyzing = ref(false)
const analyzeError = ref<string | null>(null)

// --- Step 2: Parsed result ---
interface ParsedIngredient {
  nom_extrait: string
  quantite: number
  unite: string
  matched_id: string | null
  matched_nom: string | null
  confiance: number
  createNew: boolean
}

const parsed = ref(false)
const parsedNom = ref('')
const parsedPortions = ref(1)
const parsedIngredients = ref<ParsedIngredient[]>([])
const parsedInstructions = ref('')

// --- Step 3: Editable form (same layout as RecetteDetailPage) ---
const type = ref<RecetteType>('recette')
const categorie = ref('')
const coutEmballage = ref(0)
const prixSurPlaceTTC = ref(0)
const prixSurPlaceTVA = ref(10)
const prixEmporterTTC = ref(0)
const prixEmporterTVA = ref(10)
const prixLivraisonTTC = ref(0)
const prixLivraisonTVA = ref(10)

const saving = ref(false)
const saveError = ref<string | null>(null)

// --- Computed ---

function getIngredientCost(id: string): number {
  return ingredientsStore.getById(id)?.cout_unitaire ?? 0
}

const coutMatiere = computed(() => {
  let total = 0
  for (const pi of parsedIngredients.value) {
    if (pi.matched_id) {
      total += pi.quantite * getIngredientCost(pi.matched_id)
    }
  }
  return total
})

const coutParPortion = computed(() =>
  parsedPortions.value > 0 ? coutMatiere.value / parsedPortions.value : 0
)

const nbMatched = computed(() =>
  parsedIngredients.value.filter(pi => pi.matched_id !== null).length
)

const nbUnmatched = computed(() =>
  parsedIngredients.value.filter(pi => pi.matched_id === null && !pi.createNew).length
)

// --- Dropdown for re-matching unmatched ingredients ---
const activeDropdownIdx = ref<number | null>(null)
const dropdownSearch = ref('')

const dropdownResults = computed(() => {
  const q = dropdownSearch.value.toLowerCase()
  if (!q) return ingredientsStore.actifs.slice(0, 15)
  return ingredientsStore.search(q).slice(0, 15)
})

function openMatchDropdown(idx: number) {
  activeDropdownIdx.value = idx
  dropdownSearch.value = parsedIngredients.value[idx].nom_extrait
}

function selectMatch(idx: number, ing: IngredientRestaurant) {
  parsedIngredients.value[idx].matched_id = ing.id
  parsedIngredients.value[idx].matched_nom = ing.nom
  parsedIngredients.value[idx].confiance = 1
  parsedIngredients.value[idx].createNew = false
  activeDropdownIdx.value = null
  dropdownSearch.value = ''
}

function markCreateNew(idx: number) {
  parsedIngredients.value[idx].createNew = true
  parsedIngredients.value[idx].matched_id = null
  parsedIngredients.value[idx].matched_nom = null
  activeDropdownIdx.value = null
}

function closeDropdown() {
  activeDropdownIdx.value = null
  dropdownSearch.value = ''
}

// --- IA Analysis ---
async function handleAnalyze() {
  if (!rawText.value.trim()) return

  analyzing.value = true
  analyzeError.value = null

  try {
    // Prepare the existing ingredient list for context
    const ingredientNames = ingredientsStore.actifs.map(i => ({
      id: i.id,
      nom: i.nom,
      unite: i.unite_stock,
    }))

    const response = await fetch('/.netlify/functions/parse-recette', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        texte_recette: rawText.value,
        ingredients_existants: ingredientNames,
      }),
    })

    if (!response.ok) {
      const errBody = await response.json().catch(() => ({ error: 'Erreur serveur' }))
      throw new Error(errBody.error || `HTTP ${response.status}`)
    }

    const result = await response.json()

    // Populate parsed data
    parsedNom.value = result.nom || ''
    parsedPortions.value = result.nb_portions || 1
    parsedInstructions.value = result.instructions || ''

    parsedIngredients.value = (result.ingredients || []).map((ing: {
      nom_extrait: string
      quantite: number
      unite: string
      matched_id: string | null
      matched_nom: string | null
      confiance: number
    }) => ({
      nom_extrait: ing.nom_extrait,
      quantite: ing.quantite ?? 0,
      unite: ing.unite ?? 'kg',
      matched_id: ing.matched_id ?? null,
      matched_nom: ing.matched_nom ?? null,
      confiance: ing.confiance ?? 0,
      createNew: false,
    }))

    parsed.value = true
  } catch (e: unknown) {
    analyzeError.value = e instanceof Error ? e.message : 'Erreur analyse IA'
  } finally {
    analyzing.value = false
  }
}

// --- Save ---
async function handleSave() {
  if (!parsedNom.value.trim()) return

  saving.value = true
  saveError.value = null

  try {
    // Step 1: Create new ingredients if needed
    for (const pi of parsedIngredients.value) {
      if (pi.createNew && !pi.matched_id) {
        const { data, error } = await supabase
          .from('ingredients_restaurant')
          .insert({
            nom: pi.nom_extrait,
            unite_stock: pi.unite,
            categorie: null,
            allergenes: [],
            contient: null,
            cout_unitaire: 0,
            actif: true,
          })
          .select('id')
          .single()
        if (error) throw error
        pi.matched_id = data.id
        pi.matched_nom = pi.nom_extrait
      }
    }

    // Step 2: Build prix_vente
    const prixVente: Record<string, PrixVenteCanal> = {}
    if (prixSurPlaceTTC.value > 0) {
      prixVente.sur_place = { ttc: prixSurPlaceTTC.value, tva: prixSurPlaceTVA.value }
    }
    if (prixEmporterTTC.value > 0) {
      prixVente.emporter = { ttc: prixEmporterTTC.value, tva: prixEmporterTVA.value }
    }
    if (prixLivraisonTTC.value > 0) {
      prixVente.livraison = { ttc: prixLivraisonTTC.value, tva: prixLivraisonTVA.value }
    }

    // Step 3: Create recette
    const { data: recette, error: recError } = await supabase
      .from('recettes')
      .insert({
        nom: parsedNom.value,
        type: type.value,
        categorie: categorie.value || null,
        description: null,
        instructions: parsedInstructions.value || null,
        nb_portions: parsedPortions.value,
        cout_matiere: coutMatiere.value,
        cout_emballage: coutEmballage.value || null,
        prix_vente: Object.keys(prixVente).length > 0 ? prixVente : null,
        actif: true,
      })
      .select('id')
      .single()
    if (recError) throw recError

    // Step 4: Create ingredient lines
    const lignes = parsedIngredients.value
      .filter(pi => pi.matched_id)
      .map(pi => ({
        recette_id: recette.id,
        ingredient_id: pi.matched_id,
        sous_recette_id: null,
        quantite: pi.quantite,
        unite: pi.unite,
      }))

    if (lignes.length > 0) {
      const { error: riError } = await supabase
        .from('recette_ingredients')
        .insert(lignes)
      if (riError) throw riError
    }

    // Refresh stores
    await Promise.all([
      recettesStore.fetchAll(),
      ingredientsStore.fetchAll(),
    ])

    // Navigate to the new recipe
    router.push(`/recettes/${recette.id}`)
  } catch (e: unknown) {
    saveError.value = e instanceof Error ? e.message : 'Erreur sauvegarde'
  } finally {
    saving.value = false
  }
}

function handleReset() {
  parsed.value = false
  rawText.value = ''
  parsedNom.value = ''
  parsedPortions.value = 1
  parsedIngredients.value = []
  parsedInstructions.value = ''
  analyzeError.value = null
  saveError.value = null
}

const UNITE_OPTIONS = ['kg', 'g', 'L', 'mL', 'cl', 'unite', 'piece', 'botte', 'cs', 'cc']
const TVA_OPTIONS = [5.5, 10, 20]

onMounted(async () => {
  await Promise.all([
    recettesStore.fetchAll(),
    ingredientsStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="ia-page" @click="closeDropdown">
    <!-- Header -->
    <div class="page-header">
      <div>
        <button class="btn-back" @click="router.push('/recettes')">
          &larr; Retour
        </button>
        <h1>Cr&eacute;ation rapide par IA</h1>
        <p class="subtitle">
          Collez un texte de recette (site web, carnet, etc.) et l'IA l'analysera automatiquement.
        </p>
      </div>
    </div>

    <!-- Step 1: Raw text input -->
    <section v-if="!parsed" class="form-section">
      <h2>Texte de la recette</h2>
      <textarea
        v-model="rawText"
        rows="12"
        class="input textarea raw-input"
        placeholder="Collez ici le texte complet de la recette...

Exemple :
Bowl Poke Saumon (4 portions)
- 400g riz vinaigr&eacute;
- 300g saumon frais
- 1 avocat
- 100g edamame
- 2 cs sauce soja
- 1 cs huile de s&eacute;same
..."
      />

      <div v-if="analyzeError" class="error-banner">{{ analyzeError }}</div>

      <div class="step-actions">
        <button
          class="btn-primary btn-lg"
          :disabled="analyzing || !rawText.trim()"
          @click="handleAnalyze"
        >
          {{ analyzing ? 'Analyse en cours...' : 'Analyser avec IA' }}
        </button>
      </div>

      <div v-if="analyzing" class="loading-overlay">
        <div class="spinner"></div>
        <p>Analyse du texte par l'IA...</p>
        <p class="loading-sub">Extraction des ingr&eacute;dients et matching avec votre base</p>
      </div>
    </section>

    <!-- Step 2: Parsed result -->
    <template v-if="parsed">
      <!-- Recipe info -->
      <section class="form-section">
        <div class="section-header">
          <h2>R&eacute;sultat de l'analyse</h2>
          <button class="btn-outline" @click="handleReset">Recommencer</button>
        </div>

        <div class="match-summary">
          <span class="match-ok">{{ nbMatched }} match&eacute;s</span>
          <span v-if="nbUnmatched > 0" class="match-warn">{{ nbUnmatched }} non trouv&eacute;s</span>
        </div>

        <div class="form-grid">
          <div class="field full">
            <label>Nom de la recette</label>
            <input v-model="parsedNom" type="text" class="input" />
          </div>
          <div class="field">
            <label>Type</label>
            <select v-model="type" class="input">
              <option value="recette">Recette (plat)</option>
              <option value="sous_recette">Sous-recette</option>
            </select>
          </div>
          <div class="field">
            <label>Cat&eacute;gorie</label>
            <input v-model="categorie" type="text" placeholder="Ex: Bowls, Desserts..." class="input" />
          </div>
          <div class="field">
            <label>Nb portions</label>
            <input v-model.number="parsedPortions" type="number" min="1" inputmode="numeric" class="input" />
          </div>
          <div class="field">
            <label>Co&ucirc;t emballage (&euro;)</label>
            <input v-model.number="coutEmballage" type="number" min="0" step="0.01" inputmode="decimal" class="input" />
          </div>
        </div>
      </section>

      <!-- Parsed ingredients -->
      <section class="form-section">
        <h2>Ingr&eacute;dients extraits</h2>

        <div class="parsed-list">
          <div
            v-for="(pi, idx) in parsedIngredients"
            :key="idx"
            class="parsed-row"
            :class="{
              matched: pi.matched_id,
              unmatched: !pi.matched_id && !pi.createNew,
              'create-new': pi.createNew,
            }"
          >
            <!-- Status indicator -->
            <span class="status-dot" :class="{
              green: pi.matched_id,
              orange: !pi.matched_id && !pi.createNew,
              blue: pi.createNew,
            }"></span>

            <!-- Original name from IA -->
            <div class="parsed-original">
              <span class="parsed-name">{{ pi.nom_extrait }}</span>
              <span v-if="pi.matched_nom" class="parsed-match">
                &rarr; {{ pi.matched_nom }}
                <span class="confiance" :class="{
                  high: pi.confiance >= 0.8,
                  medium: pi.confiance >= 0.5 && pi.confiance < 0.8,
                  low: pi.confiance < 0.5,
                }">{{ (pi.confiance * 100).toFixed(0) }}%</span>
              </span>
              <span v-else-if="pi.createNew" class="parsed-new">
                &rarr; Cr&eacute;er &laquo; {{ pi.nom_extrait }} &raquo;
              </span>
              <span v-else class="parsed-unmatched">Non trouv&eacute;</span>
            </div>

            <!-- Quantity -->
            <input
              v-model.number="pi.quantite"
              type="number"
              min="0"
              step="0.01"
              inputmode="decimal"
              class="ing-qty"
            />

            <!-- Unit -->
            <select v-model="pi.unite" class="input input-sm">
              <option v-for="u in UNITE_OPTIONS" :key="u" :value="u">{{ u }}</option>
            </select>

            <!-- Actions for unmatched -->
            <div class="parsed-actions" @click.stop>
              <button
                v-if="!pi.matched_id"
                class="btn-match"
                @click="openMatchDropdown(idx)"
              >
                Associer
              </button>
              <button
                v-if="!pi.matched_id && !pi.createNew"
                class="btn-new-ing"
                @click="markCreateNew(idx)"
              >
                Cr&eacute;er
              </button>
              <button
                v-if="pi.matched_id || pi.createNew"
                class="btn-rematch"
                @click="openMatchDropdown(idx)"
                title="Re-associer"
              >
                Changer
              </button>

              <!-- Match dropdown -->
              <div v-if="activeDropdownIdx === idx" class="match-dropdown" @click.stop>
                <input
                  v-model="dropdownSearch"
                  type="text"
                  placeholder="Rechercher..."
                  class="input input-dropdown"
                  autofocus
                />
                <div class="match-dropdown-list">
                  <button
                    v-for="ing in dropdownResults"
                    :key="ing.id"
                    class="dropdown-item"
                    @click="selectMatch(idx, ing)"
                  >
                    {{ ing.nom }}
                    <span class="dd-meta">{{ ing.cout_unitaire.toFixed(2) }} &euro;/{{ ing.unite_stock }}</span>
                  </button>
                  <div v-if="dropdownResults.length === 0" class="empty-small">
                    Aucun r&eacute;sultat
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Cost summary -->
        <div class="cost-summary">
          <div class="cost-row">
            <span>Co&ucirc;t mati&egrave;re total (ingr&eacute;dients match&eacute;s)</span>
            <strong>{{ coutMatiere.toFixed(2) }} &euro;</strong>
          </div>
          <div class="cost-row">
            <span>Co&ucirc;t par portion ({{ parsedPortions }} portions)</span>
            <strong>{{ coutParPortion.toFixed(2) }} &euro;</strong>
          </div>
        </div>
      </section>

      <!-- Instructions -->
      <section v-if="parsedInstructions" class="form-section">
        <h2>Instructions extraites</h2>
        <textarea
          v-model="parsedInstructions"
          rows="6"
          class="input textarea"
        />
      </section>

      <!-- Prix de vente (optional) -->
      <section class="form-section">
        <h2>Prix de vente (optionnel)</h2>
        <div class="prix-canal-grid">
          <div class="prix-canal-card">
            <h3>Sur place</h3>
            <div class="prix-fields">
              <div class="field">
                <label>Prix TTC (&euro;)</label>
                <input v-model.number="prixSurPlaceTTC" type="number" min="0" step="0.1" inputmode="decimal" class="input" />
              </div>
              <div class="field">
                <label>TVA %</label>
                <select v-model.number="prixSurPlaceTVA" class="input">
                  <option v-for="t in TVA_OPTIONS" :key="t" :value="t">{{ t }}%</option>
                </select>
              </div>
            </div>
          </div>
          <div class="prix-canal-card">
            <h3>&Agrave; emporter</h3>
            <div class="prix-fields">
              <div class="field">
                <label>Prix TTC (&euro;)</label>
                <input v-model.number="prixEmporterTTC" type="number" min="0" step="0.1" inputmode="decimal" class="input" />
              </div>
              <div class="field">
                <label>TVA %</label>
                <select v-model.number="prixEmporterTVA" class="input">
                  <option v-for="t in TVA_OPTIONS" :key="t" :value="t">{{ t }}%</option>
                </select>
              </div>
            </div>
          </div>
          <div class="prix-canal-card">
            <h3>Livraison</h3>
            <div class="prix-fields">
              <div class="field">
                <label>Prix TTC (&euro;)</label>
                <input v-model.number="prixLivraisonTTC" type="number" min="0" step="0.1" inputmode="decimal" class="input" />
              </div>
              <div class="field">
                <label>TVA %</label>
                <select v-model.number="prixLivraisonTVA" class="input">
                  <option v-for="t in TVA_OPTIONS" :key="t" :value="t">{{ t }}%</option>
                </select>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- Save bar -->
      <div v-if="saveError" class="error-banner">{{ saveError }}</div>

      <div class="actions-bar">
        <button class="btn-secondary" @click="handleReset">Recommencer</button>
        <button
          class="btn-primary"
          :disabled="saving || !parsedNom.trim()"
          @click="handleSave"
        >
          {{ saving ? 'Sauvegarde...' : 'Cr&eacute;er la recette' }}
        </button>
      </div>
    </template>
  </div>
</template>

<style scoped>
.ia-page {
  max-width: 900px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 24px;
}

.btn-back {
  border: none;
  background: none;
  font-size: 16px;
  color: var(--color-primary);
  cursor: pointer;
  padding: 0;
  margin-bottom: 8px;
}

h1 {
  font-size: 28px;
  margin-bottom: 8px;
}

.subtitle {
  font-size: 16px;
  color: var(--text-secondary);
}

/* Sections */
.form-section {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 24px;
  margin-bottom: 16px;
}

.form-section h2 {
  font-size: 20px;
  margin-bottom: 16px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.section-header h2 {
  margin-bottom: 0;
}

/* Form */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.field {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field.full {
  grid-column: 1 / -1;
}

.field label {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
}

.input {
  height: 48px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 14px;
  font-size: 16px;
  background: var(--bg-surface);
  width: 100%;
  box-sizing: border-box;
}

.input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.input.textarea {
  height: auto;
  padding: 12px 14px;
  resize: vertical;
  font-family: inherit;
}

.input-sm {
  width: 90px;
  flex-shrink: 0;
}

.raw-input {
  font-size: 16px;
  line-height: 1.6;
  min-height: 200px;
}

/* Step actions */
.step-actions {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.btn-lg {
  padding: 16px 48px;
  font-size: 18px;
}

/* Loading overlay */
.loading-overlay {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 40px;
  gap: 12px;
}

.spinner {
  width: 48px;
  height: 48px;
  border: 4px solid var(--border);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.loading-overlay p {
  font-size: 16px;
  font-weight: 600;
}

.loading-sub {
  font-size: 14px !important;
  color: var(--text-tertiary);
  font-weight: 400 !important;
}

/* Match summary */
.match-summary {
  display: flex;
  gap: 16px;
  margin-bottom: 16px;
  font-size: 15px;
  font-weight: 600;
}

.match-ok {
  color: var(--color-success);
}

.match-warn {
  color: var(--color-warning);
}

/* Parsed list */
.parsed-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 16px;
}

.parsed-row {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--bg-main);
  border-radius: var(--radius-sm);
  padding: 10px 14px;
  border-left: 4px solid transparent;
}

.parsed-row.matched {
  border-left-color: var(--color-success);
}

.parsed-row.unmatched {
  border-left-color: var(--color-warning);
}

.parsed-row.create-new {
  border-left-color: #6366f1;
}

/* Status dot */
.status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}

.status-dot.green { background: var(--color-success); }
.status-dot.orange { background: var(--color-warning); }
.status-dot.blue { background: #6366f1; }

.parsed-original {
  flex: 1;
  min-width: 0;
}

.parsed-name {
  font-size: 15px;
  font-weight: 600;
  display: block;
}

.parsed-match {
  font-size: 13px;
  color: var(--color-success);
  display: block;
}

.parsed-new {
  font-size: 13px;
  color: #6366f1;
  display: block;
}

.parsed-unmatched {
  font-size: 13px;
  color: var(--color-warning);
  display: block;
}

.confiance {
  font-size: 11px;
  padding: 1px 5px;
  border-radius: 4px;
  margin-left: 4px;
}

.confiance.high { background: #dcfce7; color: #166534; }
.confiance.medium { background: #fef3c7; color: #92400e; }
.confiance.low { background: #fecaca; color: #991b1b; }

.ing-qty {
  width: 80px;
  height: 40px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  text-align: center;
  font-size: 16px;
  font-weight: 600;
  background: var(--bg-surface);
  flex-shrink: 0;
  -moz-appearance: textfield;
}

.ing-qty::-webkit-outer-spin-button,
.ing-qty::-webkit-inner-spin-button {
  -webkit-appearance: none;
}

/* Parsed actions */
.parsed-actions {
  display: flex;
  gap: 6px;
  flex-shrink: 0;
  position: relative;
}

.btn-match,
.btn-new-ing,
.btn-rematch {
  padding: 6px 12px;
  border-radius: var(--radius-sm);
  border: 1px solid var(--border);
  background: var(--bg-surface);
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}

.btn-match { color: var(--color-primary); border-color: var(--color-primary); }
.btn-new-ing { color: #6366f1; border-color: #6366f1; }
.btn-rematch { color: var(--text-tertiary); }

/* Match dropdown */
.match-dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  width: 300px;
  background: var(--bg-surface);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
  z-index: 50;
  margin-top: 4px;
}

.input-dropdown {
  border: none;
  border-bottom: 2px solid var(--border);
  border-radius: var(--radius-md) var(--radius-md) 0 0;
}

.match-dropdown-list {
  max-height: 200px;
  overflow-y: auto;
}

.dropdown-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 10px 14px;
  border: none;
  background: none;
  font-size: 14px;
  cursor: pointer;
  text-align: left;
}

.dropdown-item:active {
  background: var(--bg-main);
}

.dd-meta {
  font-size: 12px;
  color: var(--text-tertiary);
}

.empty-small {
  font-size: 14px;
  color: var(--text-tertiary);
  padding: 12px;
  text-align: center;
}

/* Cost summary */
.cost-summary {
  background: var(--bg-main);
  border-radius: var(--radius-md);
  padding: 16px;
  margin-top: 16px;
}

.cost-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 6px 0;
  font-size: 16px;
}

.cost-row strong {
  font-size: 18px;
  color: var(--color-primary);
}

/* Prix de vente */
.prix-canal-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 16px;
}

.prix-canal-card {
  background: var(--bg-main);
  border-radius: var(--radius-md);
  padding: 16px;
}

.prix-canal-card h3 {
  font-size: 16px;
  margin-bottom: 12px;
}

.prix-fields {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

/* Error banner */
.error-banner {
  background: #fef2f2;
  color: #991b1b;
  padding: 12px 16px;
  border-radius: var(--radius-md);
  margin-bottom: 16px;
  font-size: 15px;
  font-weight: 600;
}

/* Buttons */
.btn-primary {
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 14px 28px;
  font-size: 17px;
  font-weight: 700;
  cursor: pointer;
}

.btn-primary:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.btn-secondary {
  background: var(--bg-surface);
  color: var(--text-primary);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 14px 28px;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
}

.btn-outline {
  background: none;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
}

.actions-bar {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 8px;
  padding-top: 20px;
  border-top: 1px solid var(--border);
  position: sticky;
  bottom: 0;
  background: var(--bg-main);
  padding-bottom: 16px;
}

/* Responsive */
@media (max-width: 700px) {
  .form-grid {
    grid-template-columns: 1fr;
  }

  .prix-canal-grid {
    grid-template-columns: 1fr;
  }

  .parsed-row {
    flex-wrap: wrap;
  }

  .match-dropdown {
    width: 260px;
  }
}
</style>
