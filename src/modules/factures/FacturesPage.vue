<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useFacturesStore, type StatutRapprochement, type EcartFacture } from '@/stores/factures'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useCommandesStore } from '@/stores/commandes'
import { restCall } from '@/lib/rest-client'
import type { FacturePennylane, Reception } from '@/types/database'

const facturesStore = useFacturesStore()
const fournisseursStore = useFournisseursStore()
const commandesStore = useCommandesStore()

// --- Filter tabs ---
type TabFilter = 'toutes' | 'non_rapprochees' | 'ecarts' | 'depannage'
const activeTab = ref<TabFilter>('toutes')
const search = ref('')

// --- Rapprochement modal ---
const showRapprochement = ref(false)
const selectedFacture = ref<FacturePennylane | null>(null)
const matchingReceptions = ref<(Reception & { commande_numero?: string; commande_montant_ht?: number })[]>([])
const rapprochementLoading = ref(false)

// --- Ecarts detail ---
const ecartsDetail = ref<EcartFacture[]>([])
const ecartsLoaded = ref(false)

// --- Depannage detection ---
const detectingDepannage = ref(false)

const STATUT_CONFIG: Record<StatutRapprochement, { label: string; color: string; bg: string }> = {
  non_rapprochee: { label: 'Non rapprochee', color: '#6B7280', bg: '#F3F4F6' },
  rapprochee: { label: 'Rapprochee', color: '#15803D', bg: '#DCFCE7' },
  ecart_detecte: { label: 'Ecart', color: '#B45309', bg: '#FEF3C7' },
  depannage: { label: 'Depannage', color: '#DC2626', bg: '#FEE2E2' },
}

const filtered = computed(() => {
  let results: FacturePennylane[]

  switch (activeTab.value) {
    case 'non_rapprochees':
      results = facturesStore.nonRapprochees
      break
    case 'ecarts':
      results = facturesStore.ecarts
      break
    case 'depannage':
      results = facturesStore.depannages
      break
    default:
      results = facturesStore.factures
  }

  if (search.value) {
    const q = search.value.toLowerCase()
    results = results.filter(f =>
      (f.numero?.toLowerCase().includes(q)) ||
      getFournisseurNom(f.fournisseur_id).toLowerCase().includes(q)
    )
  }

  return results
})

const tabCounts = computed(() => ({
  toutes: facturesStore.factures.length,
  non_rapprochees: facturesStore.nonRapprochees.length,
  ecarts: facturesStore.ecarts.length,
  depannage: facturesStore.depannages.length,
}))

// --- Cost comparison: real vs theoretical ---
const coutComparison = computed(() => {
  const mois = facturesStore.currentMonthFactures
  const totalFacturesHt = mois.reduce((s, f) => s + f.montant_ht, 0)

  // Theoretical = sum of commandes HT for the same month
  const now = new Date()
  const year = now.getFullYear()
  const month = now.getMonth()
  const commandesMois = commandesStore.commandes.filter(c => {
    if (!c.date_commande) return false
    const d = new Date(c.date_commande)
    return d.getFullYear() === year && d.getMonth() === month
  })
  const totalCommandesHt = commandesMois.reduce((s, c) => s + c.montant_total_ht, 0)

  const ecart = totalCommandesHt > 0
    ? ((totalFacturesHt - totalCommandesHt) / totalCommandesHt) * 100
    : 0

  return {
    reel: totalFacturesHt,
    theorique: totalCommandesHt,
    ecart,
  }
})

// --- Helpers ---
function getFournisseurNom(id: string | null) {
  if (!id) return 'Inconnu'
  return fournisseursStore.getById(id)?.nom || 'Inconnu'
}

function formatDate(date: string | null) {
  if (!date) return '--'
  return new Date(date).toLocaleDateString('fr-FR', { day: 'numeric', month: 'short', year: 'numeric' })
}

function formatMontant(montant: number) {
  return montant.toLocaleString('fr-FR', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + ' \u20AC'
}

function formatPct(pct: number) {
  const sign = pct > 0 ? '+' : ''
  return sign + pct.toFixed(1) + ' %'
}

// --- Rapprochement flow ---
async function openRapprochement(facture: FacturePennylane) {
  selectedFacture.value = facture
  showRapprochement.value = true
  rapprochementLoading.value = true

  try {
    // Fetch receptions for this fournisseur that are not yet linked to an invoice
    let path = 'receptions?select=*,commandes!inner(numero,montant_total_ht,fournisseur_id)&validee=eq.true&order=date_reception.desc&limit=20'

    // Filter by fournisseur if available
    if (facture.fournisseur_id) {
      path += `&commandes.fournisseur_id=eq.${facture.fournisseur_id}`
    }

    const data = await restCall<Record<string, unknown>[]>('GET', path)

    matchingReceptions.value = (data || []).map((r: Record<string, unknown>) => {
      const cmd = r.commandes as Record<string, unknown> | null
      return {
        ...r,
        commande_numero: cmd?.numero as string | undefined,
        commande_montant_ht: cmd?.montant_total_ht as number | undefined,
      } as Reception & { commande_numero?: string; commande_montant_ht?: number }
    })
  } catch {
    matchingReceptions.value = []
  } finally {
    rapprochementLoading.value = false
  }
}

async function confirmRapprochement(receptionId: string) {
  if (!selectedFacture.value) return
  rapprochementLoading.value = true
  try {
    const result = await facturesStore.rapprocher(selectedFacture.value.id, receptionId)
    if (result.statut === 'ecart_detecte') {
      alert(`Rapprochement effectue avec ecart detecte : ${result.ecartPct.toFixed(1)}%`)
    }
    showRapprochement.value = false
    selectedFacture.value = null
  } catch (e) {
    alert('Erreur lors du rapprochement')
    console.error(e)
  } finally {
    rapprochementLoading.value = false
  }
}

function closeRapprochement() {
  showRapprochement.value = false
  selectedFacture.value = null
  matchingReceptions.value = []
}

// --- Ecarts loading ---
async function loadEcarts() {
  if (ecartsLoaded.value) return
  ecartsDetail.value = await facturesStore.getEcarts()
  ecartsLoaded.value = true
}

// --- Depannage detection ---
async function runDetectionDepannage() {
  detectingDepannage.value = true
  try {
    const count = await facturesStore.detecterDepannage()
    if (count > 0) {
      alert(`${count} achat(s) de depannage detecte(s)`)
    } else {
      alert('Aucun nouvel achat de depannage detecte')
    }
  } catch (e) {
    alert('Erreur lors de la detection')
    console.error(e)
  } finally {
    detectingDepannage.value = false
  }
}

// --- Tab change handler ---
function switchTab(tab: TabFilter) {
  activeTab.value = tab
  if (tab === 'ecarts') {
    loadEcarts()
  }
}

onMounted(async () => {
  await Promise.all([
    facturesStore.fetchAll(),
    fournisseursStore.fetchAll(),
    commandesStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="factures-page">
    <div class="page-header">
      <h1>Factures</h1>
      <button
        class="btn-detect"
        :disabled="detectingDepannage"
        @click="runDetectionDepannage"
      >
        {{ detectingDepannage ? 'Detection...' : 'Detecter depannage' }}
      </button>
    </div>

    <!-- Summary cards -->
    <div class="summary-grid">
      <div class="summary-card">
        <span class="summary-value">{{ facturesStore.summaryMois.total }}</span>
        <span class="summary-label">Factures du mois</span>
      </div>
      <div class="summary-card summary-success">
        <span class="summary-value">{{ facturesStore.summaryMois.rapprochees }}</span>
        <span class="summary-label">Rapprochees</span>
      </div>
      <div class="summary-card summary-warning">
        <span class="summary-value">{{ facturesStore.summaryMois.ecarts }}</span>
        <span class="summary-label">Ecarts</span>
      </div>
      <div class="summary-card summary-danger">
        <span class="summary-value">{{ facturesStore.summaryMois.depannages }}</span>
        <span class="summary-label">Depannage</span>
      </div>
    </div>

    <!-- Cout reel vs theorique -->
    <div class="cout-comparison">
      <div class="cout-row">
        <span class="cout-label">Cout reel (factures du mois)</span>
        <span class="cout-value">{{ formatMontant(coutComparison.reel) }} HT</span>
      </div>
      <div class="cout-row">
        <span class="cout-label">Cout theorique (commandes)</span>
        <span class="cout-value">{{ formatMontant(coutComparison.theorique) }} HT</span>
      </div>
      <div class="cout-row cout-ecart">
        <span class="cout-label">Ecart</span>
        <span
          class="cout-value cout-ecart-value"
          :class="{
            'ecart-positif': coutComparison.ecart > 2,
            'ecart-negatif': coutComparison.ecart < -2,
            'ecart-ok': Math.abs(coutComparison.ecart) <= 2,
          }"
        >
          {{ formatPct(coutComparison.ecart) }}
        </span>
      </div>
    </div>

    <!-- Filters -->
    <div class="filters">
      <input
        v-model="search"
        type="search"
        placeholder="Rechercher facture ou fournisseur..."
        class="search-input"
      />
      <div class="tab-filters">
        <button
          class="filter-btn"
          :class="{ active: activeTab === 'toutes' }"
          @click="switchTab('toutes')"
        >
          Toutes ({{ tabCounts.toutes }})
        </button>
        <button
          class="filter-btn"
          :class="{ active: activeTab === 'non_rapprochees' }"
          @click="switchTab('non_rapprochees')"
        >
          Non rapprochees ({{ tabCounts.non_rapprochees }})
        </button>
        <button
          class="filter-btn"
          :class="{ active: activeTab === 'ecarts' }"
          @click="switchTab('ecarts')"
        >
          Ecarts ({{ tabCounts.ecarts }})
        </button>
        <button
          class="filter-btn"
          :class="{ active: activeTab === 'depannage' }"
          @click="switchTab('depannage')"
        >
          Depannage ({{ tabCounts.depannage }})
        </button>
      </div>
    </div>

    <!-- Loading state -->
    <div v-if="facturesStore.loading" class="loading">Chargement des factures...</div>

    <!-- Empty state -->
    <div v-else-if="filtered.length === 0" class="empty">
      <p>Aucune facture{{ search || activeTab !== 'toutes' ? ' trouvee' : '' }}.</p>
      <p v-if="activeTab === 'toutes' && !search">
        Les factures sont synchronisees automatiquement depuis PennyLane.
      </p>
    </div>

    <!-- Factures list -->
    <div v-else class="facture-list">
      <div
        v-for="f in filtered"
        :key="f.id"
        class="facture-card"
        @click="f.statut_rapprochement === 'non_rapprochee' ? openRapprochement(f) : undefined"
        :class="{ clickable: f.statut_rapprochement === 'non_rapprochee' }"
      >
        <div class="card-top">
          <span class="card-numero">{{ f.numero || f.pennylane_id }}</span>
          <span
            class="badge-statut"
            :style="{
              background: STATUT_CONFIG[f.statut_rapprochement].bg,
              color: STATUT_CONFIG[f.statut_rapprochement].color,
            }"
          >
            {{ STATUT_CONFIG[f.statut_rapprochement].label }}
          </span>
        </div>
        <div class="card-fournisseur">{{ getFournisseurNom(f.fournisseur_id) }}</div>
        <div class="card-bottom">
          <span class="card-date">{{ formatDate(f.date_facture) }}</span>
          <span class="card-montants">
            <span class="montant-ht">{{ formatMontant(f.montant_ht) }} HT</span>
            <span class="montant-ttc">{{ formatMontant(f.montant_ttc) }} TTC</span>
          </span>
        </div>
      </div>
    </div>

    <!-- Depannage section (visible when on depannage tab) -->
    <div v-if="activeTab === 'depannage' && facturesStore.achatsHorsCommande.length > 0" class="depannage-section">
      <h2>Achats hors commande</h2>
      <div class="depannage-list">
        <div
          v-for="achat in facturesStore.achatsHorsCommande"
          :key="achat.id"
          class="depannage-card"
        >
          <div class="depannage-top">
            <span class="depannage-fournisseur">{{ achat.fournisseur_nom }}</span>
            <span class="depannage-montant">{{ formatMontant(achat.montant_ht) }} HT</span>
          </div>
          <div class="depannage-bottom">
            <span class="depannage-date">{{ formatDate(achat.date_achat) }}</span>
            <span v-if="achat.description" class="depannage-desc">{{ achat.description }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Ecarts detail (visible when on ecarts tab) -->
    <div v-if="activeTab === 'ecarts' && ecartsDetail.length > 0" class="ecarts-section">
      <h2>Detail des ecarts</h2>
      <div class="ecarts-table">
        <div class="ecarts-header">
          <span class="col-facture">Facture</span>
          <span class="col-montant">Facture HT</span>
          <span class="col-montant">Commande HT</span>
          <span class="col-ecart">Ecart</span>
        </div>
        <div
          v-for="e in ecartsDetail"
          :key="e.facture.id"
          class="ecarts-row"
        >
          <span class="col-facture">{{ e.facture.numero || e.facture.pennylane_id }}</span>
          <span class="col-montant">{{ formatMontant(e.facture.montant_ht) }}</span>
          <span class="col-montant">{{ formatMontant(e.commandeMontantHt) }}</span>
          <span
            class="col-ecart"
            :class="{ 'ecart-positif': e.ecartPct > 0, 'ecart-negatif': e.ecartPct < 0 }"
          >
            {{ formatPct(e.ecartPct) }}
          </span>
        </div>
      </div>
    </div>

    <!-- Rapprochement modal overlay -->
    <Teleport to="body">
      <div v-if="showRapprochement" class="modal-overlay" @click.self="closeRapprochement">
        <div class="modal-content">
          <div class="modal-header">
            <h2>Rapprochement</h2>
            <button class="btn-close" @click="closeRapprochement">X</button>
          </div>

          <div v-if="selectedFacture" class="modal-facture-info">
            <p><strong>Facture :</strong> {{ selectedFacture.numero || selectedFacture.pennylane_id }}</p>
            <p><strong>Fournisseur :</strong> {{ getFournisseurNom(selectedFacture.fournisseur_id) }}</p>
            <p><strong>Montant :</strong> {{ formatMontant(selectedFacture.montant_ht) }} HT</p>
            <p><strong>Date :</strong> {{ formatDate(selectedFacture.date_facture) }}</p>
          </div>

          <div v-if="rapprochementLoading" class="modal-loading">
            Recherche des receptions correspondantes...
          </div>

          <div v-else-if="matchingReceptions.length === 0" class="modal-empty">
            Aucune reception trouvee pour ce fournisseur.
          </div>

          <div v-else class="modal-receptions">
            <h3>Receptions disponibles</h3>
            <div
              v-for="rec in matchingReceptions"
              :key="rec.id"
              class="reception-option"
              @click="confirmRapprochement(rec.id)"
            >
              <div class="reception-top">
                <span class="reception-numero">{{ rec.commande_numero || '---' }}</span>
                <span class="reception-date">{{ formatDate(rec.date_reception) }}</span>
              </div>
              <div class="reception-bottom">
                <span class="reception-montant">
                  {{ rec.commande_montant_ht != null ? formatMontant(rec.commande_montant_ht) + ' HT' : '---' }}
                </span>
                <span
                  v-if="selectedFacture && rec.commande_montant_ht != null"
                  class="reception-ecart"
                  :class="{
                    'ecart-ok': Math.abs(selectedFacture.montant_ht - rec.commande_montant_ht) / rec.commande_montant_ht <= 0.02,
                    'ecart-positif': (selectedFacture.montant_ht - rec.commande_montant_ht) / rec.commande_montant_ht > 0.02,
                    'ecart-negatif': (selectedFacture.montant_ht - rec.commande_montant_ht) / rec.commande_montant_ht < -0.02,
                  }"
                >
                  {{ formatPct(((selectedFacture.montant_ht - rec.commande_montant_ht) / rec.commande_montant_ht) * 100) }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
/* --- Page layout --- */
.factures-page {
  max-width: 960px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 28px;
}

.btn-detect {
  background: var(--color-danger);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 20px;
  font-size: 15px;
  font-weight: 700;
  cursor: pointer;
  white-space: nowrap;
}

.btn-detect:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* --- Summary grid --- */
.summary-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 16px;
}

.summary-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px;
  text-align: center;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.summary-value {
  display: block;
  font-size: 32px;
  font-weight: 800;
  line-height: 1.2;
}

.summary-label {
  display: block;
  font-size: 13px;
  color: var(--text-secondary);
  margin-top: 4px;
}

.summary-success .summary-value { color: var(--color-success); }
.summary-warning .summary-value { color: var(--color-warning); }
.summary-danger .summary-value { color: var(--color-danger); }

/* --- Cout comparison --- */
.cout-comparison {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px 20px;
  margin-bottom: 20px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.cout-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 8px 0;
}

.cout-row + .cout-row {
  border-top: 1px solid var(--border);
}

.cout-label {
  font-size: 15px;
  color: var(--text-secondary);
}

.cout-value {
  font-size: 17px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}

.cout-ecart {
  border-top: 2px solid var(--border) !important;
  padding-top: 12px;
}

.cout-ecart-value {
  font-size: 20px;
}

.ecart-positif { color: var(--color-danger); }
.ecart-negatif { color: var(--color-info, #3B82F6); }
.ecart-ok { color: var(--color-success); }

/* --- Filters --- */
.filters {
  margin-bottom: 20px;
}

.search-input {
  width: 100%;
  max-width: 440px;
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

.tab-filters {
  display: flex;
  gap: 6px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 4px;
}

.filter-btn {
  flex-shrink: 0;
  height: 44px;
  padding: 0 16px;
  border: 2px solid var(--border);
  border-radius: 22px;
  background: var(--bg-surface);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}

.filter-btn.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

/* --- Loading / Empty --- */
.loading, .empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 60px 20px;
  font-size: 16px;
}

/* --- Facture list --- */
.facture-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.facture-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px 20px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.15s;
}

.facture-card.clickable {
  cursor: pointer;
}

.facture-card.clickable:active {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.card-numero {
  font-size: 15px;
  font-weight: 700;
  font-family: monospace;
  color: var(--text-secondary);
}

.badge-statut {
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.3px;
}

.card-fournisseur {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 8px;
}

.card-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
}

.card-date {
  font-size: 14px;
  color: var(--text-tertiary);
}

.card-montants {
  display: flex;
  gap: 16px;
  align-items: baseline;
}

.montant-ht {
  font-size: 17px;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}

.montant-ttc {
  font-size: 14px;
  color: var(--text-tertiary);
  font-variant-numeric: tabular-nums;
}

/* --- Depannage section --- */
.depannage-section {
  margin-top: 32px;
}

.depannage-section h2 {
  font-size: 22px;
  margin-bottom: 16px;
}

.depannage-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.depannage-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 14px 20px;
  border-left: 4px solid var(--color-danger);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.depannage-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}

.depannage-fournisseur {
  font-size: 17px;
  font-weight: 600;
}

.depannage-montant {
  font-size: 16px;
  font-weight: 700;
  color: var(--color-danger);
  font-variant-numeric: tabular-nums;
}

.depannage-bottom {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: var(--text-secondary);
}

.depannage-desc {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* --- Ecarts section --- */
.ecarts-section {
  margin-top: 32px;
}

.ecarts-section h2 {
  font-size: 22px;
  margin-bottom: 16px;
}

.ecarts-table {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  overflow: hidden;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.ecarts-header {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  gap: 8px;
  padding: 14px 20px;
  font-size: 13px;
  font-weight: 700;
  color: var(--text-tertiary);
  text-transform: uppercase;
  border-bottom: 2px solid var(--border);
}

.ecarts-row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  gap: 8px;
  padding: 14px 20px;
  align-items: center;
  font-size: 15px;
}

.ecarts-row + .ecarts-row {
  border-top: 1px solid var(--border);
}

.col-facture {
  font-weight: 600;
  font-family: monospace;
}

.col-montant {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.col-ecart {
  text-align: right;
  font-weight: 700;
  font-variant-numeric: tabular-nums;
}

/* --- Modal --- */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}

.modal-content {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  width: 100%;
  max-width: 600px;
  max-height: 80vh;
  overflow-y: auto;
  padding: 24px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-header h2 {
  font-size: 24px;
}

.btn-close {
  width: 48px;
  height: 48px;
  border: none;
  background: var(--bg-main);
  border-radius: 50%;
  font-size: 18px;
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-facture-info {
  background: var(--bg-main);
  border-radius: var(--radius-md);
  padding: 16px;
  margin-bottom: 20px;
}

.modal-facture-info p {
  font-size: 15px;
  margin-bottom: 4px;
}

.modal-facture-info p:last-child {
  margin-bottom: 0;
}

.modal-loading, .modal-empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 32px 16px;
  font-size: 15px;
}

.modal-receptions h3 {
  font-size: 18px;
  margin-bottom: 12px;
}

.reception-option {
  padding: 14px 16px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  margin-bottom: 8px;
  cursor: pointer;
  transition: border-color 0.15s, box-shadow 0.15s;
}

.reception-option:active {
  border-color: var(--color-primary);
  box-shadow: 0 0 0 2px rgba(232, 93, 44, 0.2);
}

.reception-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}

.reception-numero {
  font-family: monospace;
  font-weight: 700;
  font-size: 15px;
}

.reception-date {
  font-size: 14px;
  color: var(--text-tertiary);
}

.reception-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.reception-montant {
  font-size: 16px;
  font-weight: 600;
  font-variant-numeric: tabular-nums;
}

.reception-ecart {
  font-size: 14px;
  font-weight: 700;
}

/* --- Responsive: stack summary cards on narrow viewports --- */
@media (max-width: 600px) {
  .summary-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .ecarts-header,
  .ecarts-row {
    grid-template-columns: 1.5fr 1fr 1fr 0.8fr;
    font-size: 13px;
    padding: 12px 14px;
  }

  .card-montants {
    flex-direction: column;
    gap: 2px;
    align-items: flex-end;
  }
}
</style>
