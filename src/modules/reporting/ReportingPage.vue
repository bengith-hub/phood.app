<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useReportingStore, type PrevisionJour } from '@/stores/reporting'
import { useRecettesStore } from '@/stores/recettes'

const reportingStore = useReportingStore()
const recettesStore = useRecettesStore()

// ── Tab navigation ──────────────────────────────────────────
type TabId = 'cm' | 'produits' | 'associations' | 'previsions'

const activeTab = ref<TabId>('cm')

const tabs: { id: TabId; label: string }[] = [
  { id: 'cm', label: 'Cout Matiere' },
  { id: 'produits', label: 'Top/Flop' },
  { id: 'associations', label: 'Associations' },
  { id: 'previsions', label: 'Previsions' },
]

// ── Tab 1: Cout Matiere state ───────────────────────────────
const cibleCM = computed({
  get: () => reportingStore.cibleCM,
  set: (v: number) => { reportingStore.cibleCM = v },
})

const period = computed({
  get: () => reportingStore.period,
  set: (v: 'semaine' | 'mois') => { reportingStore.period = v },
})

// We simulate nbVentes from totalCA and recipes (in real deployment,
// this comes from Zelty ticket line items). For now we distribute evenly.
const nbVentesParRecette = computed(() => {
  const map = new Map<string, number>()
  const plats = recettesStore.plats
  if (plats.length === 0) return map

  // Sum up total CA per period and distribute per recipe proportionally
  // In production, this will come from zelty_tickets_lignes
  const totalTickets = reportingStore.ventes.reduce((s, v) => s + v.nb_tickets, 0)
  const avgPerRecette = plats.length > 0 ? Math.round(totalTickets / plats.length) : 0

  for (const p of plats) {
    map.set(p.id, avgPerRecette)
  }
  return map
})

const cmRows = computed(() =>
  reportingStore.computeCoutMatiere(recettesStore.plats, nbVentesParRecette.value)
)

const maxBarValue = computed(() => {
  let max = cibleCM.value
  for (const r of cmRows.value) {
    max = Math.max(max, r.cmTheoriquePct, r.cmReelPct)
  }
  return Math.ceil(max / 10) * 10 || 50
})

// ── Tab 2: Top/Flop Produits state ──────────────────────────
type SortCriteria = 'marge' | 'volume' | 'ca'
const sortBy = ref<SortCriteria>('marge')
const showTop = ref(true) // true = top 10, false = flop 10

const allRankings = computed(() =>
  reportingStore.computeProduitRankings(recettesStore.plats, nbVentesParRecette.value)
)

const sortedRankings = computed(() => {
  const sorted = [...allRankings.value]

  switch (sortBy.value) {
    case 'marge':
      sorted.sort((a, b) => b.margeUnitaire - a.margeUnitaire)
      break
    case 'volume':
      sorted.sort((a, b) => b.nbVentes - a.nbVentes)
      break
    case 'ca':
      sorted.sort((a, b) => b.ca - a.ca)
      break
  }

  if (!showTop.value) {
    sorted.reverse()
  }

  return sorted.slice(0, 10)
})

// ── Tab 4: Previsions state ─────────────────────────────────
const previsionJours = ref<PrevisionJour[]>([])
const previsionLoading = ref(false)

const moyenneEcart = computed(() => {
  const jourAvecReel = previsionJours.value.filter(j => j.reel > 0)
  if (jourAvecReel.length === 0) return 0
  return jourAvecReel.reduce((s, j) => s + j.ecartPct, 0) / jourAvecReel.length
})

const moyenneCouleur = computed(() => {
  if (moyenneEcart.value > 20) return 'red'
  if (moyenneEcart.value > 10) return 'orange'
  return 'green'
})

// ── Format helpers ──────────────────────────────────────────
function formatEuro(v: number): string {
  return v.toLocaleString('fr-FR', { minimumFractionDigits: 0, maximumFractionDigits: 0 }) + ' \u20AC'
}

function formatPct(v: number): string {
  return v.toFixed(1) + ' %'
}

function formatEuroUnit(v: number): string {
  return v.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' \u20AC'
}

// ── Lifecycle ───────────────────────────────────────────────
async function loadData() {
  await recettesStore.fetchAll()
  await reportingStore.fetchAll(recettesStore.plats)

  if (activeTab.value === 'previsions') {
    previsionLoading.value = true
    try {
      previsionJours.value = await reportingStore.fetchPrecisionPrevisions()
    } finally {
      previsionLoading.value = false
    }
  }

  await reportingStore.fetchAssociations()
}

watch(period, async () => {
  await reportingStore.fetchAll(recettesStore.plats)
})

watch(activeTab, async (tab) => {
  if (tab === 'previsions' && previsionJours.value.length === 0) {
    previsionLoading.value = true
    try {
      previsionJours.value = await reportingStore.fetchPrecisionPrevisions()
    } finally {
      previsionLoading.value = false
    }
  }
})

onMounted(loadData)
</script>

<template>
  <div class="reporting">
    <h1>Reporting</h1>

    <!-- Tab bar -->
    <div class="tab-bar">
      <button
        v-for="tab in tabs"
        :key="tab.id"
        class="tab-btn"
        :class="{ active: activeTab === tab.id }"
        @click="activeTab = tab.id"
      >
        {{ tab.label }}
      </button>
    </div>

    <!-- Loading overlay -->
    <div v-if="reportingStore.loading" class="loading-state">
      <div class="spinner"></div>
      <p>Chargement des donnees...</p>
    </div>

    <!-- Error -->
    <div v-else-if="reportingStore.error" class="error-state">
      <p>{{ reportingStore.error }}</p>
      <button class="btn-primary" @click="loadData">Reessayer</button>
    </div>

    <!-- ═══════════════════════════════════════════════════════
         TAB 1: COUT MATIERE
         ═══════════════════════════════════════════════════════ -->
    <div v-else-if="activeTab === 'cm'" class="tab-content">
      <!-- Controls -->
      <div class="cm-controls">
        <div class="period-toggle">
          <button
            class="toggle-btn"
            :class="{ active: period === 'semaine' }"
            @click="period = 'semaine'"
          >
            Semaine
          </button>
          <button
            class="toggle-btn"
            :class="{ active: period === 'mois' }"
            @click="period = 'mois'"
          >
            Mois
          </button>
        </div>

        <div class="cible-control">
          <label>Cible CM :</label>
          <div class="cible-input-group">
            <button class="cible-btn" @click="cibleCM = Math.max(10, cibleCM - 1)">-</button>
            <span class="cible-value">{{ cibleCM }}%</span>
            <button class="cible-btn" @click="cibleCM = Math.min(60, cibleCM + 1)">+</button>
          </div>
        </div>
      </div>

      <!-- Summary cards -->
      <div class="cm-summary">
        <div class="summary-card">
          <span class="summary-label">CA Total</span>
          <span class="summary-value">{{ formatEuro(reportingStore.totalCA) }}</span>
        </div>
        <div class="summary-card">
          <span class="summary-label">CM Reel global</span>
          <span class="summary-value" :class="reportingStore.cmReelGlobal > cibleCM ? 'text-danger' : 'text-success'">
            {{ formatPct(reportingStore.cmReelGlobal) }}
          </span>
        </div>
        <div class="summary-card">
          <span class="summary-label">Cible</span>
          <span class="summary-value text-target">{{ cibleCM }}%</span>
        </div>
      </div>

      <!-- Bar chart -->
      <div class="chart-container">
        <div class="chart-header">
          <span class="chart-title">CM Theorique vs Reel</span>
          <div class="chart-legend">
            <span class="legend-item"><span class="legend-dot theorique"></span> Theorique</span>
            <span class="legend-item"><span class="legend-dot reel"></span> Reel</span>
            <span class="legend-item"><span class="legend-dot cible"></span> Cible {{ cibleCM }}%</span>
          </div>
        </div>

        <div class="bar-chart">
          <!-- Target line -->
          <div
            class="target-line"
            :style="{ bottom: (cibleCM / maxBarValue * 100) + '%' }"
          >
            <span class="target-label">{{ cibleCM }}%</span>
          </div>

          <!-- Y-axis labels -->
          <div class="y-axis">
            <span v-for="tick in 5" :key="tick" class="y-tick">
              {{ Math.round((maxBarValue / 5) * (5 - tick + 1)) }}%
            </span>
          </div>

          <!-- Bars -->
          <div class="bars-wrapper">
            <div v-for="row in cmRows" :key="row.label" class="bar-group">
              <div class="bar-pair">
                <div
                  class="bar bar-theorique"
                  :style="{ height: (row.cmTheoriquePct / maxBarValue * 100) + '%' }"
                  :title="'Theorique: ' + formatPct(row.cmTheoriquePct)"
                >
                  <span v-if="row.cmTheoriquePct > 5" class="bar-label">{{ row.cmTheoriquePct.toFixed(0) }}</span>
                </div>
                <div
                  class="bar bar-reel"
                  :style="{ height: (row.cmReelPct / maxBarValue * 100) + '%' }"
                  :class="{
                    'bar-over': row.cmReelPct > cibleCM,
                    'bar-ok': row.cmReelPct <= cibleCM,
                  }"
                  :title="'Reel: ' + formatPct(row.cmReelPct)"
                >
                  <span v-if="row.cmReelPct > 5" class="bar-label">{{ row.cmReelPct.toFixed(0) }}</span>
                </div>
              </div>
              <span class="bar-x-label">{{ row.label }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Detail table -->
      <div class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>Periode</th>
              <th class="text-right">CA TTC</th>
              <th class="text-right">CM Theo.</th>
              <th class="text-right">CM Reel</th>
              <th class="text-right">Ecart</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="row in cmRows" :key="row.label">
              <td class="td-label">{{ row.label }}</td>
              <td class="text-right">{{ formatEuro(row.ca) }}</td>
              <td class="text-right">{{ formatPct(row.cmTheoriquePct) }}</td>
              <td class="text-right" :class="row.cmReelPct > cibleCM ? 'text-danger' : 'text-success'">
                {{ formatPct(row.cmReelPct) }}
              </td>
              <td class="text-right" :class="Math.abs(row.cmReelPct - row.cmTheoriquePct) > 3 ? 'text-danger' : ''">
                {{ (row.cmReelPct - row.cmTheoriquePct) > 0 ? '+' : '' }}{{ formatPct(row.cmReelPct - row.cmTheoriquePct) }}
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-if="cmRows.length === 0" class="empty-state">
        <p>Aucune donnee de vente sur cette periode.</p>
        <p class="empty-hint">Les donnees apparaitront une fois les clotures Zelty importees.</p>
      </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════
         TAB 2: TOP/FLOP PRODUITS
         ═══════════════════════════════════════════════════════ -->
    <div v-else-if="activeTab === 'produits'" class="tab-content">
      <div class="produits-controls">
        <div class="sort-toggle">
          <button
            class="toggle-btn"
            :class="{ active: sortBy === 'marge' }"
            @click="sortBy = 'marge'"
          >
            Marge
          </button>
          <button
            class="toggle-btn"
            :class="{ active: sortBy === 'volume' }"
            @click="sortBy = 'volume'"
          >
            Volume
          </button>
          <button
            class="toggle-btn"
            :class="{ active: sortBy === 'ca' }"
            @click="sortBy = 'ca'"
          >
            CA
          </button>
        </div>

        <div class="topflop-toggle">
          <button
            class="toggle-btn top"
            :class="{ active: showTop }"
            @click="showTop = true"
          >
            Top 10
          </button>
          <button
            class="toggle-btn flop"
            :class="{ active: !showTop }"
            @click="showTop = false"
          >
            Flop 10
          </button>
        </div>
      </div>

      <!-- Products list (card-based for iPad) -->
      <div class="produits-list">
        <div
          v-for="(item, idx) in sortedRankings"
          :key="item.recetteId"
          class="produit-card"
        >
          <div class="produit-rank">{{ idx + 1 }}</div>
          <div class="produit-info">
            <div class="produit-header">
              <span class="produit-nom">{{ item.nom }}</span>
              <span v-if="item.categorie" class="produit-cat">{{ item.categorie }}</span>
            </div>
            <div class="produit-metrics">
              <div class="metric">
                <span class="metric-label">Ventes</span>
                <span class="metric-value">{{ item.nbVentes }}</span>
              </div>
              <div class="metric">
                <span class="metric-label">CA</span>
                <span class="metric-value">{{ formatEuro(item.ca) }}</span>
              </div>
              <div class="metric">
                <span class="metric-label">CM unit.</span>
                <span class="metric-value">{{ formatEuroUnit(item.coutMatiere / Math.max(item.nbVentes, 1)) }}</span>
              </div>
              <div class="metric">
                <span class="metric-label">Marge unit.</span>
                <span class="metric-value" :class="item.margeUnitaire > 0 ? 'text-success' : 'text-danger'">
                  {{ formatEuroUnit(item.margeUnitaire) }}
                </span>
              </div>
              <div class="metric">
                <span class="metric-label">Marge %</span>
                <span class="metric-value" :class="item.margePct > 60 ? 'text-success' : item.margePct < 50 ? 'text-danger' : 'text-warning'">
                  {{ formatPct(item.margePct) }}
                </span>
              </div>
            </div>
            <!-- Mini margin bar -->
            <div class="marge-bar-container">
              <div
                class="marge-bar"
                :style="{ width: Math.min(Math.max(item.margePct, 0), 100) + '%' }"
                :class="{
                  'bg-success': item.margePct > 60,
                  'bg-warning': item.margePct >= 50 && item.margePct <= 60,
                  'bg-danger': item.margePct < 50,
                }"
              ></div>
            </div>
          </div>
        </div>
      </div>

      <div v-if="sortedRankings.length === 0" class="empty-state">
        <p>Aucun produit a afficher.</p>
        <p class="empty-hint">Les donnees apparaitront avec les ventes Zelty et les fiches recettes.</p>
      </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════
         TAB 3: ASSOCIATIONS PRODUITS
         ═══════════════════════════════════════════════════════ -->
    <div v-else-if="activeTab === 'associations'" class="tab-content">
      <div class="associations-header">
        <h2>Produits frequemment vendus ensemble</h2>
        <p class="section-description">
          Analyse des tickets Zelty pour identifier les associations de produits les plus frequentes.
        </p>
      </div>

      <div v-if="reportingStore.associations.length > 0" class="table-container">
        <table class="data-table">
          <thead>
            <tr>
              <th>Produit A</th>
              <th>Produit B</th>
              <th class="text-right">Co-occurrences</th>
              <th class="text-right">% des tickets</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(assoc, idx) in reportingStore.associations" :key="idx">
              <td>{{ assoc.produitA }}</td>
              <td>{{ assoc.produitB }}</td>
              <td class="text-right">{{ assoc.coOccurrences }}</td>
              <td class="text-right">{{ formatPct(assoc.pctTickets) }}</td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Scaffold / empty state -->
      <div class="empty-state associations-scaffold">
        <div class="scaffold-icon">
          <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
            <circle cx="8" cy="8" r="3" />
            <circle cx="16" cy="16" r="3" />
            <path d="M10.5 10.5l3 3" stroke-dasharray="2 2" />
            <circle cx="18" cy="6" r="2" />
            <path d="M10.8 7l5.2-1" stroke-dasharray="2 2" />
          </svg>
        </div>
        <p class="scaffold-title">Analyse en preparation</p>
        <p class="scaffold-desc">
          Les associations de produits seront calculees a partir des tickets Zelty
          (lignes de vente par ticket).
        </p>
        <p class="scaffold-desc">
          Cette analyse identifiera les produits frequemment achetes ensemble
          pour optimiser les menus, les suggestions de vente et la mise en place.
        </p>
        <div class="scaffold-preview">
          <table class="data-table preview-table">
            <thead>
              <tr>
                <th>Produit A</th>
                <th>Produit B</th>
                <th class="text-right">Co-occ.</th>
                <th class="text-right">% tickets</th>
              </tr>
            </thead>
            <tbody>
              <tr class="preview-row">
                <td class="placeholder-bar"><span></span></td>
                <td class="placeholder-bar"><span></span></td>
                <td class="placeholder-bar short"><span></span></td>
                <td class="placeholder-bar short"><span></span></td>
              </tr>
              <tr class="preview-row">
                <td class="placeholder-bar"><span></span></td>
                <td class="placeholder-bar"><span></span></td>
                <td class="placeholder-bar short"><span></span></td>
                <td class="placeholder-bar short"><span></span></td>
              </tr>
              <tr class="preview-row">
                <td class="placeholder-bar"><span></span></td>
                <td class="placeholder-bar"><span></span></td>
                <td class="placeholder-bar short"><span></span></td>
                <td class="placeholder-bar short"><span></span></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- ═══════════════════════════════════════════════════════
         TAB 4: PRECISION PREVISIONS
         ═══════════════════════════════════════════════════════ -->
    <div v-else-if="activeTab === 'previsions'" class="tab-content">
      <div class="previsions-header">
        <h2>Precision des previsions S-1</h2>
        <p class="section-description">
          Comparaison prevision vs reel du CA pour la semaine precedente.
        </p>
      </div>

      <div v-if="previsionLoading" class="loading-state">
        <div class="spinner"></div>
        <p>Chargement des previsions...</p>
      </div>

      <template v-else>
        <!-- Summary -->
        <div class="prevision-summary">
          <div class="summary-card large">
            <span class="summary-label">Ecart moyen</span>
            <span
              class="summary-value big"
              :class="{
                'text-success': moyenneCouleur === 'green',
                'text-warning': moyenneCouleur === 'orange',
                'text-danger': moyenneCouleur === 'red',
              }"
            >
              {{ formatPct(moyenneEcart) }}
            </span>
            <span class="summary-hint" :class="'text-' + moyenneCouleur">
              {{ moyenneCouleur === 'green' ? 'Excellent' : moyenneCouleur === 'orange' ? 'A surveiller' : 'A ameliorer' }}
            </span>
          </div>
        </div>

        <!-- Color legend -->
        <div class="prevision-legend">
          <span class="legend-item"><span class="legend-dot green"></span> &lt; 10% ecart</span>
          <span class="legend-item"><span class="legend-dot orange"></span> 10-20% ecart</span>
          <span class="legend-item"><span class="legend-dot red"></span> &gt; 20% ecart</span>
        </div>

        <!-- Day-by-day cards -->
        <div class="prevision-days">
          <div
            v-for="jour in previsionJours"
            :key="jour.date"
            class="prevision-day-card"
            :class="'border-' + jour.couleur"
          >
            <div class="day-header">
              <span class="day-name">{{ jour.jourSemaine }}</span>
              <span class="day-date">{{ new Date(jour.date).toLocaleDateString('fr-FR', { day: '2-digit', month: '2-digit' }) }}</span>
            </div>
            <div class="day-values">
              <div class="day-metric">
                <span class="day-metric-label">Prevision</span>
                <span class="day-metric-value">{{ formatEuro(jour.prevision) }}</span>
              </div>
              <div class="day-metric">
                <span class="day-metric-label">Reel</span>
                <span class="day-metric-value">{{ formatEuro(jour.reel) }}</span>
              </div>
            </div>
            <div class="day-ecart" :class="'bg-' + jour.couleur">
              <span v-if="jour.reel > 0">{{ jour.ecartPct.toFixed(1) }}% ecart</span>
              <span v-else class="no-data">Pas de donnees</span>
            </div>
          </div>
        </div>

        <!-- Comparison bar chart -->
        <div v-if="previsionJours.some(j => j.reel > 0)" class="chart-container">
          <div class="chart-header">
            <span class="chart-title">Prevision vs Reel (S-1)</span>
            <div class="chart-legend">
              <span class="legend-item"><span class="legend-dot theorique"></span> Prevision</span>
              <span class="legend-item"><span class="legend-dot reel"></span> Reel</span>
            </div>
          </div>

          <div class="horizontal-chart">
            <div
              v-for="jour in previsionJours"
              :key="jour.date"
              class="hbar-row"
            >
              <span class="hbar-label">{{ jour.jourSemaine.substring(0, 3) }}</span>
              <div class="hbar-track">
                <div
                  class="hbar hbar-prevision"
                  :style="{
                    width: Math.min((jour.prevision / Math.max(...previsionJours.map(j => Math.max(j.prevision, j.reel)), 1)) * 100, 100) + '%'
                  }"
                ></div>
                <div
                  class="hbar hbar-reel"
                  :style="{
                    width: Math.min((jour.reel / Math.max(...previsionJours.map(j => Math.max(j.prevision, j.reel)), 1)) * 100, 100) + '%'
                  }"
                ></div>
              </div>
              <span class="hbar-value" :class="'text-' + jour.couleur">
                {{ jour.reel > 0 ? jour.ecartPct.toFixed(0) + '%' : '-' }}
              </span>
            </div>
          </div>
        </div>

        <div v-if="previsionJours.every(j => j.reel === 0 && j.prevision === 0)" class="empty-state">
          <p>Aucune donnee pour la semaine precedente.</p>
          <p class="empty-hint">Les previsions et ventes apparaitront une fois le module de prevision actif et les clotures importees.</p>
        </div>
      </template>
    </div>
  </div>
</template>

<style scoped>
/* ═══════════════════════════════════════════════════════════════
   LAYOUT
   ═══════════════════════════════════════════════════════════════ */
.reporting {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 16px 40px;
}

.reporting h1 {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 20px;
}

/* ═══════════════════════════════════════════════════════════════
   TAB BAR
   ═══════════════════════════════════════════════════════════════ */
.tab-bar {
  display: flex;
  gap: 4px;
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 4px;
  margin-bottom: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.tab-btn {
  flex: 1;
  min-width: 0;
  padding: 14px 12px;
  border: none;
  border-radius: var(--radius-md);
  background: transparent;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
  min-height: 48px;
}

.tab-btn.active {
  background: var(--color-primary);
  color: white;
  box-shadow: 0 2px 8px rgba(232, 93, 44, 0.3);
}

.tab-btn:not(.active):hover {
  background: rgba(0, 0, 0, 0.04);
}

/* ═══════════════════════════════════════════════════════════════
   LOADING & ERROR STATES
   ═══════════════════════════════════════════════════════════════ */
.loading-state,
.error-state {
  text-align: center;
  padding: 60px 20px;
  color: var(--text-secondary);
}

.loading-state p,
.error-state p {
  font-size: 18px;
  margin-top: 16px;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 3px solid var(--border);
  border-top-color: var(--color-primary);
  border-radius: 50%;
  margin: 0 auto;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.btn-primary {
  margin-top: 16px;
  padding: 14px 28px;
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  min-height: 48px;
}

/* ═══════════════════════════════════════════════════════════════
   EMPTY STATE
   ═══════════════════════════════════════════════════════════════ */
.empty-state {
  text-align: center;
  padding: 48px 20px;
}

.empty-state p {
  font-size: 18px;
  color: var(--text-secondary);
}

.empty-hint {
  font-size: 15px !important;
  color: var(--text-tertiary) !important;
  margin-top: 8px;
}

/* ═══════════════════════════════════════════════════════════════
   TAB CONTENT WRAPPER
   ═══════════════════════════════════════════════════════════════ */
.tab-content {
  animation: fadeIn 0.2s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(4px); }
  to { opacity: 1; transform: translateY(0); }
}

/* ═══════════════════════════════════════════════════════════════
   TOGGLE BUTTONS (shared)
   ═══════════════════════════════════════════════════════════════ */
.period-toggle,
.sort-toggle,
.topflop-toggle {
  display: flex;
  gap: 2px;
  background: #F0F0F2;
  border-radius: var(--radius-md);
  padding: 3px;
}

.toggle-btn {
  padding: 10px 18px;
  border: none;
  border-radius: var(--radius-sm);
  background: transparent;
  font-size: 15px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  transition: all 0.15s;
  min-height: 44px;
}

.toggle-btn.active {
  background: var(--bg-surface);
  color: var(--text-primary);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.topflop-toggle .toggle-btn.top.active {
  background: var(--color-success);
  color: white;
}

.topflop-toggle .toggle-btn.flop.active {
  background: var(--color-danger);
  color: white;
}

/* ═══════════════════════════════════════════════════════════════
   TAB 1: COUT MATIERE
   ═══════════════════════════════════════════════════════════════ */
.cm-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 16px;
  margin-bottom: 20px;
}

.cible-control {
  display: flex;
  align-items: center;
  gap: 10px;
}

.cible-control label {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-secondary);
}

.cible-input-group {
  display: flex;
  align-items: center;
  gap: 0;
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  border: 1px solid var(--border);
  overflow: hidden;
}

.cible-btn {
  width: 44px;
  height: 44px;
  border: none;
  background: transparent;
  font-size: 20px;
  font-weight: 600;
  color: var(--color-primary);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cible-btn:hover {
  background: rgba(232, 93, 44, 0.08);
}

.cible-value {
  padding: 0 12px;
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
  min-width: 48px;
  text-align: center;
}

/* Summary cards */
.cm-summary,
.prevision-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 12px;
  margin-bottom: 24px;
}

.summary-card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 16px 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.summary-card.large {
  align-items: center;
  text-align: center;
  padding: 24px;
}

.summary-label {
  font-size: 14px;
  font-weight: 500;
  color: var(--text-tertiary);
}

.summary-value {
  font-size: 26px;
  font-weight: 700;
  color: var(--text-primary);
}

.summary-value.big {
  font-size: 42px;
}

.summary-hint {
  font-size: 15px;
  font-weight: 600;
  margin-top: 4px;
}

.text-success { color: var(--color-success); }
.text-warning { color: var(--color-warning); }
.text-danger { color: var(--color-danger); }
.text-target { color: var(--color-primary); }
.text-green { color: var(--color-success); }
.text-orange { color: var(--color-warning); }
.text-red { color: var(--color-danger); }

/* Bar chart */
.chart-container {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 20px;
  margin-bottom: 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 20px;
}

.chart-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
}

.chart-legend {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  font-weight: 500;
  color: var(--text-secondary);
}

.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 3px;
}

.legend-dot.theorique { background: #93C5FD; }
.legend-dot.reel { background: var(--color-primary); }
.legend-dot.cible { background: var(--color-danger); }
.legend-dot.green { background: var(--color-success); }
.legend-dot.orange { background: var(--color-warning); }
.legend-dot.red { background: var(--color-danger); }

.bar-chart {
  position: relative;
  display: flex;
  gap: 0;
  min-height: 260px;
  padding-bottom: 32px;
}

.target-line {
  position: absolute;
  left: 40px;
  right: 0;
  height: 2px;
  background: var(--color-danger);
  opacity: 0.6;
  z-index: 2;
  pointer-events: none;
}

.target-label {
  position: absolute;
  right: 4px;
  top: -18px;
  font-size: 11px;
  font-weight: 600;
  color: var(--color-danger);
}

.y-axis {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  width: 40px;
  flex-shrink: 0;
  padding-bottom: 0;
}

.y-tick {
  font-size: 11px;
  color: var(--text-tertiary);
  text-align: right;
  padding-right: 6px;
}

.bars-wrapper {
  display: flex;
  flex: 1;
  align-items: flex-end;
  gap: 4px;
  border-left: 1px solid var(--border);
  border-bottom: 1px solid var(--border);
  padding: 0 4px;
  position: relative;
}

.bar-group {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 0;
}

.bar-pair {
  display: flex;
  gap: 3px;
  align-items: flex-end;
  height: 200px;
  width: 100%;
  justify-content: center;
}

.bar {
  width: 40%;
  max-width: 32px;
  min-width: 12px;
  border-radius: 4px 4px 0 0;
  transition: height 0.4s ease;
  position: relative;
  min-height: 2px;
}

.bar-theorique { background: #93C5FD; }
.bar-reel.bar-ok { background: var(--color-primary); }
.bar-reel.bar-over { background: var(--color-danger); }

.bar-label {
  position: absolute;
  top: -18px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 11px;
  font-weight: 600;
  color: var(--text-secondary);
  white-space: nowrap;
}

.bar-x-label {
  font-size: 12px;
  font-weight: 600;
  color: var(--text-secondary);
  margin-top: 8px;
  text-align: center;
}

/* Data table */
.table-container {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  overflow-x: auto;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th {
  padding: 14px 16px;
  text-align: left;
  font-size: 13px;
  font-weight: 600;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  background: #FAFAFA;
  border-bottom: 1px solid var(--border);
}

.data-table td {
  padding: 14px 16px;
  font-size: 15px;
  color: var(--text-primary);
  border-bottom: 1px solid var(--border);
}

.data-table tbody tr:last-child td {
  border-bottom: none;
}

.data-table .td-label {
  font-weight: 600;
}

.text-right {
  text-align: right !important;
}

/* ═══════════════════════════════════════════════════════════════
   TAB 2: TOP/FLOP PRODUITS
   ═══════════════════════════════════════════════════════════════ */
.produits-controls {
  display: flex;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 12px;
  margin-bottom: 20px;
}

.produits-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.produit-card {
  display: flex;
  gap: 16px;
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 16px 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  align-items: flex-start;
}

.produit-rank {
  width: 36px;
  height: 36px;
  min-width: 36px;
  border-radius: 50%;
  background: var(--color-primary);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 700;
  margin-top: 2px;
}

.produit-info {
  flex: 1;
  min-width: 0;
}

.produit-header {
  display: flex;
  align-items: baseline;
  gap: 10px;
  margin-bottom: 10px;
  flex-wrap: wrap;
}

.produit-nom {
  font-size: 17px;
  font-weight: 700;
  color: var(--text-primary);
}

.produit-cat {
  font-size: 13px;
  font-weight: 500;
  color: var(--text-tertiary);
  background: #F0F0F2;
  padding: 2px 8px;
  border-radius: 6px;
}

.produit-metrics {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 8px;
}

.metric {
  display: flex;
  flex-direction: column;
  min-width: 80px;
}

.metric-label {
  font-size: 12px;
  font-weight: 500;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.metric-value {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
}

.marge-bar-container {
  height: 6px;
  background: #F0F0F2;
  border-radius: 3px;
  overflow: hidden;
  margin-top: 4px;
}

.marge-bar {
  height: 100%;
  border-radius: 3px;
  transition: width 0.4s ease;
}

.bg-success { background: var(--color-success); }
.bg-warning { background: var(--color-warning); }
.bg-danger { background: var(--color-danger); }

/* ═══════════════════════════════════════════════════════════════
   TAB 3: ASSOCIATIONS
   ═══════════════════════════════════════════════════════════════ */
.associations-header {
  margin-bottom: 20px;
}

.associations-header h2 {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 6px;
}

.section-description {
  font-size: 15px;
  color: var(--text-secondary);
  line-height: 1.5;
}

.associations-scaffold {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 40px 24px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.scaffold-icon {
  color: var(--text-tertiary);
  margin-bottom: 16px;
  opacity: 0.4;
}

.scaffold-title {
  font-size: 20px !important;
  font-weight: 700 !important;
  color: var(--text-primary) !important;
  margin-bottom: 8px;
}

.scaffold-desc {
  font-size: 15px !important;
  color: var(--text-secondary) !important;
  line-height: 1.5;
  max-width: 480px;
  margin: 0 auto 12px;
}

.scaffold-preview {
  margin-top: 24px;
  opacity: 0.3;
  pointer-events: none;
}

.preview-table {
  max-width: 600px;
  margin: 0 auto;
}

.placeholder-bar span {
  display: block;
  height: 14px;
  background: #D1D5DB;
  border-radius: 4px;
  width: 80%;
}

.placeholder-bar.short span {
  width: 40%;
  margin-left: auto;
}

/* ═══════════════════════════════════════════════════════════════
   TAB 4: PREVISIONS
   ═══════════════════════════════════════════════════════════════ */
.previsions-header {
  margin-bottom: 20px;
}

.previsions-header h2 {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 6px;
}

.prevision-legend {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
  margin-bottom: 20px;
}

.prevision-days {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 10px;
  margin-bottom: 24px;
}

.prevision-day-card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 14px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  border-left: 4px solid var(--border);
}

.prevision-day-card.border-green { border-left-color: var(--color-success); }
.prevision-day-card.border-orange { border-left-color: var(--color-warning); }
.prevision-day-card.border-red { border-left-color: var(--color-danger); }

.day-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.day-name {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-primary);
}

.day-date {
  font-size: 13px;
  color: var(--text-tertiary);
}

.day-values {
  display: flex;
  flex-direction: column;
  gap: 4px;
  margin-bottom: 10px;
}

.day-metric {
  display: flex;
  justify-content: space-between;
}

.day-metric-label {
  font-size: 13px;
  color: var(--text-secondary);
}

.day-metric-value {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
}

.day-ecart {
  text-align: center;
  padding: 6px;
  border-radius: var(--radius-sm);
  font-size: 14px;
  font-weight: 700;
  color: white;
}

.day-ecart.bg-green { background: var(--color-success); }
.day-ecart.bg-orange { background: var(--color-warning); }
.day-ecart.bg-red { background: var(--color-danger); }

.day-ecart .no-data {
  font-weight: 500;
  opacity: 0.7;
}

/* Horizontal bar chart for previsions */
.horizontal-chart {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.hbar-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.hbar-label {
  width: 40px;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
  text-align: right;
  flex-shrink: 0;
}

.hbar-track {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.hbar {
  height: 14px;
  border-radius: 4px;
  transition: width 0.4s ease;
  min-width: 2px;
}

.hbar-prevision { background: #93C5FD; }
.hbar-reel { background: var(--color-primary); }

.hbar-value {
  width: 48px;
  flex-shrink: 0;
  font-size: 14px;
  font-weight: 700;
  text-align: right;
}

/* ═══════════════════════════════════════════════════════════════
   RESPONSIVE / iPad-first
   ═══════════════════════════════════════════════════════════════ */
@media (max-width: 768px) {
  .cm-controls {
    flex-direction: column;
    align-items: stretch;
  }

  .produits-controls {
    flex-direction: column;
  }

  .prevision-days {
    grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  }

  .produit-metrics {
    gap: 10px;
  }

  .metric {
    min-width: 70px;
  }

  .chart-header {
    flex-direction: column;
    align-items: flex-start;
  }

  .bar {
    max-width: 20px;
    min-width: 8px;
  }
}

@media (min-width: 769px) and (max-width: 1024px) {
  /* iPad portrait — main target */
  .tab-btn {
    font-size: 17px;
    padding: 16px 14px;
    min-height: 52px;
  }

  .toggle-btn {
    padding: 12px 20px;
    font-size: 16px;
    min-height: 48px;
  }

  .cible-btn {
    width: 48px;
    height: 48px;
    font-size: 22px;
  }

  .summary-value {
    font-size: 28px;
  }

  .produit-nom {
    font-size: 18px;
  }

  .metric-value {
    font-size: 17px;
  }

  .data-table td {
    font-size: 16px;
    padding: 16px;
  }
}

@media (min-width: 1025px) {
  /* iPad landscape + desktop */
  .prevision-days {
    grid-template-columns: repeat(7, 1fr);
  }
}
</style>
