<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useInventaireStore } from '@/stores/inventaire'
import { useIngredientsStore } from '@/stores/ingredients'
import { useStocksStore } from '@/stores/stocks'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useAuth } from '@/composables/useAuth'
import type { Inventaire, IngredientRestaurant } from '@/types/database'

const inventaireStore = useInventaireStore()
const ingredientsStore = useIngredientsStore()
const stocksStore = useStocksStore()
const mercurialeStore = useMercurialeStore()
const { user } = useAuth()

// ── View state ─────────────────────────────────────────────────────────

type ViewMode = 'list' | 'setup' | 'counting' | 'summary'
const view = ref<ViewMode>('list')
const search = ref('')

// ── Setup state (new inventory) ────────────────────────────────────────

const newType = ref<'complet' | 'partiel'>('complet')
const selectedZoneIds = ref<string[]>([])
const selectedIngredientIds = ref<string[]>([])
const ingredientSearch = ref('')

// ── Counting state ─────────────────────────────────────────────────────

const activeInventaire = ref<Inventaire | null>(null)
const activeZoneId = ref<string | null>(null)

interface LigneComptage {
  ingredient_id: string
  ingredient: IngredientRestaurant
  quantite_theorique: number
  quantite_comptee: number
  ecart: number
  conditionnement_saisie: string | null
  notes: string
  /** Multi-conditionnement entries: e.g. [{label: 'carton', qty: 2, coeff: 10}, {label: 'kg', qty: 3, coeff: 1}] */
  saisies: { label: string; qty: number; coeff: number }[]
}

const lignesComptage = ref<Map<string, LigneComptage>>(new Map())
const saving = ref(false)
const validating = ref(false)

// ── Computed data ──────────────────────────────────────────────────────

const filteredInventaires = computed(() => {
  if (!search.value) return inventaireStore.inventaires
  const q = search.value.toLowerCase()
  return inventaireStore.inventaires.filter(inv =>
    inv.nom.toLowerCase().includes(q) ||
    inv.type.toLowerCase().includes(q) ||
    inv.date.includes(q)
  )
})

const filteredIngredients = computed(() => {
  if (!ingredientSearch.value) return ingredientsStore.actifs
  const q = ingredientSearch.value.toLowerCase()
  return ingredientsStore.actifs.filter(i =>
    i.nom.toLowerCase().includes(q) ||
    i.categorie?.toLowerCase().includes(q)
  )
})

/** Ingredients filtered for the active inventaire (by zone or explicit selection) */

/** Group counting lines by zone */
const lignesByZone = computed(() => {
  const groups: { zoneId: string; zoneName: string; lignes: LigneComptage[] }[] = []
  const zoneMap = new Map<string, LigneComptage[]>()
  const sansZone: LigneComptage[] = []

  for (const ligne of lignesComptage.value.values()) {
    const zId = ligne.ingredient.zone_stockage_id
    if (zId) {
      if (!zoneMap.has(zId)) zoneMap.set(zId, [])
      zoneMap.get(zId)!.push(ligne)
    } else {
      sansZone.push(ligne)
    }
  }

  // Sort zones by their ordre
  const sortedZoneIds = [...zoneMap.keys()].sort((a, b) => {
    const zA = inventaireStore.getZoneById(a)
    const zB = inventaireStore.getZoneById(b)
    return (zA?.ordre ?? 99) - (zB?.ordre ?? 99)
  })

  for (const zId of sortedZoneIds) {
    const zone = inventaireStore.getZoneById(zId)
    groups.push({
      zoneId: zId,
      zoneName: zone?.nom ?? 'Zone inconnue',
      lignes: zoneMap.get(zId)!.sort((a, b) => a.ingredient.nom.localeCompare(b.ingredient.nom, 'fr')),
    })
  }

  if (sansZone.length > 0) {
    groups.push({
      zoneId: '__none__',
      zoneName: 'Sans zone',
      lignes: sansZone.sort((a, b) => a.ingredient.nom.localeCompare(b.ingredient.nom, 'fr')),
    })
  }

  return groups
})

/** Lines for the currently selected zone tab */
const activeLignes = computed(() => {
  if (!activeZoneId.value) {
    // Show all if no zone selected
    return [...lignesComptage.value.values()].sort((a, b) =>
      a.ingredient.nom.localeCompare(b.ingredient.nom, 'fr')
    )
  }
  const group = lignesByZone.value.find(g => g.zoneId === activeZoneId.value)
  return group?.lignes ?? []
})

// ── Summary computations ───────────────────────────────────────────────

const summaryStats = computed(() => {
  const allLignes = [...lignesComptage.value.values()]
  const total = allLignes.length
  const withEcart = allLignes.filter(l => Math.abs(l.ecart) > 0.001)
  const ecartPctList = allLignes.map(l => {
    if (l.quantite_theorique === 0) return l.quantite_comptee > 0 ? 100 : 0
    return Math.abs(l.ecart / l.quantite_theorique) * 100
  })
  const vert = ecartPctList.filter(p => p < 5).length
  const orange = ecartPctList.filter(p => p >= 5 && p <= 15).length
  const rouge = ecartPctList.filter(p => p > 15).length

  return { total, withEcart: withEcart.length, vert, orange, rouge }
})

const summaryByZone = computed(() => {
  return lignesByZone.value.map(group => {
    const ecarts = group.lignes.filter(l => Math.abs(l.ecart) > 0.001)
    const totalEcart = group.lignes.reduce((sum, l) => sum + Math.abs(l.ecart), 0)
    return {
      zoneName: group.zoneName,
      totalLignes: group.lignes.length,
      nbEcarts: ecarts.length,
      totalEcart: totalEcart.toFixed(2),
    }
  })
})

// ── Helper functions ───────────────────────────────────────────────────

function formatDate(d: string) {
  return new Date(d).toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
}

function formatDateShort(d: string) {
  return new Date(d).toLocaleDateString('fr-FR', { day: 'numeric', month: 'short' })
}

function ecartClass(ligne: LigneComptage): string {
  if (ligne.quantite_theorique === 0) {
    return ligne.quantite_comptee > 0 ? 'ecart-orange' : 'ecart-vert'
  }
  const pct = Math.abs(ligne.ecart / ligne.quantite_theorique) * 100
  if (pct < 5) return 'ecart-vert'
  if (pct <= 15) return 'ecart-orange'
  return 'ecart-rouge'
}

function ecartPct(ligne: LigneComptage): string {
  if (ligne.quantite_theorique === 0) {
    return ligne.quantite_comptee > 0 ? '+100%' : '0%'
  }
  const pct = (ligne.ecart / ligne.quantite_theorique) * 100
  const sign = pct > 0 ? '+' : ''
  return `${sign}${pct.toFixed(1)}%`
}

function getConditionnements(ingredientId: string): { label: string; coeff: number }[] {
  // Find mercuriale entries linked to this ingredient
  const entries = mercurialeStore.items.filter(m =>
    m.ingredient_restaurant_id === ingredientId && m.actif
  )
  const condList: { label: string; coeff: number }[] = []

  for (const entry of entries) {
    if (entry.conditionnements && entry.conditionnements.length > 0) {
      for (const cond of entry.conditionnements) {
        // Avoid duplicates
        if (!condList.some(c => c.label === cond.nom)) {
          condList.push({
            label: cond.nom,
            coeff: cond.quantite, // e.g. 1 carton = 10 kg → coeff 10
          })
        }
      }
    }
  }

  return condList
}

// ── Actions ────────────────────────────────────────────────────────────

function startSetup() {
  newType.value = 'complet'
  selectedZoneIds.value = []
  selectedIngredientIds.value = []
  ingredientSearch.value = ''
  view.value = 'setup'
}

function toggleZone(zoneId: string) {
  const idx = selectedZoneIds.value.indexOf(zoneId)
  if (idx >= 0) {
    selectedZoneIds.value.splice(idx, 1)
  } else {
    selectedZoneIds.value.push(zoneId)
  }
}

function toggleIngredient(id: string) {
  const idx = selectedIngredientIds.value.indexOf(id)
  if (idx >= 0) {
    selectedIngredientIds.value.splice(idx, 1)
  } else {
    selectedIngredientIds.value.push(id)
  }
}

async function createInventaire() {
  if (!user.value) return

  const today = new Date().toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric' })
  const nom = newType.value === 'complet'
    ? `Inventaire complet - ${today}`
    : `Inventaire partiel - ${today}`

  // For partiel, store zone IDs + prefixed ingredient IDs
  let zoneData: string[] = []
  if (newType.value === 'partiel') {
    zoneData = [
      ...selectedZoneIds.value,
      ...selectedIngredientIds.value.map(id => `ing:${id}`),
    ]
  }

  try {
    const inv = await inventaireStore.create(nom, newType.value, zoneData, user.value.id)
    await openInventaire(inv)
  } catch (e: unknown) {
    console.error('Failed to create inventaire:', e)
  }
}

async function openInventaire(inv: Inventaire) {
  activeInventaire.value = inv
  lignesComptage.value.clear()

  // Fetch existing lines
  const existingLignes = await inventaireStore.fetchLignes(inv.id)

  // Determine which ingredients to count
  let ingredientsToCount: IngredientRestaurant[]
  if (inv.type === 'complet') {
    ingredientsToCount = ingredientsStore.actifs
  } else {
    const zoneIds = inv.zones.filter(z => !z.startsWith('ing:'))
    const ingIds = inv.zones.filter(z => z.startsWith('ing:')).map(z => z.slice(4))
    ingredientsToCount = ingredientsStore.actifs.filter(ing =>
      (zoneIds.length > 0 && ing.zone_stockage_id && zoneIds.includes(ing.zone_stockage_id)) ||
      ingIds.includes(ing.id)
    )
  }

  // Build comptage lines
  for (const ing of ingredientsToCount) {
    const stock = stocksStore.getByIngredient(ing.id)
    const qTheo = stock?.quantite ?? 0
    const existing = existingLignes.find(l => l.ingredient_id === ing.id)
    const conds = getConditionnements(ing.id)

    // Build initial saisies array
    const saisies: { label: string; qty: number; coeff: number }[] = []
    if (conds.length > 0) {
      for (const c of conds) {
        saisies.push({ label: c.label, qty: 0, coeff: c.coeff })
      }
    }
    // Always add base unit
    saisies.push({ label: ing.unite_stock, qty: existing?.quantite_comptee ?? 0, coeff: 1 })

    // If existing data, try to parse conditionnement_saisie
    if (existing?.conditionnement_saisie) {
      try {
        const parsed = JSON.parse(existing.conditionnement_saisie) as { label: string; qty: number }[]
        for (const p of parsed) {
          const s = saisies.find(s => s.label === p.label)
          if (s) s.qty = p.qty
        }
      } catch { /* ignore parse errors */ }
    }

    lignesComptage.value.set(ing.id, {
      ingredient_id: ing.id,
      ingredient: ing,
      quantite_theorique: qTheo,
      quantite_comptee: existing?.quantite_comptee ?? 0,
      ecart: existing?.ecart ?? 0,
      conditionnement_saisie: existing?.conditionnement_saisie ?? null,
      notes: existing?.notes ?? '',
      saisies,
    })
  }

  // Default to first zone
  if (lignesByZone.value.length > 0) {
    activeZoneId.value = lignesByZone.value[0]!.zoneId
  } else {
    activeZoneId.value = null
  }

  view.value = inv.statut === 'valide' ? 'summary' : 'counting'
}

function recalcLigne(ligne: LigneComptage) {
  // Sum up all saisies * their coefficients
  let total = 0
  for (const s of ligne.saisies) {
    total += s.qty * s.coeff
  }
  ligne.quantite_comptee = Math.round(total * 1000) / 1000
  ligne.ecart = Math.round((ligne.quantite_comptee - ligne.quantite_theorique) * 1000) / 1000

  // Store the saisie breakdown as JSON
  ligne.conditionnement_saisie = JSON.stringify(
    ligne.saisies.filter(s => s.qty > 0).map(s => ({ label: s.label, qty: s.qty }))
  )
}

function incrementSaisie(ligne: LigneComptage, idx: number) {
  ligne.saisies[idx]!.qty = Math.round((ligne.saisies[idx]!.qty + 1) * 1000) / 1000
  recalcLigne(ligne)
}

function decrementSaisie(ligne: LigneComptage, idx: number) {
  if (ligne.saisies[idx]!.qty > 0) {
    ligne.saisies[idx]!.qty = Math.round((ligne.saisies[idx]!.qty - 1) * 1000) / 1000
    recalcLigne(ligne)
  }
}

function setSaisieQty(ligne: LigneComptage, idx: number, val: string) {
  const num = parseFloat(val)
  ligne.saisies[idx]!.qty = isNaN(num) ? 0 : Math.max(0, num)
  recalcLigne(ligne)
}

async function saveDraft() {
  if (!activeInventaire.value) return
  saving.value = true
  try {
    const lignes: Partial<import('@/types/database').InventaireLigne>[] = []
    for (const l of lignesComptage.value.values()) {
      lignes.push({
        inventaire_id: activeInventaire.value.id,
        ingredient_id: l.ingredient_id,
        quantite_theorique: l.quantite_theorique,
        quantite_comptee: l.quantite_comptee,
        ecart: l.ecart,
        conditionnement_saisie: l.conditionnement_saisie,
        notes: l.notes || null,
      })
    }
    await inventaireStore.saveLignes(activeInventaire.value.id, lignes)
  } catch (e: unknown) {
    console.error('Failed to save draft:', e)
  } finally {
    saving.value = false
  }
}

function goToSummary() {
  view.value = 'summary'
}

async function validerInventaire() {
  if (!activeInventaire.value) return
  validating.value = true
  try {
    // Save lines first
    await saveDraft()

    // Apply stock updates
    const lignesFinales = [...lignesComptage.value.values()].map(l => ({
      ingredient_id: l.ingredient_id,
      quantite_comptee: l.quantite_comptee,
    }))
    await inventaireStore.appliquerStocks(activeInventaire.value.id, lignesFinales)

    // Refresh stocks store
    await stocksStore.fetchAll()

    view.value = 'list'
    activeInventaire.value = null
    lignesComptage.value.clear()
  } catch (e: unknown) {
    console.error('Failed to validate inventaire:', e)
  } finally {
    validating.value = false
  }
}

function backToList() {
  view.value = 'list'
  activeInventaire.value = null
  lignesComptage.value.clear()
}

function backToCounting() {
  view.value = 'counting'
}

// ── Lifecycle ──────────────────────────────────────────────────────────

onMounted(async () => {
  await Promise.all([
    inventaireStore.fetchAll(),
    inventaireStore.fetchZones(),
    ingredientsStore.fetchAll(),
    stocksStore.fetchAll(),
    mercurialeStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="inventaire-page">

    <!-- ═══════════════════════════════════════════════════════════════ -->
    <!-- LIST VIEW                                                      -->
    <!-- ═══════════════════════════════════════════════════════════════ -->
    <template v-if="view === 'list'">
      <div class="page-header">
        <h1>Inventaire</h1>
        <button class="btn-primary" @click="startSetup">+ Nouvel inventaire</button>
      </div>

      <input
        v-model="search"
        type="search"
        placeholder="Rechercher un inventaire..."
        class="search-input"
      />

      <div v-if="inventaireStore.loading" class="loading">Chargement...</div>

      <div v-else-if="filteredInventaires.length === 0" class="empty">
        <p>Aucun inventaire{{ search ? ' trouv\u00e9' : '' }}.</p>
        <p v-if="!search">Cr\u00e9ez votre premier inventaire.</p>
      </div>

      <div v-else class="inv-list">
        <div
          v-for="inv in filteredInventaires"
          :key="inv.id"
          class="inv-card"
          @click="openInventaire(inv)"
        >
          <div class="inv-card-top">
            <span class="inv-name">{{ inv.nom }}</span>
            <span
              class="badge-statut"
              :class="inv.statut === 'valide' ? 'badge-valide' : 'badge-encours'"
            >
              {{ inv.statut === 'valide' ? 'Valid\u00e9' : 'En cours' }}
            </span>
          </div>
          <div class="inv-card-bottom">
            <span class="inv-date">{{ formatDateShort(inv.date) }}</span>
            <span class="inv-type">
              {{ inv.type === 'complet' ? 'Complet' : 'Partiel' }}
            </span>
            <span class="inv-zones" v-if="inv.zones.length > 0">
              {{ inv.zones.filter(z => !z.startsWith('ing:')).length }} zone{{ inv.zones.filter(z => !z.startsWith('ing:')).length > 1 ? 's' : '' }}
            </span>
          </div>
        </div>
      </div>
    </template>

    <!-- ═══════════════════════════════════════════════════════════════ -->
    <!-- SETUP VIEW (new inventory)                                     -->
    <!-- ═══════════════════════════════════════════════════════════════ -->
    <template v-else-if="view === 'setup'">
      <div class="page-header">
        <div>
          <button class="btn-back" @click="view = 'list'">&#8592; Retour</button>
          <h1>Nouvel inventaire</h1>
        </div>
      </div>

      <!-- Type selection -->
      <div class="setup-section">
        <h2>Type d'inventaire</h2>
        <div class="type-grid">
          <button
            :class="['type-btn', { active: newType === 'complet' }]"
            @click="newType = 'complet'"
          >
            <span class="type-icon">&#9744;</span>
            <span class="type-label">Complet</span>
            <span class="type-desc">Tous les ingr\u00e9dients actifs</span>
          </button>
          <button
            :class="['type-btn', { active: newType === 'partiel' }]"
            @click="newType = 'partiel'"
          >
            <span class="type-icon">&#9998;</span>
            <span class="type-label">Partiel</span>
            <span class="type-desc">Zones ou ingr\u00e9dients sp\u00e9cifiques</span>
          </button>
        </div>
      </div>

      <!-- Zone selection for partiel -->
      <template v-if="newType === 'partiel'">
        <div class="setup-section">
          <h2>Zones de stockage</h2>
          <p class="setup-hint" v-if="inventaireStore.zones.length === 0">
            Aucune zone de stockage configur\u00e9e.
          </p>
          <div class="zone-grid" v-else>
            <button
              v-for="z in inventaireStore.zones"
              :key="z.id"
              :class="['zone-btn', { active: selectedZoneIds.includes(z.id) }]"
              @click="toggleZone(z.id)"
            >
              <span class="zone-name">{{ z.nom }}</span>
              <span v-if="z.description" class="zone-desc">{{ z.description }}</span>
              <span class="zone-check">{{ selectedZoneIds.includes(z.id) ? '&#10003;' : '' }}</span>
            </button>
          </div>
        </div>

        <div class="setup-section">
          <h2>Ingr\u00e9dients sp\u00e9cifiques</h2>
          <input
            v-model="ingredientSearch"
            type="search"
            placeholder="Rechercher un ingr\u00e9dient..."
            class="search-input"
          />
          <div class="ingredient-select-list">
            <div
              v-for="ing in filteredIngredients"
              :key="ing.id"
              :class="['ingredient-select-row', { selected: selectedIngredientIds.includes(ing.id) }]"
              @click="toggleIngredient(ing.id)"
            >
              <span class="ing-name">{{ ing.nom }}</span>
              <span class="ing-cat">{{ ing.categorie || '' }}</span>
              <span class="ing-check">{{ selectedIngredientIds.includes(ing.id) ? '&#10003;' : '' }}</span>
            </div>
          </div>
        </div>
      </template>

      <!-- Confirm -->
      <div class="setup-actions">
        <button class="btn-secondary" @click="view = 'list'">Annuler</button>
        <button
          class="btn-primary"
          :disabled="newType === 'partiel' && selectedZoneIds.length === 0 && selectedIngredientIds.length === 0"
          @click="createInventaire"
        >
          D\u00e9marrer le comptage
        </button>
      </div>
    </template>

    <!-- ═══════════════════════════════════════════════════════════════ -->
    <!-- COUNTING VIEW                                                  -->
    <!-- ═══════════════════════════════════════════════════════════════ -->
    <template v-else-if="view === 'counting'">
      <div class="page-header">
        <div>
          <button class="btn-back" @click="backToList">&#8592; Retour</button>
          <h1>{{ activeInventaire?.nom || 'Comptage' }}</h1>
        </div>
        <div class="header-actions">
          <span class="save-status" :class="{ saved: !saving, saving }">
            {{ saving ? 'Sauvegarde...' : 'Sauvegard\u00e9' }}
          </span>
        </div>
      </div>

      <!-- Zone tabs -->
      <div class="zone-tabs" v-if="lignesByZone.length > 1">
        <button
          :class="['zone-tab', { active: !activeZoneId }]"
          @click="activeZoneId = null"
        >
          Toutes ({{ lignesComptage.size }})
        </button>
        <button
          v-for="g in lignesByZone"
          :key="g.zoneId"
          :class="['zone-tab', { active: activeZoneId === g.zoneId }]"
          @click="activeZoneId = g.zoneId"
        >
          {{ g.zoneName }} ({{ g.lignes.length }})
        </button>
      </div>

      <!-- Counting cards -->
      <div v-if="activeLignes.length === 0" class="empty">
        Aucun ingr\u00e9dient dans cette zone.
      </div>

      <div class="counting-list">
        <div v-for="ligne in activeLignes" :key="ligne.ingredient_id" class="counting-card">
          <div class="counting-header">
            <div class="counting-info">
              <span class="counting-name">{{ ligne.ingredient.nom }}</span>
              <span class="counting-cat">{{ ligne.ingredient.categorie || '' }}</span>
            </div>
            <div class="counting-theo">
              <span class="theo-label">Th\u00e9orique</span>
              <span class="theo-value">{{ ligne.quantite_theorique.toFixed(2) }} {{ ligne.ingredient.unite_stock }}</span>
            </div>
          </div>

          <!-- Multi-conditionnement saisie -->
          <div class="saisie-rows">
            <div v-for="(s, idx) in ligne.saisies" :key="s.label" class="saisie-row">
              <span class="saisie-label">{{ s.label }}{{ s.coeff !== 1 ? ` (x${s.coeff})` : '' }}</span>
              <div class="qty-controls" :class="{ 'has-qty': s.qty > 0 }">
                <button class="qty-btn minus" @click="decrementSaisie(ligne, idx)" :disabled="s.qty <= 0">&#8722;</button>
                <input
                  :value="s.qty"
                  @change="setSaisieQty(ligne, idx, ($event.target as HTMLInputElement).value)"
                  type="number"
                  inputmode="decimal"
                  step="any"
                  min="0"
                  class="qty-input"
                />
                <button class="qty-btn plus" @click="incrementSaisie(ligne, idx)">+</button>
              </div>
            </div>
          </div>

          <!-- Result -->
          <div class="counting-result">
            <div class="result-total">
              <span class="result-label">Compt\u00e9 :</span>
              <span class="result-value">{{ ligne.quantite_comptee.toFixed(2) }} {{ ligne.ingredient.unite_stock }}</span>
            </div>
            <div :class="['result-ecart', ecartClass(ligne)]">
              <span class="ecart-value">{{ ligne.ecart >= 0 ? '+' : '' }}{{ ligne.ecart.toFixed(2) }}</span>
              <span class="ecart-pct">{{ ecartPct(ligne) }}</span>
            </div>
          </div>

          <!-- Notes -->
          <div class="counting-notes">
            <input
              v-model="ligne.notes"
              type="text"
              placeholder="Notes..."
              class="notes-input"
            />
          </div>
        </div>
      </div>

      <!-- Bottom actions -->
      <div class="actions-bar">
        <button class="btn-secondary" @click="saveDraft" :disabled="saving">
          Sauvegarder brouillon
        </button>
        <button class="btn-primary" @click="goToSummary">
          Voir le r\u00e9sum\u00e9
        </button>
      </div>
    </template>

    <!-- ═══════════════════════════════════════════════════════════════ -->
    <!-- SUMMARY VIEW                                                   -->
    <!-- ═══════════════════════════════════════════════════════════════ -->
    <template v-else-if="view === 'summary'">
      <div class="page-header">
        <div>
          <button class="btn-back" @click="backToCounting" v-if="activeInventaire?.statut !== 'valide'">
            &#8592; Retour au comptage
          </button>
          <button class="btn-back" @click="backToList" v-else>
            &#8592; Retour
          </button>
          <h1>R\u00e9sum\u00e9 {{ activeInventaire?.nom }}</h1>
        </div>
      </div>

      <!-- Global stats -->
      <div class="summary-stats">
        <div class="stat-card">
          <span class="stat-value">{{ summaryStats.total }}</span>
          <span class="stat-label">Ingr\u00e9dients</span>
        </div>
        <div class="stat-card stat-ecart">
          <span class="stat-value">{{ summaryStats.withEcart }}</span>
          <span class="stat-label">\u00c9carts</span>
        </div>
        <div class="stat-card stat-vert">
          <span class="stat-value">{{ summaryStats.vert }}</span>
          <span class="stat-label">&lt; 5%</span>
        </div>
        <div class="stat-card stat-orange">
          <span class="stat-value">{{ summaryStats.orange }}</span>
          <span class="stat-label">5-15%</span>
        </div>
        <div class="stat-card stat-rouge">
          <span class="stat-value">{{ summaryStats.rouge }}</span>
          <span class="stat-label">&gt; 15%</span>
        </div>
      </div>

      <!-- By zone -->
      <div class="summary-zones">
        <h2>D\u00e9tail par zone</h2>
        <div v-for="sz in summaryByZone" :key="sz.zoneName" class="summary-zone-card">
          <div class="sz-header">
            <span class="sz-name">{{ sz.zoneName }}</span>
            <span class="sz-count">{{ sz.totalLignes }} ingr\u00e9dient{{ sz.totalLignes > 1 ? 's' : '' }}</span>
          </div>
          <div class="sz-detail">
            <span :class="['sz-ecarts', sz.nbEcarts > 0 ? 'has-ecarts' : '']">
              {{ sz.nbEcarts }} \u00e9cart{{ sz.nbEcarts > 1 ? 's' : '' }}
            </span>
            <span class="sz-total-ecart" v-if="sz.nbEcarts > 0">
              \u0394 {{ sz.totalEcart }}
            </span>
          </div>
        </div>
      </div>

      <!-- Ecart details -->
      <div class="summary-ecarts">
        <h2>\u00c9carts significatifs (&gt; 15%)</h2>
        <div class="ecart-list">
          <template v-for="ligne in [...lignesComptage.values()]" :key="ligne.ingredient_id">
            <div
              v-if="ecartClass(ligne) === 'ecart-rouge'"
              class="ecart-detail-card"
            >
              <div class="ecart-detail-info">
                <span class="ecart-detail-name">{{ ligne.ingredient.nom }}</span>
                <span class="ecart-detail-zone">
                  {{ ligne.ingredient.zone_stockage_id ? (inventaireStore.getZoneById(ligne.ingredient.zone_stockage_id)?.nom ?? '') : 'Sans zone' }}
                </span>
              </div>
              <div class="ecart-detail-values">
                <span>Th\u00e9o: {{ ligne.quantite_theorique.toFixed(2) }}</span>
                <span>Compt\u00e9: {{ ligne.quantite_comptee.toFixed(2) }}</span>
                <span class="ecart-detail-diff ecart-rouge">
                  {{ ligne.ecart >= 0 ? '+' : '' }}{{ ligne.ecart.toFixed(2) }} {{ ligne.ingredient.unite_stock }}
                  ({{ ecartPct(ligne) }})
                </span>
              </div>
              <div v-if="ligne.notes" class="ecart-detail-notes">{{ ligne.notes }}</div>
            </div>
          </template>
          <div
            v-if="summaryStats.rouge === 0"
            class="empty"
          >
            Aucun \u00e9cart sup\u00e9rieur \u00e0 15%.
          </div>
        </div>
      </div>

      <!-- Validate -->
      <div class="actions-bar" v-if="activeInventaire?.statut !== 'valide'">
        <button class="btn-secondary" @click="backToCounting">
          Modifier le comptage
        </button>
        <button class="btn-validate" @click="validerInventaire" :disabled="validating">
          {{ validating ? 'Validation...' : 'Valider et mettre \u00e0 jour les stocks' }}
        </button>
      </div>
      <div class="actions-bar validated-notice" v-else>
        <span class="validated-badge">Inventaire valid\u00e9 le {{ formatDate(activeInventaire.created_at) }}</span>
      </div>
    </template>

  </div>
</template>

<style scoped>
/* ═══════════════════════════════════════════════════════════════════════
   BASE LAYOUT
   ═══════════════════════════════════════════════════════════════════ */

.inventaire-page {
  max-width: 900px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}

.page-header h1 {
  font-size: 28px;
  color: var(--text-primary);
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

.header-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.btn-primary {
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 14px 24px;
  font-size: 17px;
  font-weight: 700;
  cursor: pointer;
  min-height: 52px;
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
  padding: 14px 24px;
  font-size: 17px;
  font-weight: 600;
  cursor: pointer;
  min-height: 52px;
}

.btn-validate {
  background: var(--color-success);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 14px 28px;
  font-size: 17px;
  font-weight: 700;
  cursor: pointer;
  min-height: 52px;
}

.btn-validate:disabled {
  opacity: 0.4;
  cursor: not-allowed;
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
  box-sizing: border-box;
}

.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.loading,
.empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 40px 20px;
  font-size: 16px;
}

.save-status {
  font-size: 13px;
  padding: 4px 10px;
  border-radius: 8px;
}

.save-status.saved {
  background: #dcfce7;
  color: #166534;
}

.save-status.saving {
  background: #fef3c7;
  color: #92400e;
}

/* ═══════════════════════════════════════════════════════════════════════
   LIST VIEW
   ═══════════════════════════════════════════════════════════════════ */

.inv-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.inv-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px 20px;
  cursor: pointer;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
  transition: box-shadow 0.15s;
}

.inv-card:active {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.inv-card-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.inv-name {
  font-size: 17px;
  font-weight: 600;
  color: var(--text-primary);
}

.badge-statut {
  padding: 4px 12px;
  border-radius: 10px;
  font-size: 13px;
  font-weight: 700;
}

.badge-valide {
  background: #dcfce7;
  color: #166534;
}

.badge-encours {
  background: #fef3c7;
  color: #92400e;
}

.inv-card-bottom {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: var(--text-secondary);
}

.inv-type {
  font-weight: 600;
}

/* ═══════════════════════════════════════════════════════════════════════
   SETUP VIEW
   ═══════════════════════════════════════════════════════════════════ */

.setup-section {
  margin-bottom: 24px;
}

.setup-section h2 {
  font-size: 20px;
  margin-bottom: 12px;
  color: var(--text-primary);
}

.setup-hint {
  color: var(--text-tertiary);
  font-size: 15px;
}

.type-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}

.type-btn {
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
  min-height: 120px;
}

.type-btn.active {
  border-color: var(--color-primary);
  background: #fef2ee;
}

.type-icon {
  font-size: 28px;
}

.type-label {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
}

.type-desc {
  font-size: 14px;
  color: var(--text-secondary);
  text-align: center;
}

.zone-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 10px;
}

.zone-btn {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 16px;
  background: var(--bg-surface);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  cursor: pointer;
  text-align: left;
  position: relative;
  transition: border-color 0.15s;
  min-height: 56px;
}

.zone-btn.active {
  border-color: var(--color-primary);
  background: #fef2ee;
}

.zone-name {
  font-size: 16px;
  font-weight: 600;
}

.zone-desc {
  font-size: 13px;
  color: var(--text-tertiary);
}

.zone-check {
  position: absolute;
  top: 8px;
  right: 12px;
  font-size: 18px;
  color: var(--color-primary);
  font-weight: 700;
}

.ingredient-select-list {
  max-height: 360px;
  overflow-y: auto;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-surface);
}

.ingredient-select-row {
  display: flex;
  align-items: center;
  padding: 14px 16px;
  cursor: pointer;
  border-bottom: 1px solid var(--border);
  transition: background 0.1s;
}

.ingredient-select-row:last-child {
  border-bottom: none;
}

.ingredient-select-row.selected {
  background: #fef2ee;
}

.ingredient-select-row:active {
  background: #f0f0f2;
}

.ing-name {
  font-size: 16px;
  font-weight: 600;
  flex: 1;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.ing-cat {
  font-size: 13px;
  color: var(--text-tertiary);
  margin-right: 12px;
}

.ing-check {
  font-size: 18px;
  color: var(--color-primary);
  font-weight: 700;
  width: 24px;
  text-align: center;
  flex-shrink: 0;
}

.setup-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding-top: 16px;
  border-top: 1px solid var(--border);
}

/* ═══════════════════════════════════════════════════════════════════════
   COUNTING VIEW
   ═══════════════════════════════════════════════════════════════════ */

.zone-tabs {
  display: flex;
  gap: 6px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 4px;
  margin-bottom: 16px;
}

.zone-tab {
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
  color: var(--text-secondary);
}

.zone-tab.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.counting-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding-bottom: 100px;
}

.counting-card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 16px 20px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.counting-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.counting-info {
  display: flex;
  flex-direction: column;
}

.counting-name {
  font-size: 17px;
  font-weight: 700;
  color: var(--text-primary);
}

.counting-cat {
  font-size: 13px;
  color: var(--text-tertiary);
}

.counting-theo {
  text-align: right;
  flex-shrink: 0;
}

.theo-label {
  display: block;
  font-size: 12px;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.theo-value {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-secondary);
}

/* Saisie rows (multi-conditionnement) */
.saisie-rows {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 12px;
}

.saisie-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}

.saisie-label {
  font-size: 15px;
  font-weight: 500;
  color: var(--text-secondary);
  min-width: 100px;
  flex-shrink: 0;
}

.qty-controls {
  display: flex;
  align-items: center;
  gap: 0;
  flex-shrink: 0;
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
  color: var(--text-primary);
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
  width: 80px;
  height: 52px;
  border: 2px solid var(--border);
  border-left: none;
  border-right: none;
  text-align: center;
  font-size: 20px;
  font-weight: 700;
  background: var(--bg-surface);
  -moz-appearance: textfield;
  color: var(--text-primary);
}

.qty-input::-webkit-outer-spin-button,
.qty-input::-webkit-inner-spin-button {
  -webkit-appearance: none;
}

.qty-input:focus {
  outline: none;
  border-color: var(--color-primary);
  border-left: 2px solid var(--color-primary);
  border-right: 2px solid var(--color-primary);
}

/* Result / ecart */
.counting-result {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 0;
  border-top: 1px solid var(--border);
}

.result-total {
  display: flex;
  align-items: baseline;
  gap: 6px;
}

.result-label {
  font-size: 14px;
  color: var(--text-secondary);
}

.result-value {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary);
}

.result-ecart {
  display: flex;
  align-items: baseline;
  gap: 6px;
  padding: 4px 12px;
  border-radius: var(--radius-sm);
  font-weight: 700;
}

.ecart-value {
  font-size: 16px;
}

.ecart-pct {
  font-size: 13px;
}

.ecart-vert {
  background: #dcfce7;
  color: #166534;
}

.ecart-orange {
  background: #fef3c7;
  color: #92400e;
}

.ecart-rouge {
  background: #fecaca;
  color: #991b1b;
}

/* Notes */
.counting-notes {
  margin-top: 8px;
}

.notes-input {
  width: 100%;
  height: 44px;
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 12px;
  font-size: 15px;
  background: var(--bg-main);
  color: var(--text-primary);
  box-sizing: border-box;
}

.notes-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.notes-input::placeholder {
  color: var(--text-tertiary);
}

/* ═══════════════════════════════════════════════════════════════════════
   SUMMARY VIEW
   ═══════════════════════════════════════════════════════════════════ */

.summary-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
  gap: 10px;
  margin-bottom: 24px;
}

.stat-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px;
  text-align: center;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.stat-value {
  display: block;
  font-size: 28px;
  font-weight: 800;
  color: var(--text-primary);
}

.stat-label {
  display: block;
  font-size: 13px;
  color: var(--text-secondary);
  margin-top: 4px;
}

.stat-vert .stat-value { color: #166534; }
.stat-vert { border-bottom: 3px solid var(--color-success); }
.stat-orange .stat-value { color: #92400e; }
.stat-orange { border-bottom: 3px solid var(--color-warning); }
.stat-rouge .stat-value { color: #991b1b; }
.stat-rouge { border-bottom: 3px solid var(--color-danger); }
.stat-ecart .stat-value { color: var(--color-primary); }

.summary-zones {
  margin-bottom: 24px;
}

.summary-zones h2 {
  font-size: 20px;
  margin-bottom: 12px;
  color: var(--text-primary);
}

.summary-zone-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 14px 20px;
  margin-bottom: 8px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.sz-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 4px;
}

.sz-name {
  font-size: 17px;
  font-weight: 600;
  color: var(--text-primary);
}

.sz-count {
  font-size: 14px;
  color: var(--text-tertiary);
}

.sz-detail {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: var(--text-secondary);
}

.sz-ecarts.has-ecarts {
  color: var(--color-warning);
  font-weight: 600;
}

.sz-total-ecart {
  font-weight: 600;
  color: var(--color-danger);
}

.summary-ecarts {
  margin-bottom: 24px;
}

.summary-ecarts h2 {
  font-size: 20px;
  margin-bottom: 12px;
  color: var(--text-primary);
}

.ecart-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.ecart-detail-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 14px 20px;
  border-left: 4px solid var(--color-danger);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
}

.ecart-detail-info {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}

.ecart-detail-name {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
}

.ecart-detail-zone {
  font-size: 13px;
  color: var(--text-tertiary);
}

.ecart-detail-values {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: var(--text-secondary);
  flex-wrap: wrap;
}

.ecart-detail-diff {
  font-weight: 700;
  padding: 2px 8px;
  border-radius: var(--radius-sm);
}

.ecart-detail-notes {
  margin-top: 6px;
  font-size: 13px;
  color: var(--text-tertiary);
  font-style: italic;
}

.validated-notice {
  justify-content: center;
}

.validated-badge {
  background: #dcfce7;
  color: #166534;
  padding: 12px 24px;
  border-radius: var(--radius-md);
  font-size: 16px;
  font-weight: 700;
}

/* ═══════════════════════════════════════════════════════════════════════
   ACTIONS BAR (sticky bottom)
   ═══════════════════════════════════════════════════════════════════ */

.actions-bar {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 16px 0;
  border-top: 1px solid var(--border);
  position: sticky;
  bottom: 0;
  background: var(--bg-main);
  z-index: 10;
  margin-top: 16px;
}
</style>
