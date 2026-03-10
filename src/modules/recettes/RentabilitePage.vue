<script setup lang="ts">
import { ref, computed, onMounted, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useRecettesStore } from '@/stores/recettes'
import { useIngredientsStore } from '@/stores/ingredients'
import type { Recette, CanalVente } from '@/types/database'

const router = useRouter()
const recettesStore = useRecettesStore()
const ingredientsStore = useIngredientsStore()

// --- Uber Eats commission tiers ---
interface CommissionTier {
  label: string
  standard: number
  uberOne: number
}

const UBER_TIERS: Record<string, CommissionTier> = {
  marketplace: { label: 'Marketplace', standard: 0.30, uberOne: 0.33 },
  aggregateur: { label: 'Agregateur', standard: 0.15, uberOne: 0.18 },
  click_collect: { label: 'Click & Collect', standard: 0.15, uberOne: 0.18 },
  preferentiel: { label: 'Preferentiel', standard: 0.26, uberOne: 0.28 },
}

const selectedTier = ref<string>('marketplace')
const useUberOneRate = ref(true) // Worst-case by default

const COMMISSION_LIVRAISON_PCT = computed(() => {
  const tier = UBER_TIERS[selectedTier.value]!
  return useUberOneRate.value ? tier.uberOne : tier.standard
})

// --- Sort and filter ---
type SortKey = 'nom' | 'marge_pct_sp' | 'marge_pct_emp' | 'marge_pct_liv' | 'cout_matiere'
const sortBy = ref<SortKey>('nom')
const sortDir = ref<'asc' | 'desc'>('asc')
const searchQuery = ref('')
const selectedCanal = ref<CanalVente | 'tous'>('tous')

// --- Price simulation overrides ---
// Map: recetteId -> canal -> simulated TTC price
const priceOverrides = reactive<Record<string, Record<string, number>>>({})

function getSimulatedPrice(recetteId: string, canal: CanalVente, originalTtc: number): number {
  return priceOverrides[recetteId]?.[canal] ?? originalTtc
}

function setSimulatedPrice(recetteId: string, canal: CanalVente, value: number) {
  if (!priceOverrides[recetteId]) {
    priceOverrides[recetteId] = {}
  }
  priceOverrides[recetteId][canal] = value
}

function isOverridden(recetteId: string, canal: CanalVente, originalTtc: number): boolean {
  const override = priceOverrides[recetteId]?.[canal]
  return override !== undefined && override !== originalTtc
}

function resetPrice(recetteId: string, canal: CanalVente, originalTtc: number) {
  if (priceOverrides[recetteId]) {
    priceOverrides[recetteId][canal] = originalTtc
  }
}

// --- Margin calculations ---
function getIngredientCost(id: string): number {
  return ingredientsStore.getById(id)?.cout_unitaire ?? 0
}

interface RecetteAnalysis {
  recette: Recette
  coutMatiere: number
  coutEmballage: number
  coutTotal: number
  // Per channel
  surPlace: ChannelAnalysis | null
  emporter: ChannelAnalysis | null
  livraison: ChannelAnalysis | null
}

interface ChannelAnalysis {
  prixTTC: number
  tva: number
  prixHT: number
  commission: number      // in EUR
  commissionPct: number   // rate applied (0, 0.33, etc.)
  revenuNet: number       // prixHT - commission
  margeBrute: number      // revenuNet - coutTotal
  margePct: number        // margeBrute / prixHT * 100
}

function computeChannel(
  recetteId: string,
  canal: CanalVente,
  prixVenteCanal: { ttc: number; tva: number } | undefined,
  coutTotal: number
): ChannelAnalysis | null {
  if (!prixVenteCanal || prixVenteCanal.ttc <= 0) return null

  const originalTtc = prixVenteCanal.ttc
  const prixTTC = getSimulatedPrice(recetteId, canal, originalTtc)
  const tva = prixVenteCanal.tva
  const prixHT = prixTTC / (1 + tva / 100)

  // Commission: livraison only, on TTC
  let commissionPct = 0
  if (canal === 'livraison') {
    commissionPct = COMMISSION_LIVRAISON_PCT.value
  }
  const commission = prixTTC * commissionPct

  // Revenu net = Prix HT - commission
  // NOTE: Commission is on TTC but deducted from HT revenue (matching CDC formulas)
  const revenuNet = prixHT - commission
  const margeBrute = revenuNet - coutTotal
  const margePct = prixHT > 0 ? (margeBrute / prixHT) * 100 : 0

  return {
    prixTTC,
    tva,
    prixHT,
    commission,
    commissionPct,
    revenuNet,
    margeBrute,
    margePct,
  }
}

const analyses = computed<RecetteAnalysis[]>(() => {
  const results: RecetteAnalysis[] = []

  for (const recette of recettesStore.plats) {
    const coutMatiere = recettesStore.calculateCost(recette.id, getIngredientCost)
    const coutPerPortion = recette.nb_portions > 0 ? coutMatiere / recette.nb_portions : coutMatiere
    const coutEmballage = recette.cout_emballage ?? 0
    const coutTotal = coutPerPortion + coutEmballage

    results.push({
      recette,
      coutMatiere: coutPerPortion,
      coutEmballage,
      coutTotal,
      surPlace: computeChannel(recette.id, 'sur_place', recette.prix_vente?.sur_place, coutTotal),
      emporter: computeChannel(recette.id, 'emporter', recette.prix_vente?.emporter, coutTotal),
      livraison: computeChannel(recette.id, 'livraison', recette.prix_vente?.livraison, coutTotal),
    })
  }

  return results
})

// Filtered and sorted
const filteredAnalyses = computed(() => {
  let list = analyses.value

  // Text search
  const q = searchQuery.value.toLowerCase()
  if (q) {
    list = list.filter(a =>
      a.recette.nom.toLowerCase().includes(q) ||
      a.recette.categorie?.toLowerCase().includes(q)
    )
  }

  // Canal filter: only show recipes that have this canal defined
  if (selectedCanal.value !== 'tous') {
    list = list.filter(a => {
      if (selectedCanal.value === 'sur_place') return a.surPlace !== null
      if (selectedCanal.value === 'emporter') return a.emporter !== null
      if (selectedCanal.value === 'livraison') return a.livraison !== null
      return true
    })
  }

  // Sort
  const dir = sortDir.value === 'asc' ? 1 : -1
  list = [...list].sort((a, b) => {
    switch (sortBy.value) {
      case 'nom':
        return dir * a.recette.nom.localeCompare(b.recette.nom)
      case 'cout_matiere':
        return dir * (a.coutMatiere - b.coutMatiere)
      case 'marge_pct_sp':
        return dir * ((a.surPlace?.margePct ?? -999) - (b.surPlace?.margePct ?? -999))
      case 'marge_pct_emp':
        return dir * ((a.emporter?.margePct ?? -999) - (b.emporter?.margePct ?? -999))
      case 'marge_pct_liv':
        return dir * ((a.livraison?.margePct ?? -999) - (b.livraison?.margePct ?? -999))
      default:
        return 0
    }
  })

  return list
})

// Summary averages
function avgMarge(getter: (a: RecetteAnalysis) => ChannelAnalysis | null): number {
  const values = filteredAnalyses.value
    .map(getter)
    .filter((c): c is ChannelAnalysis => c !== null)
  if (values.length === 0) return 0
  return values.reduce((sum, c) => sum + c.margePct, 0) / values.length
}

const avgMargeSurPlace = computed(() => avgMarge(a => a.surPlace))
const avgMargeEmporter = computed(() => avgMarge(a => a.emporter))
const avgMargeLivraison = computed(() => avgMarge(a => a.livraison))

// Price cap alert: Uber Eats rule — livraison price cannot exceed sur_place × 1.15
const PRICE_CAP_FACTOR = 1.15
const priceCapAlerts = computed(() => {
  return filteredAnalyses.value.filter(a => {
    if (!a.livraison || !a.surPlace) return false
    const livTtc = getSimulatedPrice(a.recette.id, 'livraison', a.livraison.prixTTC)
    const spTtc = getSimulatedPrice(a.recette.id, 'sur_place', a.surPlace.prixTTC)
    return livTtc > spTtc * PRICE_CAP_FACTOR
  })
})

function isPriceCapped(a: RecetteAnalysis): boolean {
  if (!a.livraison || !a.surPlace) return false
  const livTtc = getSimulatedPrice(a.recette.id, 'livraison', a.livraison.prixTTC)
  const spTtc = getSimulatedPrice(a.recette.id, 'sur_place', a.surPlace.prixTTC)
  return livTtc > spTtc * PRICE_CAP_FACTOR
}

function priceCapMax(a: RecetteAnalysis): string {
  if (!a.surPlace) return '-'
  const spTtc = getSimulatedPrice(a.recette.id, 'sur_place', a.surPlace.prixTTC)
  return (spTtc * PRICE_CAP_FACTOR).toFixed(2) + ' €'
}

function toggleSort(key: SortKey) {
  if (sortBy.value === key) {
    sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortBy.value = key
    sortDir.value = key === 'nom' ? 'asc' : 'desc'
  }
}

function sortIndicator(key: SortKey): string {
  if (sortBy.value !== key) return ''
  return sortDir.value === 'asc' ? ' \u25B2' : ' \u25BC'
}

function margeClass(pct: number): string {
  if (pct >= 65) return 'marge-good'
  if (pct >= 55) return 'marge-warn'
  return 'marge-bad'
}

function formatPct(value: number): string {
  return value.toFixed(1) + '%'
}

function formatEuro(value: number): string {
  return value.toFixed(2) + ' \u20AC'
}

onMounted(async () => {
  await Promise.all([
    recettesStore.fetchAll(),
    ingredientsStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="rentabilite-page">
    <!-- Header -->
    <div class="page-header">
      <div>
        <button class="btn-back" @click="router.push('/recettes')">
          &larr; Retour
        </button>
        <h1>Rentabilit&eacute; &amp; Simulateur</h1>
        <p class="subtitle">
          Analyse des marges par canal de vente. Modifiez les prix pour simuler l'impact.
        </p>
      </div>
    </div>

    <!-- Filters -->
    <div class="filters-bar">
      <input
        v-model="searchQuery"
        type="search"
        placeholder="Rechercher une recette..."
        class="search-input"
      />
      <div class="canal-tabs">
        <button :class="{ active: selectedCanal === 'tous' }" @click="selectedCanal = 'tous'">
          Tous
        </button>
        <button :class="{ active: selectedCanal === 'sur_place' }" @click="selectedCanal = 'sur_place'">
          Sur place
        </button>
        <button :class="{ active: selectedCanal === 'emporter' }" @click="selectedCanal = 'emporter'">
          Emporter
        </button>
        <button :class="{ active: selectedCanal === 'livraison' }" @click="selectedCanal = 'livraison'">
          Livraison
        </button>
      </div>
    </div>

    <!-- Summary row -->
    <div class="summary-bar">
      <div class="summary-item">
        <span class="summary-label">Marge moy. sur place</span>
        <span class="summary-value" :class="margeClass(avgMargeSurPlace)">
          {{ formatPct(avgMargeSurPlace) }}
        </span>
      </div>
      <div class="summary-item">
        <span class="summary-label">Marge moy. emporter</span>
        <span class="summary-value" :class="margeClass(avgMargeEmporter)">
          {{ formatPct(avgMargeEmporter) }}
        </span>
      </div>
      <div class="summary-item">
        <span class="summary-label">Marge moy. livraison</span>
        <span class="summary-value" :class="margeClass(avgMargeLivraison)">
          {{ formatPct(avgMargeLivraison) }}
        </span>
      </div>
      <div class="summary-item">
        <span class="summary-label">Recettes affich&eacute;es</span>
        <span class="summary-value neutral">{{ filteredAnalyses.length }}</span>
      </div>
    </div>

    <!-- Commission tier selector -->
    <div class="commission-selector">
      <label>Commission Uber Eats :</label>
      <select v-model="selectedTier" class="tier-select">
        <option v-for="(tier, key) in UBER_TIERS" :key="key" :value="key">
          {{ tier.label }} ({{ (tier.standard * 100).toFixed(0) }}% / {{ (tier.uberOne * 100).toFixed(0) }}%)
        </option>
      </select>
      <label class="uber-one-toggle">
        <input type="checkbox" v-model="useUberOneRate" />
        Uber One (pire cas)
      </label>
      <span class="commission-rate">
        {{ (COMMISSION_LIVRAISON_PCT * 100).toFixed(0) }}% sur TTC
      </span>
    </div>

    <!-- Price cap alert -->
    <div v-if="priceCapAlerts.length > 0" class="price-cap-alert">
      ⚠️ <strong>{{ priceCapAlerts.length }} recette{{ priceCapAlerts.length > 1 ? 's' : '' }}</strong>
      d&eacute;passe{{ priceCapAlerts.length > 1 ? 'nt' : '' }} le price cap Uber Eats (+{{ ((PRICE_CAP_FACTOR - 1) * 100).toFixed(0) }}% vs sur place)
      <div class="price-cap-list">
        <span v-for="a in priceCapAlerts" :key="a.recette.id" class="price-cap-item">
          {{ a.recette.nom }} (max {{ priceCapMax(a) }})
        </span>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="recettesStore.loading || ingredientsStore.loading" class="loading">
      Chargement...
    </div>

    <!-- Table -->
    <div v-else class="table-wrapper">
      <table class="rentabilite-table">
        <thead>
          <tr>
            <th class="th-sortable" @click="toggleSort('nom')">
              Recette{{ sortIndicator('nom') }}
            </th>
            <th class="th-sortable" @click="toggleSort('cout_matiere')">
              Co&ucirc;t mat.{{ sortIndicator('cout_matiere') }}
            </th>
            <th>Emball.</th>

            <!-- Sur place columns -->
            <template v-if="selectedCanal === 'tous' || selectedCanal === 'sur_place'">
              <th class="canal-header sp">Prix SP</th>
              <th class="th-sortable canal-header sp" @click="toggleSort('marge_pct_sp')">
                Marge SP{{ sortIndicator('marge_pct_sp') }}
              </th>
            </template>

            <!-- Emporter columns -->
            <template v-if="selectedCanal === 'tous' || selectedCanal === 'emporter'">
              <th class="canal-header emp">Prix EMP</th>
              <th class="th-sortable canal-header emp" @click="toggleSort('marge_pct_emp')">
                Marge EMP{{ sortIndicator('marge_pct_emp') }}
              </th>
            </template>

            <!-- Livraison columns -->
            <template v-if="selectedCanal === 'tous' || selectedCanal === 'livraison'">
              <th class="canal-header liv">Prix LIV</th>
              <th>Comm.</th>
              <th class="th-sortable canal-header liv" @click="toggleSort('marge_pct_liv')">
                Marge LIV{{ sortIndicator('marge_pct_liv') }}
              </th>
            </template>
          </tr>
        </thead>

        <tbody>
          <tr
            v-for="a in filteredAnalyses"
            :key="a.recette.id"
          >
            <!-- Nom -->
            <td class="td-nom">
              <span class="recette-nom" @click="router.push(`/recettes/${a.recette.id}`)">
                {{ a.recette.nom }}
              </span>
              <span v-if="a.recette.categorie" class="recette-cat">{{ a.recette.categorie }}</span>
            </td>

            <!-- Cout matiere -->
            <td class="td-num">{{ formatEuro(a.coutMatiere) }}</td>

            <!-- Emballage -->
            <td class="td-num">{{ a.coutEmballage > 0 ? formatEuro(a.coutEmballage) : '-' }}</td>

            <!-- Sur place -->
            <template v-if="selectedCanal === 'tous' || selectedCanal === 'sur_place'">
              <td v-if="a.surPlace" class="td-prix">
                <div class="prix-input-wrapper">
                  <input
                    :value="getSimulatedPrice(a.recette.id, 'sur_place', a.surPlace.prixTTC)"
                    @input="setSimulatedPrice(
                      a.recette.id,
                      'sur_place',
                      parseFloat(($event.target as HTMLInputElement).value) || 0
                    )"
                    type="number"
                    min="0"
                    step="0.1"
                    inputmode="decimal"
                    class="prix-sim-input"
                    :class="{ modified: isOverridden(a.recette.id, 'sur_place', a.recette.prix_vente?.sur_place?.ttc ?? 0) }"
                  />
                  <button
                    v-if="isOverridden(a.recette.id, 'sur_place', a.recette.prix_vente?.sur_place?.ttc ?? 0)"
                    class="btn-reset-prix"
                    @click="resetPrice(a.recette.id, 'sur_place', a.recette.prix_vente?.sur_place?.ttc ?? 0)"
                    title="R&eacute;initialiser"
                  >
                    &times;
                  </button>
                </div>
              </td>
              <td v-if="a.surPlace" class="td-marge" :class="margeClass(a.surPlace.margePct)">
                <span class="marge-value">{{ formatPct(a.surPlace.margePct) }}</span>
                <span class="marge-eur">{{ formatEuro(a.surPlace.margeBrute) }}</span>
              </td>
              <template v-else>
                <td class="td-empty">-</td>
                <td class="td-empty">-</td>
              </template>
            </template>

            <!-- Emporter -->
            <template v-if="selectedCanal === 'tous' || selectedCanal === 'emporter'">
              <td v-if="a.emporter" class="td-prix">
                <div class="prix-input-wrapper">
                  <input
                    :value="getSimulatedPrice(a.recette.id, 'emporter', a.emporter.prixTTC)"
                    @input="setSimulatedPrice(
                      a.recette.id,
                      'emporter',
                      parseFloat(($event.target as HTMLInputElement).value) || 0
                    )"
                    type="number"
                    min="0"
                    step="0.1"
                    inputmode="decimal"
                    class="prix-sim-input"
                    :class="{ modified: isOverridden(a.recette.id, 'emporter', a.recette.prix_vente?.emporter?.ttc ?? 0) }"
                  />
                  <button
                    v-if="isOverridden(a.recette.id, 'emporter', a.recette.prix_vente?.emporter?.ttc ?? 0)"
                    class="btn-reset-prix"
                    @click="resetPrice(a.recette.id, 'emporter', a.recette.prix_vente?.emporter?.ttc ?? 0)"
                    title="R&eacute;initialiser"
                  >
                    &times;
                  </button>
                </div>
              </td>
              <td v-if="a.emporter" class="td-marge" :class="margeClass(a.emporter.margePct)">
                <span class="marge-value">{{ formatPct(a.emporter.margePct) }}</span>
                <span class="marge-eur">{{ formatEuro(a.emporter.margeBrute) }}</span>
              </td>
              <template v-else>
                <td class="td-empty">-</td>
                <td class="td-empty">-</td>
              </template>
            </template>

            <!-- Livraison -->
            <template v-if="selectedCanal === 'tous' || selectedCanal === 'livraison'">
              <td v-if="a.livraison" class="td-prix">
                <div class="prix-input-wrapper">
                  <input
                    :value="getSimulatedPrice(a.recette.id, 'livraison', a.livraison.prixTTC)"
                    @input="setSimulatedPrice(
                      a.recette.id,
                      'livraison',
                      parseFloat(($event.target as HTMLInputElement).value) || 0
                    )"
                    type="number"
                    min="0"
                    step="0.1"
                    inputmode="decimal"
                    class="prix-sim-input"
                    :class="{ modified: isOverridden(a.recette.id, 'livraison', a.recette.prix_vente?.livraison?.ttc ?? 0) }"
                  />
                  <button
                    v-if="isOverridden(a.recette.id, 'livraison', a.recette.prix_vente?.livraison?.ttc ?? 0)"
                    class="btn-reset-prix"
                    @click="resetPrice(a.recette.id, 'livraison', a.recette.prix_vente?.livraison?.ttc ?? 0)"
                    title="R&eacute;initialiser"
                  >
                    &times;
                  </button>
                </div>
              </td>
              <td v-if="a.livraison" class="td-num td-commission">
                {{ formatEuro(a.livraison.commission) }}
              </td>
              <td v-if="a.livraison" class="td-marge" :class="[margeClass(a.livraison.margePct), { 'price-capped': isPriceCapped(a) }]">
                <span class="marge-value">{{ formatPct(a.livraison.margePct) }}</span>
                <span class="marge-eur">{{ formatEuro(a.livraison.margeBrute) }}</span>
              </td>
              <template v-else>
                <td class="td-empty">-</td>
                <td class="td-empty">-</td>
                <td class="td-empty">-</td>
              </template>
            </template>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Empty state -->
    <div v-if="!recettesStore.loading && filteredAnalyses.length === 0" class="empty">
      Aucune recette avec des prix de vente d&eacute;finis.
    </div>

    <!-- Legend -->
    <div class="legend">
      <div class="legend-item">
        <span class="legend-dot good"></span>
        <span>Marge &ge; 65%</span>
      </div>
      <div class="legend-item">
        <span class="legend-dot warn"></span>
        <span>Marge 55-65%</span>
      </div>
      <div class="legend-item">
        <span class="legend-dot bad"></span>
        <span>Marge &lt; 55%</span>
      </div>
      <div class="legend-sep"></div>
      <div class="legend-item">
        <span class="legend-modified"></span>
        <span>Prix simul&eacute; (modifi&eacute;)</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.rentabilite-page {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  margin-bottom: 20px;
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

/* Filters */
.filters-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.search-input {
  flex: 1;
  min-width: 200px;
  height: 48px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 16px;
  background: var(--bg-surface);
}

.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.canal-tabs {
  display: flex;
  gap: 4px;
  background: var(--bg-main);
  border-radius: var(--radius-md);
  padding: 4px;
}

.canal-tabs button {
  padding: 10px 16px;
  border: none;
  border-radius: var(--radius-sm);
  background: transparent;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
  white-space: nowrap;
}

.canal-tabs button.active {
  background: var(--bg-surface);
  color: var(--text-primary);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.08);
}

/* Summary */
.summary-bar {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 12px;
  margin-bottom: 12px;
}

.summary-item {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.summary-label {
  font-size: 13px;
  color: var(--text-tertiary);
  font-weight: 600;
}

.summary-value {
  font-size: 22px;
  font-weight: 700;
}

.summary-value.neutral {
  color: var(--text-primary);
}

/* Commission selector */
.commission-selector {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  font-size: 14px;
  color: var(--text-secondary);
  background: #fef3c7;
  padding: 8px 14px;
  border-radius: var(--radius-sm);
  margin-bottom: 16px;
  font-weight: 600;
}
.tier-select {
  height: 36px;
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 10px;
  font-size: 14px;
  font-weight: 600;
  background: white;
}
.uber-one-toggle {
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 500;
  cursor: pointer;
}
.uber-one-toggle input { cursor: pointer; }
.commission-rate {
  font-weight: 700;
  color: var(--color-primary);
}

/* Price cap alert */
.price-cap-alert {
  background: #fef2f2;
  border: 1px solid #fca5a5;
  border-radius: var(--radius-md);
  padding: 12px 16px;
  margin-bottom: 16px;
  font-size: 14px;
  color: #991b1b;
}

.price-cap-list {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 8px;
}

.price-cap-item {
  background: #fee2e2;
  padding: 3px 10px;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 600;
}

.price-capped {
  position: relative;
}

.price-capped::after {
  content: '⚠️';
  position: absolute;
  top: 2px;
  right: 4px;
  font-size: 12px;
}

/* Loading & empty */
.loading, .empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 40px;
  font-size: 16px;
}

/* Table */
.table-wrapper {
  overflow-x: auto;
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.rentabilite-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}

.rentabilite-table th {
  position: sticky;
  top: 0;
  background: var(--bg-surface);
  padding: 14px 12px;
  text-align: left;
  font-size: 12px;
  font-weight: 700;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid var(--border);
  white-space: nowrap;
}

.th-sortable {
  cursor: pointer;
  user-select: none;
}

.th-sortable:active {
  color: var(--color-primary);
}

.canal-header.sp { color: #166534; }
.canal-header.emp { color: #1e40af; }
.canal-header.liv { color: #9d174d; }

.rentabilite-table td {
  padding: 12px;
  border-bottom: 1px solid var(--border);
  vertical-align: middle;
}

.td-nom {
  min-width: 160px;
}

.recette-nom {
  font-weight: 600;
  font-size: 15px;
  cursor: pointer;
  color: var(--text-primary);
}

.recette-nom:active {
  color: var(--color-primary);
}

.recette-cat {
  display: block;
  font-size: 12px;
  color: var(--text-tertiary);
}

.td-num {
  text-align: right;
  white-space: nowrap;
  font-variant-numeric: tabular-nums;
}

.td-commission {
  color: var(--color-danger);
  font-weight: 600;
}

.td-empty {
  text-align: center;
  color: var(--text-tertiary);
}

/* Prix simulation input */
.td-prix {
  padding: 8px 6px;
}

.prix-input-wrapper {
  display: flex;
  align-items: center;
  gap: 2px;
}

.prix-sim-input {
  width: 80px;
  height: 36px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  text-align: right;
  font-size: 14px;
  font-weight: 600;
  padding: 0 8px;
  background: var(--bg-surface);
  -moz-appearance: textfield;
}

.prix-sim-input::-webkit-outer-spin-button,
.prix-sim-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}

.prix-sim-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.prix-sim-input.modified {
  border-color: #6366f1;
  background: #eef2ff;
}

.btn-reset-prix {
  width: 24px;
  height: 24px;
  border: none;
  background: none;
  color: var(--text-tertiary);
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

/* Marge cell */
.td-marge {
  text-align: right;
  padding: 8px 12px;
  border-radius: 0;
}

.marge-value {
  display: block;
  font-size: 16px;
  font-weight: 700;
}

.marge-eur {
  display: block;
  font-size: 12px;
  font-weight: 500;
  opacity: 0.7;
}

/* Marge color classes */
.marge-good { color: var(--color-success); }
.marge-warn { color: var(--color-warning); }
.marge-bad { color: var(--color-danger); }

.td-marge.marge-good { background: #f0fdf4; }
.td-marge.marge-warn { background: #fffbeb; }
.td-marge.marge-bad { background: #fef2f2; }

/* Legend */
.legend {
  display: flex;
  gap: 20px;
  align-items: center;
  padding: 16px 0;
  flex-wrap: wrap;
  font-size: 13px;
  color: var(--text-secondary);
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
}

.legend-dot {
  width: 12px;
  height: 12px;
  border-radius: 3px;
}

.legend-dot.good { background: var(--color-success); }
.legend-dot.warn { background: var(--color-warning); }
.legend-dot.bad { background: var(--color-danger); }

.legend-modified {
  width: 12px;
  height: 12px;
  border: 2px solid #6366f1;
  border-radius: 3px;
  background: #eef2ff;
}

.legend-sep {
  width: 1px;
  height: 16px;
  background: var(--border);
}

/* Responsive */
@media (max-width: 900px) {
  .rentabilite-table {
    font-size: 13px;
  }

  .td-nom {
    min-width: 120px;
  }

  .prix-sim-input {
    width: 70px;
  }

  .summary-bar {
    grid-template-columns: 1fr 1fr;
  }
}

@media (max-width: 600px) {
  .filters-bar {
    flex-direction: column;
  }

  .canal-tabs {
    overflow-x: auto;
  }

  .summary-bar {
    grid-template-columns: 1fr;
  }
}
</style>
