<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useIngredientsStore } from '@/stores/ingredients'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { restCall } from '@/lib/rest-client'
import type { IngredientRestaurant, Mercuriale, HistoriquePrix } from '@/types/database'

const ingredientsStore = useIngredientsStore()
const mercurialeStore = useMercurialeStore()
const fournisseursStore = useFournisseursStore()

const loading = ref(true)
const searchQuery = ref('')
const sortBy = ref<'ecart' | 'nom' | 'fournisseur'>('ecart')
const filterMultiOnly = ref(true)
const historiquePrix = ref<HistoriquePrix[]>([])
const expandedIngredientId = ref<string | null>(null)

// Seuil for alerting when preferred supplier is not cheapest
const SEUIL_ECART_PCT = 5

interface FournisseurPrix {
  fournisseurId: string
  fournisseurNom: string
  mercurialeId: string
  designation: string
  prixUnitaireHt: number
  uniteStock: string
  coeffConversion: number
  /** Normalized price per unite_stock of the ingredient */
  prixNormalise: number
  /** Label for the ordering conditionnement (e.g. "sachet × 50") */
  condLabel: string
  isPreferred: boolean
}

interface IngredientCoutRow {
  ingredient: IngredientRestaurant
  fournisseurPrefere: FournisseurPrix | null
  autresFournisseurs: FournisseurPrix[]
  meilleurPrix: number
  ecartPct: number
  hasAlert: boolean
  historique: HistoriquePrix[]
}

async function fetchHistoriquePrix() {
  try {
    if (!navigator.onLine) return
    const data = await restCall<HistoriquePrix[]>(
      'GET',
      'historique_prix?select=*&order=date_constatation.desc&limit=500',
    )
    historiquePrix.value = data || []
  } catch {
    historiquePrix.value = []
  }
}

function getMercurialesByIngredient(ingredientId: string): Mercuriale[] {
  return mercurialeStore.actifs.filter(m => m.ingredient_restaurant_id === ingredientId)
}

/** Weight/volume stock units where prix_unitaire_ht is per base unit (kg or L) */
const WEIGHT_UNITS = new Set(['g', 'kg'])
const VOLUME_UNITS = new Set(['mL', 'cl', 'L'])


function getCondLabel(merc: Mercuriale): string {
  const cond = merc.conditionnements?.find(c => c.utilise_commande)
  if (cond) {
    return `${cond.nom} × ${cond.quantite} ${cond.unite}`
  }
  if (merc.coefficient_conversion > 1) {
    return `× ${merc.coefficient_conversion}`
  }
  return ''
}

function normalizePrice(merc: Mercuriale): number {
  // Convention: prix_unitaire_ht is ALWAYS per base unit:
  //   - per kg for weight products (stock in g/kg)
  //   - per L for volume products (stock in mL/cl/L)
  //   - per ordering pack for count products (stock in unite/piece/botte)
  const su = merc.unite_stock

  if (WEIGHT_UNITS.has(su) || VOLUME_UNITS.has(su)) {
    // prix is already per kg or per L — return as-is for display
    return merc.prix_unitaire_ht
  }

  // Count products: prix is per ordering pack → divide by coeff for per-piece
  const condCommande = merc.conditionnements?.find(c => c.utilise_commande)
  const divisor = (condCommande && condCommande.quantite > 0)
    ? condCommande.quantite
    : merc.coefficient_conversion

  if (divisor > 0) {
    return merc.prix_unitaire_ht / divisor
  }
  return merc.prix_unitaire_ht
}

function displayUnit(unite: string): string {
  if (WEIGHT_UNITS.has(unite)) return 'kg'
  if (VOLUME_UNITS.has(unite)) return 'L'
  return unite
}

const rows = computed<IngredientCoutRow[]>(() => {
  const results: IngredientCoutRow[] = []

  for (const ing of ingredientsStore.actifs) {
    const mercs = getMercurialesByIngredient(ing.id)
    if (mercs.length === 0) continue
    if (filterMultiOnly.value && mercs.length < 2) continue

    const fournisseursPrix: FournisseurPrix[] = mercs.map(m => {
      const f = fournisseursStore.getById(m.fournisseur_id)
      const prixNorm = normalizePrice(m)
      return {
        fournisseurId: m.fournisseur_id,
        fournisseurNom: f?.nom || 'Inconnu',
        mercurialeId: m.id,
        designation: m.designation,
        prixUnitaireHt: m.prix_unitaire_ht,
        uniteStock: m.unite_stock,
        coeffConversion: m.coefficient_conversion,
        prixNormalise: prixNorm,
        condLabel: getCondLabel(m),
        isPreferred: m.id === ing.fournisseur_prefere_id,
      }
    })

    const prefere = fournisseursPrix.find(fp => fp.isPreferred) || null
    const autres = fournisseursPrix.filter(fp => !fp.isPreferred)
    const meilleurPrix = Math.min(...fournisseursPrix.map(fp => fp.prixNormalise))
    const preferePrix = prefere?.prixNormalise || 0

    let ecartPct = 0
    if (prefere && meilleurPrix > 0 && preferePrix > meilleurPrix) {
      ecartPct = ((preferePrix - meilleurPrix) / meilleurPrix) * 100
    }

    const ingHistorique = historiquePrix.value
      .filter(h => fournisseursPrix.some(fp => fp.mercurialeId === h.mercuriale_id))
      .slice(0, 3)

    results.push({
      ingredient: ing,
      fournisseurPrefere: prefere,
      autresFournisseurs: autres.sort((a, b) => a.prixNormalise - b.prixNormalise),
      meilleurPrix,
      ecartPct,
      hasAlert: ecartPct > SEUIL_ECART_PCT,
      historique: ingHistorique,
    })
  }

  return results
})

const filteredRows = computed(() => {
  let result = rows.value

  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    result = result.filter(r =>
      r.ingredient.nom.toLowerCase().includes(q) ||
      r.fournisseurPrefere?.fournisseurNom.toLowerCase().includes(q) ||
      r.autresFournisseurs.some(fp => fp.fournisseurNom.toLowerCase().includes(q))
    )
  }

  result = [...result].sort((a, b) => {
    if (sortBy.value === 'ecart') return b.ecartPct - a.ecartPct
    if (sortBy.value === 'nom') return a.ingredient.nom.localeCompare(b.ingredient.nom)
    if (sortBy.value === 'fournisseur') {
      const aName = a.fournisseurPrefere?.fournisseurNom || ''
      const bName = b.fournisseurPrefere?.fournisseurNom || ''
      return aName.localeCompare(bName)
    }
    return 0
  })

  return result
})

const alertCount = computed(() => rows.value.filter(r => r.hasAlert).length)

function toggleExpand(ingredientId: string) {
  expandedIngredientId.value = expandedIngredientId.value === ingredientId ? null : ingredientId
}

function getHistoriqueForMercuriale(mercurialeId: string): HistoriquePrix[] {
  return historiquePrix.value
    .filter(h => h.mercuriale_id === mercurialeId)
    .slice(0, 3)
}

function formatDate(dateStr: string): string {
  return new Date(dateStr).toLocaleDateString('fr-FR', {
    day: 'numeric',
    month: 'short',
  })
}

function formatPrix(prix: number): string {
  return prix.toFixed(2)
}

function variationLabel(h: HistoriquePrix): string {
  if (h.prix_ancien == null) return 'Initial'
  const diff = h.prix_nouveau - h.prix_ancien
  const pct = h.prix_ancien > 0 ? (diff / h.prix_ancien) * 100 : 0
  const sign = diff > 0 ? '+' : ''
  return `${sign}${pct.toFixed(1)}%`
}

function variationClass(h: HistoriquePrix): string {
  if (h.prix_ancien == null) return ''
  return h.prix_nouveau > h.prix_ancien ? 'variation-up' : 'variation-down'
}

onMounted(async () => {
  loading.value = true
  await Promise.all([
    ingredientsStore.fetchAll(),
    mercurialeStore.fetchAll(),
    fournisseursStore.fetchAll(),
    fetchHistoriquePrix(),
  ])
  loading.value = false
})
</script>

<template>
  <div class="cout-matiere-page">
    <!-- Header -->
    <div class="page-header">
      <div>
        <h1>Co&ucirc;t mati&egrave;re</h1>
        <p class="page-subtitle">Comparatif multi-fournisseur</p>
      </div>
      <div v-if="alertCount > 0" class="alert-summary">
        <span class="alert-badge">{{ alertCount }}</span>
        <span class="alert-label">alerte{{ alertCount > 1 ? 's' : '' }} prix</span>
      </div>
    </div>

    <!-- Filters -->
    <div class="filters-bar">
      <input
        v-model="searchQuery"
        type="search"
        placeholder="Rechercher un ingr&eacute;dient..."
        class="search-input"
      />
      <div class="filters-row">
        <label class="filter-toggle">
          <input v-model="filterMultiOnly" type="checkbox" />
          <span>Multi-fournisseurs uniquement</span>
        </label>
        <div class="sort-group">
          <span class="sort-label">Trier par :</span>
          <button
            class="sort-btn"
            :class="{ active: sortBy === 'ecart' }"
            @click="sortBy = 'ecart'"
          >
            &Eacute;cart prix
          </button>
          <button
            class="sort-btn"
            :class="{ active: sortBy === 'nom' }"
            @click="sortBy = 'nom'"
          >
            Nom
          </button>
          <button
            class="sort-btn"
            :class="{ active: sortBy === 'fournisseur' }"
            @click="sortBy = 'fournisseur'"
          >
            Fournisseur
          </button>
        </div>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="loading-state">
      <span>Chargement...</span>
    </div>

    <!-- Empty -->
    <div v-else-if="filteredRows.length === 0" class="empty-state">
      <p v-if="searchQuery">Aucun r&eacute;sultat pour &laquo; {{ searchQuery }} &raquo;</p>
      <p v-else>Aucun ingr&eacute;dient avec plusieurs fournisseurs</p>
    </div>

    <!-- Table -->
    <div v-else class="table-container">
      <table class="cout-table">
        <thead>
          <tr>
            <th class="col-ingredient">Ingr&eacute;dient</th>
            <th class="col-unite">Unit&eacute;</th>
            <th class="col-prefere">Fournisseur pr&eacute;f&eacute;r&eacute;</th>
            <th class="col-autres">Autres fournisseurs</th>
            <th class="col-ecart">&Eacute;cart</th>
          </tr>
        </thead>
        <tbody>
          <template v-for="row in filteredRows" :key="row.ingredient.id">
            <tr
              class="ingredient-row"
              :class="{ 'has-alert': row.hasAlert, expanded: expandedIngredientId === row.ingredient.id }"
              @click="toggleExpand(row.ingredient.id)"
            >
              <td class="col-ingredient">
                <div class="ingredient-cell">
                  <span v-if="row.hasAlert" class="row-alert-badge" title="Prix fournisseur pr&eacute;f&eacute;r&eacute; sup&eacute;rieur de + de 5%">&#x26A0;&#xFE0F;</span>
                  <span class="ingredient-name">{{ row.ingredient.nom }}</span>
                </div>
              </td>
              <td class="col-unite">{{ row.ingredient.unite_stock }}</td>
              <td class="col-prefere">
                <div v-if="row.fournisseurPrefere" class="prix-cell">
                  <span class="fournisseur-tag">{{ row.fournisseurPrefere.fournisseurNom }}</span>
                  <span class="prix-value">{{ formatPrix(row.fournisseurPrefere.prixNormalise) }} &euro;/{{ displayUnit(row.ingredient.unite_stock) }}</span>
                </div>
                <span v-else class="no-prefere">Aucun</span>
              </td>
              <td class="col-autres">
                <div class="autres-list">
                  <div v-for="fp in row.autresFournisseurs.slice(0, 2)" :key="fp.mercurialeId" class="prix-cell-compact">
                    <span class="fournisseur-tag small">{{ fp.fournisseurNom }}</span>
                    <span
                      class="prix-value"
                      :class="{ 'is-cheapest': fp.prixNormalise <= row.meilleurPrix }"
                    >{{ formatPrix(fp.prixNormalise) }} &euro;</span>
                  </div>
                  <span v-if="row.autresFournisseurs.length > 2" class="more-count">
                    +{{ row.autresFournisseurs.length - 2 }}
                  </span>
                </div>
              </td>
              <td class="col-ecart">
                <span v-if="row.ecartPct > 0" class="ecart-badge" :class="{ danger: row.hasAlert }">
                  +{{ row.ecartPct.toFixed(1) }}%
                </span>
                <span v-else class="ecart-ok">OK</span>
              </td>
            </tr>

            <!-- Expanded detail row -->
            <tr v-if="expandedIngredientId === row.ingredient.id" class="detail-row">
              <td colspan="5">
                <div class="detail-content">
                  <!-- All suppliers detail -->
                  <div class="detail-section">
                    <h4>Tous les fournisseurs</h4>
                    <div class="detail-suppliers">
                      <div
                        v-for="fp in [row.fournisseurPrefere, ...row.autresFournisseurs].filter(Boolean) as FournisseurPrix[]"
                        :key="fp.mercurialeId"
                        class="detail-supplier-card"
                        :class="{ preferred: fp.isPreferred, cheapest: fp.prixNormalise <= row.meilleurPrix }"
                      >
                        <div class="dsc-header">
                          <span class="dsc-name">{{ fp.fournisseurNom }}</span>
                          <span v-if="fp.isPreferred" class="dsc-tag preferred-tag">Pr&eacute;f&eacute;r&eacute;</span>
                          <span v-if="fp.prixNormalise <= row.meilleurPrix" class="dsc-tag cheapest-tag">Moins cher</span>
                        </div>
                        <div class="dsc-designation">{{ fp.designation }}</div>
                        <div class="dsc-prix">
                          <span class="dsc-prix-value">{{ formatPrix(fp.prixUnitaireHt) }} &euro; HT</span>
                          <span v-if="fp.condLabel" class="dsc-prix-cond">({{ fp.condLabel }})</span>
                          <span class="dsc-prix-conv">
                            &rarr; {{ formatPrix(fp.prixNormalise) }} &euro;/{{ displayUnit(row.ingredient.unite_stock) }}
                          </span>
                        </div>

                        <!-- Price history for this mercuriale -->
                        <div class="dsc-historique" v-if="getHistoriqueForMercuriale(fp.mercurialeId).length > 0">
                          <span class="dsc-hist-label">Historique :</span>
                          <div
                            v-for="h in getHistoriqueForMercuriale(fp.mercurialeId)"
                            :key="h.id"
                            class="hist-entry"
                          >
                            <span class="hist-date">{{ formatDate(h.date_constatation) }}</span>
                            <span class="hist-prix">{{ formatPrix(h.prix_nouveau) }} &euro;</span>
                            <span class="hist-variation" :class="variationClass(h)">{{ variationLabel(h) }}</span>
                            <span class="hist-source">{{ h.source }}</span>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </template>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.cout-matiere-page {
  max-width: 1100px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}

h1 {
  font-size: 28px;
  margin: 0;
}

.page-subtitle {
  font-size: 15px;
  color: var(--text-secondary);
  margin: 4px 0 0;
}

.alert-summary {
  display: flex;
  align-items: center;
  gap: 8px;
  background: rgba(239, 68, 68, 0.08);
  padding: 10px 16px;
  border-radius: var(--radius-md);
}

.alert-badge {
  background: var(--color-danger);
  color: white;
  min-width: 28px;
  height: 28px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 700;
}

.alert-label {
  font-size: 14px;
  font-weight: 600;
  color: var(--color-danger);
}

/* Filters */
.filters-bar {
  margin-bottom: 16px;
}

.search-input {
  width: 100%;
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

.filters-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
}

.filter-toggle {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: var(--text-secondary);
  cursor: pointer;
}

.filter-toggle input[type="checkbox"] {
  width: 20px;
  height: 20px;
  accent-color: var(--color-primary);
}

.sort-group {
  display: flex;
  align-items: center;
  gap: 6px;
}

.sort-label {
  font-size: 13px;
  color: var(--text-tertiary);
  margin-right: 4px;
}

.sort-btn {
  border: 1px solid var(--border);
  background: var(--bg-surface);
  border-radius: var(--radius-sm);
  padding: 6px 14px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
  transition: all 0.1s;
}

.sort-btn.active {
  background: var(--color-primary);
  color: white;
  border-color: var(--color-primary);
}

/* Loading / Empty */
.loading-state,
.empty-state {
  display: flex;
  justify-content: center;
  padding: 48px 20px;
  color: var(--text-tertiary);
  font-size: 16px;
}

/* Table */
.table-container {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  border: 1px solid var(--border);
}

.cout-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 15px;
}

.cout-table thead {
  position: sticky;
  top: 0;
  z-index: 1;
}

.cout-table th {
  background: var(--bg-main);
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: var(--text-tertiary);
  padding: 14px 16px;
  text-align: left;
  white-space: nowrap;
  border-bottom: 1px solid var(--border);
}

.cout-table td {
  padding: 14px 16px;
  border-bottom: 1px solid var(--border);
  vertical-align: top;
}

.col-ingredient { min-width: 180px; }
.col-unite { width: 70px; }
.col-prefere { min-width: 180px; }
.col-autres { min-width: 200px; }
.col-ecart { width: 80px; text-align: center; }

.ingredient-row {
  cursor: pointer;
  transition: background 0.1s;
}

.ingredient-row:hover {
  background: rgba(0, 0, 0, 0.02);
}

.ingredient-row.has-alert {
  background: rgba(239, 68, 68, 0.03);
}

.ingredient-cell {
  display: flex;
  align-items: center;
  gap: 8px;
}

.row-alert-badge {
  font-size: 16px;
  flex-shrink: 0;
}

.ingredient-name {
  font-weight: 600;
  color: var(--text-primary);
}

/* Prix cells */
.prix-cell {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.fournisseur-tag {
  font-size: 12px;
  font-weight: 600;
  color: var(--text-tertiary);
  background: var(--bg-main);
  padding: 2px 8px;
  border-radius: var(--radius-sm);
  display: inline-block;
  width: fit-content;
}

.fournisseur-tag.small {
  font-size: 11px;
  padding: 1px 6px;
}

.prix-value {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

.prix-value.is-cheapest {
  color: var(--color-success);
}

.no-prefere {
  font-size: 13px;
  color: var(--text-tertiary);
  font-style: italic;
}

.autres-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.prix-cell-compact {
  display: flex;
  align-items: center;
  gap: 8px;
}

.more-count {
  font-size: 12px;
  color: var(--text-tertiary);
  font-weight: 600;
}

.ecart-badge {
  display: inline-block;
  padding: 4px 10px;
  border-radius: var(--radius-sm);
  font-size: 13px;
  font-weight: 700;
  background: rgba(245, 158, 11, 0.12);
  color: var(--color-warning);
}

.ecart-badge.danger {
  background: rgba(239, 68, 68, 0.1);
  color: var(--color-danger);
}

.ecart-ok {
  font-size: 13px;
  font-weight: 600;
  color: var(--color-success);
}

/* Detail row */
.detail-row td {
  padding: 0;
  background: var(--bg-main);
}

.detail-content {
  padding: 16px 20px 20px;
}

.detail-section h4 {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-secondary);
  margin: 0 0 12px;
}

.detail-suppliers {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 12px;
}

.detail-supplier-card {
  background: var(--bg-surface);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 14px 16px;
}

.detail-supplier-card.preferred {
  border-color: var(--color-primary);
}

.detail-supplier-card.cheapest {
  border-color: var(--color-success);
}

.dsc-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}

.dsc-name {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-primary);
}

.dsc-tag {
  font-size: 11px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: var(--radius-sm);
}

.preferred-tag {
  background: rgba(232, 93, 44, 0.1);
  color: var(--color-primary);
}

.cheapest-tag {
  background: rgba(34, 197, 94, 0.1);
  color: var(--color-success);
}

.dsc-designation {
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 6px;
}

.dsc-prix {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
}

.dsc-prix-value {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
}

.dsc-prix-cond {
  font-size: 12px;
  color: var(--text-tertiary);
}

.dsc-prix-conv {
  font-size: 13px;
  color: var(--text-tertiary);
}

.dsc-historique {
  border-top: 1px solid var(--border);
  padding-top: 8px;
  margin-top: 4px;
}

.dsc-hist-label {
  font-size: 11px;
  font-weight: 700;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.3px;
  display: block;
  margin-bottom: 6px;
}

.hist-entry {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 3px 0;
  font-size: 13px;
}

.hist-date {
  color: var(--text-tertiary);
  min-width: 50px;
}

.hist-prix {
  font-weight: 600;
  color: var(--text-primary);
}

.hist-variation {
  font-weight: 700;
  font-size: 12px;
}

.hist-variation.variation-up {
  color: var(--color-danger);
}

.hist-variation.variation-down {
  color: var(--color-success);
}

.hist-source {
  font-size: 11px;
  color: var(--text-tertiary);
  background: var(--bg-main);
  padding: 1px 6px;
  border-radius: var(--radius-sm);
}

/* Responsive for smaller iPads */
@media (max-width: 768px) {
  .filters-row {
    flex-direction: column;
    align-items: flex-start;
  }
  .sort-group {
    flex-wrap: wrap;
  }
  .detail-suppliers {
    grid-template-columns: 1fr;
  }
}
</style>
