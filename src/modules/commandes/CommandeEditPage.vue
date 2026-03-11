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
import { useLocking } from '@/composables/useLocking'
import { toStockUnits, getConditioningUnit, fromStockUnits } from '@/lib/unit-conversion'
import StockCoverageRow from './StockCoverageRow.vue'
import type { StockCoverageInfo } from './StockCoverageRow.vue'
import type { Commande, CommandeLigne, Mercuriale, Conditionnement, Fournisseur, IngredientRestaurant } from '@/types/database'

/** Get logo URL from fournisseur's site_web via icon.horse (free, reliable) */
function getLogoUrl(f: Partial<Fournisseur> | Fournisseur | null | undefined): string | null {
  const site = f?.site_web
  if (!site) return null
  try {
    const url = site.includes('://') ? site : `https://${site}`
    const domain = new URL(url).hostname.replace(/^www\./, '')
    if (!domain || !domain.includes('.')) return null
    return `https://icon.horse/icon/${domain}`
  } catch {
    return null
  }
}

const route = useRoute()
const router = useRouter()
const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()
const mercurialeStore = useMercurialeStore()
const stocksStore = useStocksStore()
const ingredientsStore = useIngredientsStore()
const { user, isManagerOrAbove, isAdmin, profile } = useAuth()
const { lockedBy, isLocked, isMyLock, acquireLock } = useLocking('commande')

const commandeId = ref<string | null>(route.params.id as string || null)
const isNew = !commandeId.value
const commande = ref<Commande | null>(null)
const selectedFournisseurId = ref<string>(route.params.fournisseurId as string || '')
function toLocalDateStr(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}
const dateLivraison = ref('')
const dateLivraisonError = ref('')
const searchQuery = ref('')
const showStockDetails = ref(false)
const dateFinCouverture = ref('')
const COUVERTURE_DEFAUT_JOURS = 5

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

// ─── FIX 5: Order day/time verification (blocking + admin override) ───

const forceEnvoi = ref(false)

function computeProchainCreneau(f: Fournisseur): string {
  const jours = f.jours_commande || []
  const heure = f.heure_limite_commande || '23:59'
  const noms = ['dim', 'lun', 'mar', 'mer', 'jeu', 'ven', 'sam']
  if (jours.length === 0) return ''
  const now = new Date()
  for (let i = 0; i <= 7; i++) {
    const d = new Date(now)
    d.setDate(d.getDate() + i)
    const jour = d.getDay()
    if (jours.includes(jour)) {
      if (i === 0) {
        const heureActuelle = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`
        if (heureActuelle > heure) continue
      }
      return `Prochain : ${noms[jour]} avant ${heure}`
    }
  }
  return ''
}

const commandeAutorisee = computed(() => {
  if (!fournisseur.value) return { ok: true, message: '' }
  const f = fournisseur.value
  const now = new Date()
  const jourActuel = now.getDay()
  const heureActuelle = `${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}`

  const joursOk = !f.jours_commande?.length || f.jours_commande.includes(jourActuel)
  const heureOk = !f.heure_limite_commande || heureActuelle <= f.heure_limite_commande

  if (!joursOk || !heureOk) {
    const prochainMsg = computeProchainCreneau(f)
    return { ok: false, message: `Hors cr\u00e9neau commande pour ce fournisseur. ${prochainMsg}` }
  }
  return { ok: true, message: '' }
})

// ─── FIX 6: Toggle pre-fill with recommendations ───

const prefillRecommandations = ref(false)

// Coverage duration: computed from date picker or supplier default
const couvertureDefautJours = computed(() => fournisseur.value?.duree_couverture_defaut || COUVERTURE_DEFAUT_JOURS)

const dureeEnJours = computed(() => {
  if (!dateLivraison.value || !dateFinCouverture.value) return couvertureDefautJours.value
  const diff = Math.ceil((new Date(dateFinCouverture.value).getTime() - new Date(dateLivraison.value).getTime()) / 86400000)
  return Math.max(1, diff)
})

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
  fournisseur_id: selectedFournisseurId.value || null,
  date_livraison_prevue: dateLivraison.value || null,
  montant_total_ht: totalHT.value,
  montant_total_ttc: totalTTC.value,
}))

const { status: saveStatus } = useAutoSave(autoSaveData, {
  table: 'commandes',
  id: commandeId,
  intervalMs: 5000,
})

// ─── Stock en transit (commandes envoyées non réceptionnées) ───

const stockEnTransitMap = ref<Map<string, number>>(new Map())

async function loadStockEnTransit() {
  const envoyees = commandesStore.envoyees
  const map = new Map<string, number>()
  for (const cmd of envoyees) {
    if (cmd.id === commandeId.value) continue
    const cmdLignes = await commandesStore.fetchLignes(cmd.id)
    for (const l of cmdLignes) {
      const merc = mercurialeStore.getById(l.mercuriale_id)
      if (!merc?.ingredient_restaurant_id) continue
      const ing = ingredientsStore.getById(merc.ingredient_restaurant_id)
      const condUnite = getConditioningUnit(merc)
      const qtyStock = toStockUnits(l.quantite, merc.coefficient_conversion, condUnite, ing?.unite_stock || merc.unite_stock)
      const current = map.get(merc.ingredient_restaurant_id) || 0
      map.set(merc.ingredient_restaurant_id, current + qtyStock)
    }
  }
  stockEnTransitMap.value = map
}

// ─── Stock tampon variable (semaine/weekend/vacances) ───

function getStockTamponActuel(ing: IngredientRestaurant): number {
  if (!dateLivraison.value) return ing.stock_tampon
  const livDate = new Date(dateLivraison.value)
  const dayOfWeek = livDate.getDay() // 0=dim, 5=ven, 6=sam
  // Weekend (vendredi-dimanche) → stock_tampon_weekend if available
  if (dayOfWeek >= 5 || dayOfWeek === 0) {
    return ing.stock_tampon_weekend ?? ing.stock_tampon
  }
  // TODO V2: check vacances scolaires → ing.stock_tampon_vacances
  return ing.stock_tampon
}

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
  const stockTampon = getStockTamponActuel(ing)
  const consoJour = getConsoMoyenneJour(ingredientId)
  const previsionConso3j = consoJour * 3

  // Include losses (pertes_pct) in forecast — CDC §3.5
  const pertesFactor = 1 + (produit.pertes_pct || 0) / 100
  const consoPrevue = consoJour * dureeEnJours.value * pertesFactor

  // Include stock in transit (sent orders not yet received) — CDC §3.5
  const enTransit = stockEnTransitMap.value.get(ingredientId) || 0

  // Recommendation: enough to cover N days above tampon, minus stock + transit
  const targetStock = stockTampon + consoPrevue
  const recommandationQty = Math.max(0, Math.ceil(targetStock - stockActuel - enTransit))

  // Convert commanded qty from order units to stock units (with proper unit conversion)
  const condUnite = getConditioningUnit(produit)
  const qtyEnUniteStock = toStockUnits(qtyCommandee, produit.coefficient_conversion, condUnite, ing.unite_stock)

  // Alert if no recent stock data (>30 days)
  const lastUpdate = stock?.derniere_maj ? new Date(stock.derniere_maj) : null
  const thirtyDaysAgo = new Date()
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)
  const noRecentData = !lastUpdate || lastUpdate < thirtyDaysAgo

  // Coverage date
  let dateCouverture: string | null = null
  let coverageOk = false

  if (consoJour > 0 && dateLivraison.value) {
    const livDate = new Date(dateLivraison.value)
    const stockApresLivraison = stockActuel + enTransit + qtyEnUniteStock - stockTampon
    const joursCouverts = Math.floor(stockApresLivraison / consoJour)
    const coverageDate = new Date(livDate)
    coverageDate.setDate(coverageDate.getDate() + Math.max(0, joursCouverts))
    dateCouverture = coverageDate.toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })

    // Check if coverage extends past estimated next delivery
    const prochaineLivraison = new Date(livDate)
    prochaineLivraison.setDate(prochaineLivraison.getDate() + dureeEnJours.value)
    coverageOk = coverageDate.getTime() >= prochaineLivraison.getTime()
  }

  // Rotation: how long does one order unit last (in stock units)
  let rotationJours: number | null = null
  let rotationLabel = ''
  let rotationIcon = ''

  if (consoJour > 0) {
    const conditionUnitInStock = toStockUnits(1, produit.coefficient_conversion, condUnite, ing.unite_stock)
    rotationJours = conditionUnitInStock / consoJour

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
    noRecentData,
    enTransit,
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



// ─── Actions ───

async function handleDelete() {
  if (!commandeId.value) return
  const numero = commande.value?.numero || 'cette commande'
  if (!confirm(`Supprimer « ${numero} » ?\nCette action est irréversible.`)) return
  try {
    await commandesStore.remove(commandeId.value)
    router.push('/commandes')
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur de suppression')
  }
}

const sending = ref(false)
const sendError = ref<string | null>(null)

async function handleEnvoyer() {
  if (!commandeId.value || !francoAtteint.value || !fournisseur.value || !dateLivraison.value) return

  sending.value = true
  sendError.value = null

  try {
    // Save draft first, then redirect to recap/send page
    await handleSaveDraft()
    router.push(`/commandes/${commandeId.value}/envoyer`)
  } catch (e: unknown) {
    sendError.value = e instanceof Error ? e.message : 'Erreur lors de la sauvegarde'
  } finally {
    sending.value = false
  }
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

      // Load existing lines with conditionnement_idx protection (FIX 10)
      const existingLignes = await commandesStore.fetchLignes(commandeId.value)
      for (const l of existingLignes) {
        const merc = mercurialeStore.getById(l.mercuriale_id)
        const maxIdx = merc ? (merc.conditionnements?.length || 1) - 1 : 0
        const safeIdx = l.conditionnement_idx <= maxIdx
          ? l.conditionnement_idx
          : Math.max(0, merc?.conditionnements?.findIndex(c => c.utilise_commande) ?? 0)
        lignes.value.set(l.mercuriale_id, {
          mercuriale_id: l.mercuriale_id,
          quantite: l.quantite,
          conditionnement_idx: safeIdx,
          prix_unitaire_ht: l.prix_unitaire_ht,
          tva: merc?.tva || 5.5,
        })
      }

      // Initialize coverage date from delivery date + supplier default
      initDateFinCouverture()

      // Acquire realtime lock for concurrent editing prevention
      if (user.value && isDraft.value) {
        await acquireLock(commandeId.value, user.value.id, profile.value?.nom || user.value.email || '')
      }
    }
  }

  // Load stock in transit (sent orders not yet received) — FIX 2
  await loadStockEnTransit()
})

// Auto-create brouillon when fournisseur selected for new order
// Auto-set dateFinCouverture when dateLivraison changes
function initDateFinCouverture() {
  if (!dateLivraison.value) return
  const d = new Date(dateLivraison.value + 'T00:00:00')
  const fin = dateFinCouverture.value ? new Date(dateFinCouverture.value + 'T00:00:00') : null
  if (!fin || fin <= d) {
    d.setDate(d.getDate() + couvertureDefautJours.value)
    dateFinCouverture.value = toLocalDateStr(d)
  }
}

watch(dateLivraison, (val) => {
  // Prevent Sunday delivery
  if (val) {
    const d = new Date(val + 'T00:00:00')
    if (d.getDay() === 0) {
      dateLivraisonError.value = 'Le restaurant est ferme le dimanche. Choisissez un autre jour.'
      // Auto-shift to Monday
      d.setDate(d.getDate() + 1)
      dateLivraison.value = toLocalDateStr(d)
      return
    }
    dateLivraisonError.value = ''
  }
  initDateFinCouverture()
})

// When switching suppliers, recalc coverage from supplier default
watch(() => fournisseur.value?.duree_couverture_defaut, () => {
  if (dateLivraison.value) {
    const d = new Date(dateLivraison.value + 'T00:00:00')
    d.setDate(d.getDate() + couvertureDefautJours.value)
    dateFinCouverture.value = toLocalDateStr(d)
  }
})

// FIX 6: Pre-fill quantities when toggle is activated
watch(prefillRecommandations, (val) => {
  if (!val) return
  for (const group of produits.value) {
    for (const p of group.produits) {
      if (lignes.value.has(p.id)) continue // don't overwrite existing entries
      const coverage = getStockCoverage(p, 0)
      if (coverage && coverage.recommandationQty > 0) {
        const condUnite = getConditioningUnit(p)
        const ing = ingredientsStore.getById(p.ingredient_restaurant_id || '')
        const qtyCommande = Math.ceil(fromStockUnits(
          coverage.recommandationQty,
          p.coefficient_conversion,
          condUnite,
          ing?.unite_stock || p.unite_stock,
        ))
        if (qtyCommande > 0) setQuantite(p, qtyCommande)
      }
    }
  }
})

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
    <!-- Lock warning banner -->
    <div v-if="isLocked && !isMyLock" class="lock-banner">
      {{ lockedBy?.user_name || 'Un autre utilisateur' }} est en train de modifier cette commande.
      <br />Vos modifications ne seront pas sauvegardées.
    </div>

    <!-- Header -->
    <div class="page-header">
      <div>
        <button class="btn-back" @click="router.push('/commandes')">&#x2190; Retour</button>
        <h1>{{ commande?.numero || 'Nouvelle commande' }}</h1>
      </div>
      <div class="header-actions">
        <span class="save-status" :class="saveStatus">
          {{ saveStatus === 'saved' ? 'Sauvegardé' : saveStatus === 'saving' ? 'Sauvegarde...' : saveStatus === 'offline' ? 'Hors-ligne' : 'Erreur' }}
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
          <div v-if="getLogoUrl(f)" class="f-logo"><img :src="getLogoUrl(f)!" :alt="f.nom" @error="($event.target as HTMLImageElement).style.display='none'" /></div>
          <div v-else class="f-logo f-logo-placeholder">{{ f.nom.charAt(0).toUpperCase() }}</div>
          <span class="f-name">{{ f.nom }}</span>
          <span v-if="f.franco_minimum > 0" class="f-franco">Franco {{ f.franco_minimum }} &#x20AC;</span>
        </button>
      </div>
    </div>

    <!-- Step 2: Order form -->
    <div v-else-if="selectedFournisseurId" class="order-form">
      <!-- Fournisseur info bar -->
      <div class="info-bar">
        <div v-if="getLogoUrl(fournisseur)" class="info-logo"><img :src="getLogoUrl(fournisseur)!" :alt="fournisseur?.nom ?? ''" @error="($event.target as HTMLImageElement).style.display='none'" /></div>
        <span class="info-fournisseur">{{ fournisseur?.nom }}</span>
        <div class="info-meta">
          <label>Livraison pr&eacute;vue :
            <input v-model="dateLivraison" type="date" class="date-input" />
            <span v-if="dateLivraisonError" class="date-error">{{ dateLivraisonError }}</span>
          </label>
          <label>Couvrir jusqu'au :
            <input v-model="dateFinCouverture" type="date" class="date-input" :min="dateLivraison || undefined" />
          </label>
          <span v-if="dureeEnJours > 0" class="duree-info">({{ dureeEnJours }} j.)</span>
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

      <!-- FIX 5: Order time slot warning -->
      <div v-if="!commandeAutorisee.ok" class="creneau-banner">
        <span class="creneau-icon">&#x26D4;</span>
        <span>{{ commandeAutorisee.message }}</span>
        <label v-if="isAdmin" class="force-label">
          <input v-model="forceEnvoi" type="checkbox" />
          Forcer l'envoi (admin)
        </label>
      </div>

      <!-- Stock details toggle -->
      <div class="stock-actions-row">
        <button class="btn-toggle-stock" @click="showStockDetails = !showStockDetails">
          {{ showStockDetails ? 'Masquer les stocks' : 'Afficher les stocks' }}
        </button>
        <!-- FIX 6: Pre-fill toggle -->
        <label v-if="isDraft" class="prefill-toggle">
          <input v-model="prefillRecommandations" type="checkbox" />
          Pr&eacute;-remplir avec recommandations
        </label>
      </div>

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
              <div v-if="p.photo_url" class="product-thumb">
                <img :src="p.photo_url" :alt="p.designation" />
              </div>
              <div class="product-info">
                <span class="product-name">{{ p.designation }}</span>
                <span class="product-price">{{ p.prix_unitaire_ht.toFixed(2) }} &#x20AC;</span>
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

      <!-- Actions -->
      <div class="actions-bar" v-if="isDraft">
        <button
          v-if="commandeId"
          class="btn-danger-outline"
          @click="handleDelete"
        >
          Supprimer
        </button>
        <button class="btn-secondary" @click="handleSaveDraft">
          Sauvegarder brouillon
        </button>
        <button
          class="btn-primary"
          :disabled="!francoAtteint || !dateLivraison || nbArticles === 0 || sending || (!commandeAutorisee.ok && !forceEnvoi)"
          @click="handleEnvoyer"
          v-if="isManagerOrAbove"
          :title="!dateLivraison ? 'Date de livraison requise' : !francoAtteint ? `Franco minimum non atteint (${francoMinimum.toFixed(2)} €)` : !commandeAutorisee.ok ? commandeAutorisee.message : ''"
        >
          {{ sending ? 'Envoi en cours...' : 'Envoyer la commande' }}
        </button>
      </div>
      <div v-if="sendError" class="send-error">{{ sendError }}</div>
    </div>

  </div>
</template>

<style scoped>
.lock-banner {
  background: #FEF3CD;
  border: 1px solid #F59E0B;
  color: #92400E;
  padding: 12px 16px;
  border-radius: var(--radius-sm);
  margin-bottom: 16px;
  font-size: 15px;
  font-weight: 500;
  line-height: 1.4;
}

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

.f-logo {
  width: 48px;
  height: 48px;
  border-radius: 10px;
  overflow: hidden;
  border: 1px solid var(--border);
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.f-logo img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 4px;
}

.f-logo-placeholder {
  background: var(--color-primary);
  color: white;
  font-size: 22px;
  font-weight: 800;
  border: none;
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
.info-logo {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  overflow: hidden;
  border: 1px solid var(--border);
  background: white;
  flex-shrink: 0;
}

.info-logo img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 3px;
}

.info-bar {
  display: flex;
  gap: 12px;
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
.date-error {
  display: block;
  font-size: 13px;
  color: var(--color-danger);
  margin-top: 4px;
}
.duree-info {
  font-size: 14px;
  color: var(--text-tertiary);
  white-space: nowrap;
  align-self: center;
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

.product-thumb {
  width: 48px;
  height: 48px;
  min-width: 48px;
  border-radius: var(--radius-sm);
  overflow: hidden;
  flex-shrink: 0;
  margin-right: 10px;
}
.product-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
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

/* Actions */
.actions-bar {
  display: flex;
  gap: 12px;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid var(--border);
  position: sticky;
  bottom: 0;
  background: var(--bg-main);
  padding-bottom: 16px;
  flex-wrap: wrap;
}
.btn-danger-outline {
  background: transparent;
  color: #ef4444;
  border: 2px solid #ef4444;
  border-radius: var(--radius-md);
  padding: 14px 20px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  margin-right: auto;
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

.send-error {
  margin-top: 12px;
  padding: 12px 16px;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: var(--radius-md);
  color: #991b1b;
  font-size: 14px;
}

/* FIX 5: Creneau banner */
.creneau-banner {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 16px;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: var(--radius-md);
  margin-bottom: 12px;
  font-size: 15px;
  color: #991b1b;
  flex-wrap: wrap;
}

.creneau-icon {
  font-size: 20px;
}

.force-label {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-left: auto;
  font-size: 14px;
  font-weight: 600;
  color: #7f1d1d;
  cursor: pointer;
}

.force-label input[type="checkbox"] {
  width: 20px;
  height: 20px;
}

/* FIX 6: Stock actions row with toggle */
.stock-actions-row {
  display: flex;
  align-items: center;
  gap: 16px;
  margin-bottom: 12px;
  flex-wrap: wrap;
}

.prefill-toggle {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
}

.prefill-toggle input[type="checkbox"] {
  width: 20px;
  height: 20px;
  accent-color: var(--color-primary);
}
</style>
