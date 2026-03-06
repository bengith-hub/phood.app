<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCommandesStore } from '@/stores/commandes'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useStocksStore } from '@/stores/stocks'
import { useIngredientsStore } from '@/stores/ingredients'
import { useAuth } from '@/composables/useAuth'
import { useAutoSave } from '@/composables/useAutoSave'
import { generateCommandePdf } from '@/lib/pdf-commande'
import StockCoverageRow from './StockCoverageRow.vue'
import type { StockCoverageInfo } from './StockCoverageRow.vue'
import type { Commande, CommandeLigne, Mercuriale, Conditionnement } from '@/types/database'

const route = useRoute()
const router = useRouter()
const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()
const mercurialeStore = useMercurialeStore()
const stocksStore = useStocksStore()
const ingredientsStore = useIngredientsStore()
const { user, isManagerOrAbove } = useAuth()

const commandeId = ref<string | null>(route.params.id as string || null)
const isNew = !commandeId.value
const commande = ref<Commande | null>(null)
const selectedFournisseurId = ref<string>(route.params.fournisseurId as string || '')
const dateLivraison = ref('')
const notes = ref('')
const searchQuery = ref('')
const showPdfModal = ref(false)
const pdfBlobUrl = ref<string | null>(null)
const showStockDetails = ref(false)

// Ligne items: mercuriale_id -> quantity
interface LigneEdit {
  mercuriale_id: string
  quantite: number
  conditionnement_idx: number
  prix_unitaire_ht: number
  tva: number
}
const lignes = ref<Map<string, LigneEdit>>(new Map())

const fournisseur = computed(() =>
  fournisseursStore.getById(selectedFournisseurId.value)
)

const francoMinimum = computed(() => fournisseur.value?.franco_minimum || 0)

const totalHT = computed(() => {
  let sum = 0
  for (const l of lignes.value.values()) {
    if (l.quantite > 0) {
      sum += l.quantite * l.prix_unitaire_ht
    }
  }
  return sum
})

const totalTTC = computed(() => {
  let sum = 0
  for (const l of lignes.value.values()) {
    if (l.quantite > 0) {
      sum += l.quantite * l.prix_unitaire_ht * (1 + l.tva / 100)
    }
  }
  return sum
})

const francoAtteint = computed(() => totalHT.value >= francoMinimum.value)
const francoManquant = computed(() => Math.max(0, francoMinimum.value - totalHT.value))

const isDraft = computed(() => !commande.value || commande.value.statut === 'brouillon')

// Products from mercuriale for selected supplier
const produits = computed(() => {
  if (!selectedFournisseurId.value) return []
  return mercurialeStore.groupedByCategorie(selectedFournisseurId.value)
})

const filteredProduits = computed(() => {
  if (!searchQuery.value) return produits.value
  const q = searchQuery.value.toLowerCase()
  return produits.value
    .map(g => ({
      categorie: g.categorie,
      produits: g.produits.filter(p =>
        p.designation.toLowerCase().includes(q)
      ),
    }))
    .filter(g => g.produits.length > 0)
})

const nbArticles = computed(() => {
  let count = 0
  for (const l of lignes.value.values()) {
    if (l.quantite > 0) count++
  }
  return count
})

// Auto-save for draft data
const autoSaveData = computed(() => ({
  fournisseur_id: selectedFournisseurId.value,
  date_livraison_prevue: dateLivraison.value,
  notes: notes.value,
  montant_total_ht: totalHT.value,
  montant_total_ttc: totalTTC.value,
}))

const { status: saveStatus } = useAutoSave(autoSaveData, {
  table: 'commandes',
  id: commandeId,
  intervalMs: 5000,
})

// ─── Stock coverage & rotation helpers (section 7.5) ───

/**
 * Estimate average daily consumption for an ingredient.
 * Uses a simple heuristic: look at current stock and tampon to derive
 * an approximate daily usage. In a full implementation, this would come
 * from historical sales data (tickets Zelty decomposed into ingredients).
 */
function getConsoMoyenneJour(ingredientId: string): number {
  const ing = ingredientsStore.getById(ingredientId)
  if (!ing) return 0
  // Heuristic: tampon typically covers 2-3 days of safety stock
  // So average daily conso ~ tampon / 2
  const tampon = ing.stock_tampon
  if (tampon <= 0) return 0
  return tampon / 2
}

function getStockCoverage(produit: Mercuriale, qtyCommandee: number): StockCoverageInfo | null {
  const ingredientId = produit.ingredient_restaurant_id
  if (!ingredientId) return null

  const ing = ingredientsStore.getById(ingredientId)
  if (!ing) return null

  const stock = stocksStore.getByIngredient(ingredientId)
  const stockActuel = stock?.quantite ?? 0
  const stockTampon = ing.stock_tampon
  const consoJour = getConsoMoyenneJour(ingredientId)
  const previsionConso3j = consoJour * 3

  // Recommendation: enough to cover 5 days above tampon
  const targetStock = stockTampon + consoJour * 5
  const recommandationQty = Math.max(0, Math.ceil(targetStock - stockActuel))

  // Convert commanded qty from order units to stock units
  const qtyEnUniteStock = qtyCommandee * produit.coefficient_conversion

  // Coverage date
  let dateCouverture: string | null = null
  let coverageOk = false

  if (consoJour > 0 && dateLivraison.value) {
    const livDate = new Date(dateLivraison.value)
    const stockApresLivraison = stockActuel + qtyEnUniteStock - stockTampon
    const joursCouverts = Math.floor(stockApresLivraison / consoJour)
    const coverageDate = new Date(livDate)
    coverageDate.setDate(coverageDate.getDate() + Math.max(0, joursCouverts))
    dateCouverture = coverageDate.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })

    // Check if coverage extends past estimated next delivery (assume 3-5 day cycle)
    const prochaineLivraison = new Date(livDate)
    prochaineLivraison.setDate(prochaineLivraison.getDate() + 4) // approximate
    coverageOk = coverageDate.getTime() >= prochaineLivraison.getTime()
  }

  // Rotation: how long does one order unit last
  let rotationJours: number | null = null
  let rotationLabel = ''
  let rotationIcon = ''

  if (consoJour > 0) {
    const conditionUnit = produit.coefficient_conversion
    rotationJours = conditionUnit / consoJour

    if (rotationJours < 7) {
      rotationLabel = 'Rapide'
      rotationIcon = '\uD83D\uDD34'
    } else if (rotationJours <= 60) {
      rotationLabel = 'Moyenne'
      rotationIcon = '\uD83D\uDFE1'
    } else {
      rotationLabel = 'Lente'
      rotationIcon = '\uD83D\uDFE2'
    }
  }

  return {
    stockActuel,
    stockTampon,
    previsionConso3j,
    recommandationQty,
    dateCouverture,
    rotationJours,
    rotationLabel,
    rotationIcon,
    coverageOk,
    unite: ing.unite_stock,
  }
}

// ─── Quantity helpers ───

function getQuantite(mercurialeId: string): number {
  return lignes.value.get(mercurialeId)?.quantite || 0
}

function setQuantite(produit: Mercuriale, qty: number) {
  if (qty <= 0) {
    lignes.value.delete(produit.id)
    return
  }
  const conds = produit.conditionnements as Conditionnement[]
  const defaultIdx = conds.findIndex(c => c.utilise_commande) ?? 0
  lignes.value.set(produit.id, {
    mercuriale_id: produit.id,
    quantite: qty,
    conditionnement_idx: Math.max(0, defaultIdx),
    prix_unitaire_ht: produit.prix_unitaire_ht,
    tva: produit.tva,
  })
}

function increment(produit: Mercuriale) {
  setQuantite(produit, getQuantite(produit.id) + 1)
}

function decrement(produit: Mercuriale) {
  const current = getQuantite(produit.id)
  if (current > 0) setQuantite(produit, current - 1)
}

function getCondLabel(produit: Mercuriale): string {
  const conds = produit.conditionnements as Conditionnement[]
  if (!conds || conds.length === 0) return produit.unite_stock
  const cond = conds.find(c => c.utilise_commande) ?? conds[0]
  return cond?.nom ?? produit.unite_stock
}

// ─── PDF preview ───

function handlePdfPreview() {
  if (!commandeId.value || !fournisseur.value) return

  const lignesArray: CommandeLigne[] = []
  for (const l of lignes.value.values()) {
    if (l.quantite > 0) {
      const montantHt = l.quantite * l.prix_unitaire_ht
      lignesArray.push({
        id: '',
        commande_id: commandeId.value,
        mercuriale_id: l.mercuriale_id,
        quantite: l.quantite,
        conditionnement_idx: l.conditionnement_idx,
        prix_unitaire_ht: l.prix_unitaire_ht,
        montant_ht: montantHt,
        montant_ttc: montantHt * (1 + l.tva / 100),
        created_at: '',
      })
    }
  }

  const commandeData: Commande = commande.value || {
    id: commandeId.value,
    numero: commandeId.value,
    fournisseur_id: selectedFournisseurId.value,
    statut: 'brouillon',
    date_commande: new Date().toISOString().slice(0, 10),
    date_livraison_prevue: dateLivraison.value || null,
    montant_total_ht: totalHT.value,
    montant_total_ttc: totalTTC.value,
    notes: notes.value || null,
    pdf_url: null,
    created_by: user.value?.id || '',
    locked_by: null,
    locked_at: null,
    created_at: '',
    updated_at: '',
  }

  const pdf = generateCommandePdf({
    commande: commandeData,
    lignes: lignesArray,
    fournisseur: fournisseur.value,
    getMercuriale: (id: string) => mercurialeStore.getById(id),
  })

  // Clean up previous blob URL
  if (pdfBlobUrl.value) {
    URL.revokeObjectURL(pdfBlobUrl.value)
  }

  const blob = pdf.output('blob')
  pdfBlobUrl.value = URL.createObjectURL(blob)
  showPdfModal.value = true
}

function closePdfModal() {
  showPdfModal.value = false
}

function openPdfNewTab() {
  if (pdfBlobUrl.value) {
    window.open(pdfBlobUrl.value, '_blank')
  }
}

// ─── Actions ───

async function handleEnvoyer() {
  if (!commandeId.value || !francoAtteint.value) return

  // Save lines first
  const lignesArray: Partial<CommandeLigne>[] = []
  for (const l of lignes.value.values()) {
    if (l.quantite > 0) {
      const montantHt = l.quantite * l.prix_unitaire_ht
      lignesArray.push({
        mercuriale_id: l.mercuriale_id,
        quantite: l.quantite,
        conditionnement_idx: l.conditionnement_idx,
        prix_unitaire_ht: l.prix_unitaire_ht,
        montant_ht: montantHt,
        montant_ttc: montantHt * (1 + l.tva / 100),
      })
    }
  }
  await commandesStore.saveLignes(commandeId.value, lignesArray)

  // TODO: Generate PDF and send email
  // For now just update status
  await commandesStore.updateStatut(commandeId.value, 'envoyee')
  router.push('/commandes')
}

async function handleSaveDraft() {
  if (!commandeId.value) return

  const lignesArray: Partial<CommandeLigne>[] = []
  for (const l of lignes.value.values()) {
    if (l.quantite > 0) {
      const montantHt = l.quantite * l.prix_unitaire_ht
      lignesArray.push({
        mercuriale_id: l.mercuriale_id,
        quantite: l.quantite,
        conditionnement_idx: l.conditionnement_idx,
        prix_unitaire_ht: l.prix_unitaire_ht,
        montant_ht: montantHt,
        montant_ttc: montantHt * (1 + l.tva / 100),
      })
    }
  }
  await commandesStore.saveLignes(commandeId.value, lignesArray)
  await commandesStore.updateCommande(commandeId.value, {
    date_livraison_prevue: dateLivraison.value || null,
    notes: notes.value || null,
  })
}

onMounted(async () => {
  await Promise.all([
    fournisseursStore.fetchAll(),
    mercurialeStore.fetchAll(),
    commandesStore.fetchAll(),
    stocksStore.fetchAll(),
    ingredientsStore.fetchAll(),
  ])

  if (commandeId.value) {
    // Editing existing order
    commande.value = commandesStore.getById(commandeId.value) || null
    if (commande.value) {
      selectedFournisseurId.value = commande.value.fournisseur_id
      dateLivraison.value = commande.value.date_livraison_prevue || ''
      notes.value = commande.value.notes || ''

      // Load existing lines
      const existingLignes = await commandesStore.fetchLignes(commandeId.value)
      for (const l of existingLignes) {
        lignes.value.set(l.mercuriale_id, {
          mercuriale_id: l.mercuriale_id,
          quantite: l.quantite,
          conditionnement_idx: l.conditionnement_idx,
          prix_unitaire_ht: l.prix_unitaire_ht,
          tva: mercurialeStore.getById(l.mercuriale_id)?.tva || 5.5,
        })
      }
    }
  }
})

// Auto-create brouillon when fournisseur selected for new order
watch(selectedFournisseurId, async (newId) => {
  if (isNew && newId && user.value && !commandeId.value) {
    try {
      const cmd = await commandesStore.createBrouillon(newId, user.value.id)
      commande.value = cmd
      commandeId.value = cmd.id
      // Update URL without full navigation
      window.history.replaceState({}, '', `/commandes/${cmd.id}`)
    } catch (e) {
      console.error('Failed to create draft:', e)
    }
  }
})
</script>

<template>
  <div class="commande-edit">
    <!-- Header -->
    <div class="page-header">
      <div>
        <button class="btn-back" @click="router.push('/commandes')">&#x2190; Retour</button>
        <h1>{{ commande?.numero || 'Nouvelle commande' }}</h1>
      </div>
      <div class="header-actions">
        <span class="save-status" :class="saveStatus">
          {{ saveStatus === 'saved' ? 'Sauvegard\u00E9' : saveStatus === 'saving' ? 'Sauvegarde...' : saveStatus === 'offline' ? 'Hors-ligne' : 'Erreur' }}
        </span>
      </div>
    </div>

    <!-- Step 1: Select fournisseur (for new orders) -->
    <div v-if="isNew && !selectedFournisseurId" class="step-fournisseur">
      <h2>Choisir un fournisseur</h2>
      <div class="fournisseur-grid">
        <button
          v-for="f in fournisseursStore.actifs"
          :key="f.id"
          class="fournisseur-btn"
          @click="selectedFournisseurId = f.id"
        >
          <span class="f-name">{{ f.nom }}</span>
          <span v-if="f.franco_minimum > 0" class="f-franco">Franco {{ f.franco_minimum }} &#x20AC;</span>
        </button>
      </div>
    </div>

    <!-- Step 2: Order form -->
    <div v-else-if="selectedFournisseurId" class="order-form">
      <!-- Fournisseur info bar -->
      <div class="info-bar">
        <span class="info-fournisseur">{{ fournisseur?.nom }}</span>
        <div class="info-meta">
          <label>Livraison pr&eacute;vue :
            <input v-model="dateLivraison" type="date" class="date-input" />
          </label>
        </div>
      </div>

      <!-- Franco indicator -->
      <div class="franco-bar" :class="{ ok: francoAtteint, blocked: !francoAtteint && nbArticles > 0 }">
        <div class="franco-progress">
          <div
            class="franco-fill"
            :style="{ width: `${Math.min(100, (totalHT / Math.max(francoMinimum, 1)) * 100)}%` }"
          />
        </div>
        <div class="franco-text">
          <span v-if="francoMinimum > 0">
            {{ totalHT.toFixed(2) }} &#x20AC; / {{ francoMinimum.toFixed(0) }} &#x20AC; franco
            <span v-if="!francoAtteint && nbArticles > 0" class="franco-manquant">
              (manque {{ francoManquant.toFixed(2) }} &#x20AC;)
            </span>
          </span>
          <span v-else>{{ totalHT.toFixed(2) }} &#x20AC; HT</span>
          <span class="article-count">{{ nbArticles }} article{{ nbArticles > 1 ? 's' : '' }}</span>
        </div>
      </div>

      <!-- Stock details toggle -->
      <button class="btn-toggle-stock" @click="showStockDetails = !showStockDetails">
        {{ showStockDetails ? 'Masquer les stocks' : 'Afficher les stocks' }}
      </button>

      <!-- Search -->
      <input
        v-model="searchQuery"
        type="search"
        placeholder="Rechercher un produit..."
        class="search-input"
      />

      <!-- Product list with quantities -->
      <div class="product-list">
        <div v-for="group in filteredProduits" :key="group.categorie" class="cat-group">
          <h3 class="cat-title">{{ group.categorie }}</h3>
          <div v-for="p in group.produits" :key="p.id" class="product-card">
            <div class="product-row">
              <div class="product-info">
                <span class="product-name">{{ p.designation }}</span>
                <span class="product-price">{{ p.prix_unitaire_ht.toFixed(2) }} &#x20AC;/{{ p.unite_stock }}</span>
                <span class="product-cond">{{ getCondLabel(p) }}</span>
              </div>
              <div class="qty-controls" :class="{ 'has-qty': getQuantite(p.id) > 0 }">
                <button
                  class="qty-btn minus"
                  @click="decrement(p)"
                  :disabled="!isDraft || getQuantite(p.id) === 0"
                >&#x2212;</button>
                <input
                  :value="getQuantite(p.id)"
                  @change="setQuantite(p, Math.max(0, parseInt(($event.target as HTMLInputElement).value) || 0))"
                  type="number"
                  inputmode="numeric"
                  min="0"
                  class="qty-input"
                  :disabled="!isDraft"
                />
                <button
                  class="qty-btn plus"
                  @click="increment(p)"
                  :disabled="!isDraft"
                >+</button>
              </div>
            </div>

            <!-- Stock coverage & rotation (section 7.5) -->
            <StockCoverageRow
              v-if="showStockDetails && p.ingredient_restaurant_id"
              :coverage="getStockCoverage(p, getQuantite(p.id))"
            />
          </div>
        </div>
      </div>

      <!-- Notes -->
      <div class="notes-section">
        <label>Notes</label>
        <textarea v-model="notes" rows="2" placeholder="Instructions sp\u00E9ciales..." :disabled="!isDraft" />
      </div>

      <!-- Actions -->
      <div class="actions-bar" v-if="isDraft">
        <button class="btn-secondary" @click="handleSaveDraft">
          Sauvegarder brouillon
        </button>
        <button
          class="btn-outline"
          :disabled="nbArticles === 0"
          @click="handlePdfPreview"
        >
          Aper&ccedil;u PDF
        </button>
        <button
          class="btn-primary"
          :disabled="!francoAtteint || nbArticles === 0"
          @click="handleEnvoyer"
          v-if="isManagerOrAbove"
        >
          Envoyer la commande
        </button>
      </div>
    </div>

    <!-- PDF Preview Modal -->
    <Teleport to="body">
      <Transition name="modal">
        <div v-if="showPdfModal" class="pdf-overlay" @click.self="closePdfModal">
          <div class="pdf-modal">
            <div class="pdf-modal-header">
              <h3>Aper&ccedil;u du bon de commande</h3>
              <div class="pdf-modal-actions">
                <button class="btn-outline small" @click="openPdfNewTab">
                  Ouvrir dans un nouvel onglet
                </button>
                <button class="btn-icon-close" @click="closePdfModal">&#x2715;</button>
              </div>
            </div>
            <div class="pdf-modal-body">
              <iframe
                v-if="pdfBlobUrl"
                :src="pdfBlobUrl"
                class="pdf-iframe"
                title="Aper&ccedil;u PDF commande"
              />
            </div>
          </div>
        </div>
      </Transition>
    </Teleport>
  </div>
</template>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
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
}

.save-status {
  font-size: 13px;
  padding: 4px 10px;
  border-radius: 8px;
}
.save-status.saved { background: #dcfce7; color: #166534; }
.save-status.saving { background: #fef3c7; color: #92400e; }
.save-status.offline { background: #fecaca; color: #991b1b; }
.save-status.error { background: #fecaca; color: #991b1b; }

/* Step 1: Fournisseur selection */
.step-fournisseur h2 {
  font-size: 22px;
  margin-bottom: 20px;
}

.fournisseur-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
  gap: 12px;
}

.fournisseur-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  padding: 24px 16px;
  background: var(--bg-surface);
  border: 2px solid var(--border);
  border-radius: var(--radius-lg);
  cursor: pointer;
  transition: border-color 0.15s;
}

.fournisseur-btn:active {
  border-color: var(--color-primary);
}

.f-name {
  font-size: 18px;
  font-weight: 700;
}

.f-franco {
  font-size: 13px;
  color: var(--text-tertiary);
}

/* Order form */
.info-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: var(--bg-surface);
  padding: 16px 20px;
  border-radius: var(--radius-md);
  margin-bottom: 12px;
}

.info-fournisseur {
  font-size: 20px;
  font-weight: 700;
}

.date-input {
  height: 44px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 12px;
  font-size: 16px;
  margin-left: 8px;
}

/* Franco bar */
.franco-bar {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 12px 20px;
  margin-bottom: 12px;
}

.franco-progress {
  height: 8px;
  background: var(--bg-main);
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 8px;
}

.franco-fill {
  height: 100%;
  border-radius: 4px;
  background: var(--color-warning);
  transition: width 0.3s;
}

.franco-bar.ok .franco-fill {
  background: var(--color-success);
}

.franco-bar.blocked .franco-fill {
  background: var(--color-danger);
}

.franco-text {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: var(--text-secondary);
}

.franco-manquant {
  color: var(--color-danger);
  font-weight: 600;
}

.article-count {
  font-weight: 600;
}

/* Stock toggle */
.btn-toggle-stock {
  display: block;
  width: 100%;
  padding: 10px 16px;
  background: var(--bg-surface);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  margin-bottom: 12px;
  text-align: center;
}

.btn-toggle-stock:active {
  background: var(--bg-main);
}

/* Search */
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

.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

/* Product list */
.cat-group {
  margin-bottom: 16px;
}

.cat-title {
  font-size: 15px;
  font-weight: 700;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
  padding-left: 4px;
}

.product-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  margin-bottom: 6px;
  overflow: hidden;
}

.product-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
}

.product-info {
  flex: 1;
  min-width: 0;
}

.product-name {
  display: block;
  font-size: 16px;
  font-weight: 600;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.product-price {
  font-size: 14px;
  color: var(--color-primary);
  font-weight: 600;
}

.product-cond {
  font-size: 12px;
  color: var(--text-tertiary);
  margin-left: 8px;
}

/* Quantity controls */
.qty-controls {
  display: flex;
  align-items: center;
  gap: 0;
  flex-shrink: 0;
  margin-left: 12px;
}

.qty-btn {
  width: 52px;
  height: 52px;
  border: 2px solid var(--border);
  background: var(--bg-main);
  font-size: 24px;
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.1s;
}

.qty-btn.minus {
  border-radius: var(--radius-md) 0 0 var(--radius-md);
}

.qty-btn.plus {
  border-radius: 0 var(--radius-md) var(--radius-md) 0;
}

.qty-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.qty-controls.has-qty .qty-btn.plus {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.qty-input {
  width: 64px;
  height: 52px;
  border: 2px solid var(--border);
  border-left: none;
  border-right: none;
  text-align: center;
  font-size: 20px;
  font-weight: 700;
  background: var(--bg-surface);
  -moz-appearance: textfield;
}

.qty-input::-webkit-outer-spin-button,
.qty-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}

/* Notes */
.notes-section {
  margin-top: 16px;
}

.notes-section label {
  font-size: 15px;
  font-weight: 600;
  display: block;
  margin-bottom: 6px;
}

.notes-section textarea {
  width: 100%;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 12px 16px;
  font-size: 16px;
  resize: vertical;
  background: var(--bg-surface);
}

/* Actions */
.actions-bar {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid var(--border);
  position: sticky;
  bottom: 0;
  background: var(--bg-main);
  padding-bottom: 16px;
}

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
  background: transparent;
  color: var(--color-primary);
  border: 2px solid var(--color-primary);
  border-radius: var(--radius-md);
  padding: 14px 28px;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
}

.btn-outline:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.btn-outline.small {
  padding: 8px 16px;
  font-size: 14px;
}

/* PDF Modal */
.pdf-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
}

.pdf-modal {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  width: 100%;
  max-width: 900px;
  height: 85vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.pdf-modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}

.pdf-modal-header h3 {
  font-size: 18px;
  font-weight: 700;
  margin: 0;
}

.pdf-modal-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.btn-icon-close {
  width: 40px;
  height: 40px;
  border: none;
  background: var(--bg-main);
  border-radius: 50%;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-secondary);
}

.pdf-modal-body {
  flex: 1;
  overflow: hidden;
}

.pdf-iframe {
  width: 100%;
  height: 100%;
  border: none;
}

/* Modal transition */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.2s ease;
}
.modal-enter-active .pdf-modal,
.modal-leave-active .pdf-modal {
  transition: transform 0.25s ease;
}
.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}
.modal-enter-from .pdf-modal,
.modal-leave-to .pdf-modal {
  transform: scale(0.95);
}
</style>
