<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRecettesStore } from '@/stores/recettes'
import { useIngredientsStore } from '@/stores/ingredients'
import { useAuth } from '@/composables/useAuth'
import { restCall } from '@/lib/rest-client'
import { getUnitFactor } from '@/lib/unit-conversion'
import type {
  Recette,
  RecetteType,
  RecetteOption,
  PrixVenteCanal,
  IngredientRestaurant,
} from '@/types/database'

const route = useRoute()
const router = useRouter()
const recettesStore = useRecettesStore()
const ingredientsStore = useIngredientsStore()
const { isAdmin } = useAuth()

const recetteId = computed(() => route.params.id as string | undefined)
const isNew = computed(() => !recetteId.value || recetteId.value === 'new')

// --- Form state ---
const nom = ref('')
const type = ref<RecetteType>('recette')
const categorie = ref('')
const description = ref('')
const instructions = ref('')
const nbPortions = ref(1)
const coutEmballage = ref<number>(0)
const photoUrl = ref<string | null>(null)
const zeltyProductId = ref<string | null>(null)
const actif = ref(true)

// --- Zelty dropdown ---
interface ZeltyDish { id: string; name: string; image: string | null }
const zeltyDishes = ref<ZeltyDish[]>([])
const zeltySearch = ref('')
const showZeltyDropdown = ref(false)
const zeltyLoading = ref(false)
const zeltyLoaded = ref(false)

async function fetchZeltyDishes() {
  if (zeltyLoaded.value) return
  zeltyLoading.value = true
  try {
    const resp = await fetch('/.netlify/functions/list-zelty-dishes')
    if (resp.ok) {
      zeltyDishes.value = await resp.json()
      zeltyLoaded.value = true
    }
  } catch (e) {
    console.error('Failed to load Zelty dishes:', e)
  } finally {
    zeltyLoading.value = false
  }
}

const filteredZeltyDishes = computed(() => {
  const usedIds = new Set<string>()
  for (const r of recettesStore.recettes) {
    if (r.zelty_product_id && r.id !== recetteId.value) {
      usedIds.add(String(r.zelty_product_id))
    }
  }
  let dishes = zeltyDishes.value.filter(d => !usedIds.has(d.id))
  const q = zeltySearch.value.toLowerCase().trim()
  if (q) {
    dishes = dishes.filter(d => d.name.toLowerCase().includes(q))
  }
  return dishes.slice(0, 20)
})

const linkedZeltyName = computed(() => {
  if (!zeltyProductId.value) return null
  const dish = zeltyDishes.value.find(d => d.id === String(zeltyProductId.value))
  return dish?.name || `ID ${zeltyProductId.value}`
})

function selectZeltyDish(dish: ZeltyDish) {
  zeltyProductId.value = dish.id
  if (!photoUrl.value && dish.image) {
    photoUrl.value = dish.image
  }
  zeltySearch.value = ''
  showZeltyDropdown.value = false
}

function unlinkZelty() {
  zeltyProductId.value = null
  zeltySearch.value = ''
}

function openZeltyDropdown() {
  fetchZeltyDishes()
  showZeltyDropdown.value = true
}

function closeZeltyDropdown() {
  setTimeout(() => { showZeltyDropdown.value = false }, 200)
}

// Prix de vente multi-canal
const prixSurPlaceTTC = ref<number>(0)
const prixSurPlaceTVA = ref<number>(10)
const prixEmporterTTC = ref<number>(0)
const prixEmporterTVA = ref<number>(10)
const prixLivraisonTTC = ref<number>(0)
const prixLivraisonTVA = ref<number>(10)

// Ingredients
interface IngredientLigne {
  id?: string
  ingredient_id: string | null
  sous_recette_id: string | null
  quantite: number
  unite: string
  label: string // display name
  sur_place: boolean
  emporter: boolean
}
const ingredientLignes = ref<IngredientLigne[]>([])

// Options (unified: taille, extra, sans, choix)
const options = ref<RecetteOption[]>([])

// Search dropdowns
const ingredientSearch = ref('')
const sousRecetteSearch = ref('')
const showIngredientDropdown = ref(false)
const showSousRecetteDropdown = ref(false)
const showCategorieDropdown = ref(false)
const newIngQty = ref<number>(0)
const newIngUnite = ref('kg')
const newSrQty = ref<number>(0)

// State
const saving = ref(false)
const saveError = ref<string | null>(null)
const deleting = ref(false)
const showDeleteConfirm = ref(false)
const sousRecetteParents = ref<string[]>([])

/** Check and show delete confirmation, warning if used as sous-recette elsewhere */
async function confirmDelete() {
  sousRecetteParents.value = []
  if (recetteId.value) {
    try {
      const refs = await restCall<{ recette_id: string }[]>(
        'GET',
        `recette_ingredients?sous_recette_id=eq.${recetteId.value}&select=recette_id`,
      )
      sousRecetteParents.value = refs
        .map((r) => recettesStore.getById(r.recette_id)?.nom || 'Recette inconnue')
        .filter((v, i, a) => a.indexOf(v) === i)
    } catch { /* proceed anyway */ }
  }
  showDeleteConfirm.value = true
}

// --- Computed ---

function getIngredientCost(id: string): number {
  const ing = ingredientsStore.getById(id)
  return ing?.cout_unitaire ?? 0
}

function getIngredientUniteStock(id: string): string {
  const ing = ingredientsStore.getById(id)
  return ing?.unite_stock || 'g'
}

function ligneCost(ligne: IngredientLigne): number {
  if (ligne.ingredient_id) {
    const ing = ingredientsStore.getById(ligne.ingredient_id)
    const stockUnite = ing?.unite_stock || ligne.unite
    const factor = getUnitFactor(ligne.unite, stockUnite)
    return ligne.quantite * factor * getIngredientCost(ligne.ingredient_id)
  } else if (ligne.sous_recette_id) {
    const sr = recettesStore.getById(ligne.sous_recette_id)
    if (sr) {
      const srCost = recettesStore.calculateCost(ligne.sous_recette_id, getIngredientCost, 0, getIngredientUniteStock)
      const costPerPortion = sr.nb_portions > 0 ? srCost / sr.nb_portions : srCost
      return ligne.quantite * costPerPortion
    }
  }
  return 0
}

const coutMatiere = computed<number>(() =>
  ingredientLignes.value.reduce((sum, l) => sum + ligneCost(l), 0)
)

const coutMatiereSP = computed<number>(() =>
  ingredientLignes.value
    .filter(l => l.sur_place)
    .reduce((sum, l) => sum + ligneCost(l), 0)
)

const coutMatiereEMP = computed<number>(() =>
  ingredientLignes.value
    .filter(l => l.emporter)
    .reduce((sum, l) => sum + ligneCost(l), 0)
)

const coutParPortion = computed(() =>
  nbPortions.value > 0 ? coutMatiere.value / nbPortions.value : 0
)

// Allergen summary (recursive through sub-recipes)
const ALLERGEN_LABELS: Record<string, string> = {
  gluten: 'Gluten', crustaces: 'Crustacés', oeufs: 'Oeufs', poissons: 'Poissons',
  arachides: 'Arachides', soja: 'Soja', lait: 'Lait', fruits_a_coque: 'Fruits à coque',
  celeri: 'Céleri', moutarde: 'Moutarde', sesame: 'Sésame', sulfites: 'Sulfites',
  lupin: 'Lupin', mollusques: 'Mollusques',
}

const recetteAllergens = computed<string[]>(() => {
  if (isNew.value || !recetteId.value) return []
  const allergens = recettesStore.getAllergens(
    recetteId.value,
    (id: string) => {
      const ing = ingredientsStore.getById(id)
      if (!ing) return undefined
      return { allergenes: ing.allergenes, contient: ing.contient }
    },
  )
  return [...allergens].sort()
})

const filteredIngredients = computed(() => {
  const q = ingredientSearch.value.toLowerCase()
  if (!q) return ingredientsStore.actifs.slice(0, 20)
  return ingredientsStore.search(q).slice(0, 20)
})

const filteredSousRecettes = computed(() => {
  const q = sousRecetteSearch.value.toLowerCase()
  const list = recettesStore.sousRecettes.filter(
    sr => sr.id !== recetteId.value // can't reference self
  )
  if (!q) return list.slice(0, 20)
  return list
    .filter(sr => sr.nom.toLowerCase().includes(q))
    .slice(0, 20)
})

const filteredCategories = computed(() => {
  const q = categorie.value.toLowerCase().trim()
  const all = recettesStore.categories
  if (!q) return all
  return all.filter(c => c.toLowerCase().includes(q))
})

function selectCategorie(cat: string) {
  categorie.value = cat
  showCategorieDropdown.value = false
}

function closeCategorieDropdown() {
  // Small delay so mousedown on dropdown-item fires first
  setTimeout(() => { showCategorieDropdown.value = false }, 150)
}

// Sub-recipe hierarchy tree (up to 3 levels)
interface TreeNode {
  label: string
  quantite: number
  unite: string
  cost: number
  children: TreeNode[]
  depth: number
}

function buildTree(recId: string, depth = 0): TreeNode[] {
  if (depth > 3) return []
  const ingredients = recettesStore.getIngredients(recId)
  const nodes: TreeNode[] = []

  for (const ri of ingredients) {
    if (ri.ingredient_id) {
      const ing = ingredientsStore.getById(ri.ingredient_id)
      nodes.push({
        label: ing?.nom ?? 'Inconnu',
        quantite: ri.quantite,
        unite: ri.unite,
        cost: ri.quantite * (ing?.cout_unitaire ?? 0),
        children: [],
        depth,
      })
    } else if (ri.sous_recette_id) {
      const sr = recettesStore.getById(ri.sous_recette_id)
      if (sr) {
        const srCost = recettesStore.calculateCost(ri.sous_recette_id, getIngredientCost, 0, getIngredientUniteStock)
        const costPerPortion = sr.nb_portions > 0 ? srCost / sr.nb_portions : srCost
        nodes.push({
          label: sr.nom,
          quantite: ri.quantite,
          unite: 'portion(s)',
          cost: ri.quantite * costPerPortion,
          children: buildTree(ri.sous_recette_id, depth + 1),
          depth,
        })
      }
    }
  }
  return nodes
}

const ingredientTree = computed<TreeNode[]>(() => {
  if (isNew.value || !recetteId.value) return []
  return buildTree(recetteId.value)
})

// Show tree only when we have sub-recipes
const hasSubRecipes = computed(() =>
  ingredientLignes.value.some(l => l.sous_recette_id !== null)
)

// --- Actions ---

function addIngredient(ing: IngredientRestaurant) {
  const qty = newIngQty.value > 0 ? newIngQty.value : 1
  ingredientLignes.value.push({
    ingredient_id: ing.id,
    sous_recette_id: null,
    quantite: qty,
    unite: ing.unite_stock,
    label: ing.nom,
    sur_place: true,
    emporter: true,
  })
  ingredientSearch.value = ''
  newIngQty.value = 0
  newIngUnite.value = 'kg'
  showIngredientDropdown.value = false
}

function addSousRecette(sr: Recette) {
  const qty = newSrQty.value > 0 ? newSrQty.value : 1
  ingredientLignes.value.push({
    ingredient_id: null,
    sous_recette_id: sr.id,
    quantite: qty,
    unite: 'portion(s)',
    label: sr.nom,
    sur_place: true,
    emporter: true,
  })
  sousRecetteSearch.value = ''
  newSrQty.value = 0
  showSousRecetteDropdown.value = false
}

function removeLigne(index: number) {
  ingredientLignes.value.splice(index, 1)
}

function addOption(type: RecetteOption['type']) {
  const opt: RecetteOption = { nom: '', type }
  if (type === 'taille') opt.coefficient = 1.0
  if (type === 'extra') opt.prix_supplement = 0
  options.value.push(opt)
}

function removeOption(index: number) {
  options.value.splice(index, 1)
}

// --- Option ingredient linking ---
const optIngSearch = ref<Record<number, string>>({})
const showOptIngDropdown = ref<Record<number, boolean>>({})

function getOptIngredientLabel(o: RecetteOption): string | null {
  const first = o.impact_stock?.[0]
  if (!first) return null
  const ing = ingredientsStore.getById(first.ingredient_restaurant_id)
  return ing?.nom || null
}

function filteredOptIngredients(idx: number) {
  const q = (optIngSearch.value[idx] || '').toLowerCase()
  if (!q) return ingredientsStore.actifs.slice(0, 15)
  return ingredientsStore.search(q).slice(0, 15)
}

function selectOptIngredient(idx: number, ing: IngredientRestaurant) {
  const o = options.value[idx]
  if (!o) return

  // Auto-fill quantity: look for this ingredient in the recipe's ingredient lines
  let autoQty = o.impact_stock?.[0]?.quantite || 0
  if (autoQty === 0 && o.type === 'extra') {
    const recipeLine = ingredientLignes.value.find(l => l.ingredient_id === ing.id)
    if (recipeLine) {
      // Use the recipe's quantity in stock units
      const factor = getUnitFactor(recipeLine.unite, ing.unite_stock)
      autoQty = Math.round(recipeLine.quantite * factor * 100) / 100
    }
  }

  o.impact_stock = [{
    ingredient_restaurant_id: ing.id,
    quantite: autoQty,
    unite: ing.unite_stock,
  }]
  optIngSearch.value[idx] = ''
  showOptIngDropdown.value[idx] = false
}

function removeOptIngredient(idx: number) {
  const o = options.value[idx]
  if (o) o.impact_stock = undefined
}

function closeOptIngDropdown(idx: number) {
  setTimeout(() => { showOptIngDropdown.value[idx] = false }, 150)
}

// Show add-option dropdown
const showAddOptionMenu = ref(false)

function buildPrixVente(): Recette['prix_vente'] {
  const pv: Record<string, PrixVenteCanal> = {}
  if (prixSurPlaceTTC.value > 0) {
    pv.sur_place = { ttc: prixSurPlaceTTC.value, tva: prixSurPlaceTVA.value }
  }
  if (prixEmporterTTC.value > 0) {
    pv.emporter = { ttc: prixEmporterTTC.value, tva: prixEmporterTVA.value }
  }
  if (prixLivraisonTTC.value > 0) {
    pv.livraison = { ttc: prixLivraisonTTC.value, tva: prixLivraisonTVA.value }
  }
  return Object.keys(pv).length > 0 ? pv : null
}

async function handleSave() {
  saving.value = true
  saveError.value = null

  try {
    const recetteData: Partial<Recette> = {
      nom: nom.value,
      type: type.value,
      categorie: categorie.value || null,
      description: description.value || null,
      instructions: instructions.value || null,
      nb_portions: nbPortions.value,
      cout_matiere: coutMatiere.value,
      cout_emballage: coutEmballage.value || null,
      prix_vente: buildPrixVente(),
      zelty_product_id: zeltyProductId.value || null,
      options: options.value.length > 0 ? options.value : null,
      photo_url: photoUrl.value || null,
      actif: actif.value,
    }

    let savedId: string

    if (isNew.value) {
      const data = await restCall<{ id: string }>(
        'POST', 'recettes', recetteData, { single: true },
      )
      savedId = data.id
    } else {
      savedId = recetteId.value!
      await restCall('PATCH', `recettes?id=eq.${savedId}`, recetteData)
    }

    // Save ingredient lines: delete all then re-insert
    await restCall('DELETE', `recette_ingredients?recette_id=eq.${savedId}`)

    if (ingredientLignes.value.length > 0) {
      const lignesInsert = ingredientLignes.value.map(l => ({
        recette_id: savedId,
        ingredient_id: l.ingredient_id,
        sous_recette_id: l.sous_recette_id,
        quantite: l.quantite,
        unite: l.unite,
        sur_place: l.sur_place,
        emporter: l.emporter,
      }))
      await restCall('POST', 'recette_ingredients', lignesInsert)
    }

    // Refresh store
    await recettesStore.fetchAll()

    if (isNew.value) {
      router.replace(`/recettes/${savedId}`)
    }
  } catch (e: unknown) {
    saveError.value = e instanceof Error ? e.message : 'Erreur sauvegarde'
  } finally {
    saving.value = false
  }
}

async function handleDelete() {
  if (!recetteId.value) return
  deleting.value = true
  saveError.value = null
  try {
    // Clean up any sous-recette references in other recipes before deleting
    await restCall('DELETE', `recette_ingredients?sous_recette_id=eq.${recetteId.value}`)

    // Delete child rows: ingredients of this recipe
    await restCall('DELETE', `recette_ingredients?recette_id=eq.${recetteId.value}`)

    // Delete the recipe itself
    await restCall('DELETE', `recettes?id=eq.${recetteId.value}`)

    // Verify the deletion actually happened (RLS can silently block)
    const check = await restCall<{ id: string }[]>(
      'GET',
      `recettes?id=eq.${recetteId.value}&select=id`,
    )
    if (check.length > 0) {
      saveError.value = 'La suppression a échoué. Vérifiez vos permissions ou contactez un administrateur.'
      return
    }

    await recettesStore.fetchAll()
    router.replace('/recettes')
  } catch (e: unknown) {
    saveError.value = e instanceof Error ? e.message : 'Erreur suppression'
  } finally {
    deleting.value = false
    showDeleteConfirm.value = false
  }
}

// --- Load existing recipe ---
onMounted(async () => {
  await Promise.all([
    recettesStore.fetchAll(),
    ingredientsStore.fetchAll(),
  ])

  if (!isNew.value && recetteId.value) {
    const r = recettesStore.getById(recetteId.value)
    if (!r) {
      router.replace('/recettes')
      return
    }

    nom.value = r.nom
    type.value = r.type
    categorie.value = r.categorie ?? ''
    description.value = r.description ?? ''
    instructions.value = r.instructions ?? ''
    nbPortions.value = r.nb_portions
    coutEmballage.value = r.cout_emballage ?? 0
    photoUrl.value = r.photo_url
    zeltyProductId.value = r.zelty_product_id
    if (r.zelty_product_id) fetchZeltyDishes()
    actif.value = r.actif
    options.value = r.options
      ? r.options.map(o => ({ ...o, impact_stock: o.impact_stock ? [...o.impact_stock] : undefined }))
      : []

    // Prix
    if (r.prix_vente?.sur_place) {
      prixSurPlaceTTC.value = r.prix_vente.sur_place.ttc
      prixSurPlaceTVA.value = r.prix_vente.sur_place.tva
    }
    if (r.prix_vente?.emporter) {
      prixEmporterTTC.value = r.prix_vente.emporter.ttc
      prixEmporterTVA.value = r.prix_vente.emporter.tva
    }
    if (r.prix_vente?.livraison) {
      prixLivraisonTTC.value = r.prix_vente.livraison.ttc
      prixLivraisonTVA.value = r.prix_vente.livraison.tva
    }

    // Ingredients
    const ris = recettesStore.getIngredients(r.id)
    ingredientLignes.value = ris.map(ri => {
      let label = 'Inconnu'
      if (ri.ingredient_id) {
        label = ingredientsStore.getById(ri.ingredient_id)?.nom ?? 'Inconnu'
      } else if (ri.sous_recette_id) {
        label = recettesStore.getById(ri.sous_recette_id)?.nom ?? 'Sous-recette inconnue'
      }
      return {
        id: ri.id,
        ingredient_id: ri.ingredient_id,
        sous_recette_id: ri.sous_recette_id,
        quantite: ri.quantite,
        unite: ri.unite,
        label,
        sur_place: ri.sur_place ?? true,
        emporter: ri.emporter ?? true,
      }
    })
  }
})

// Close dropdowns on outside click
function closeDropdowns() {
  showIngredientDropdown.value = false
  showSousRecetteDropdown.value = false
}

// Unit families: only allow conversion within same category
const UNITE_FAMILIES: Record<string, string[]> = {
  kg: ['kg', 'g'],
  g: ['g', 'kg'],
  L: ['L', 'mL', 'cl'],
  mL: ['mL', 'L', 'cl'],
  cl: ['cl', 'mL', 'L'],
  unite: ['unite', 'piece'],
  piece: ['piece', 'unite'],
  botte: ['botte'],
}

function uniteOptionsFor(currentUnite: string, ingredientId?: string | null): string[] {
  // Base options on ingredient's unite_stock (not the potentially-wrong current unit)
  let baseUnite = currentUnite
  if (ingredientId) {
    const ing = ingredientsStore.getById(ingredientId)
    if (ing?.unite_stock) baseUnite = ing.unite_stock
  }
  const options = UNITE_FAMILIES[baseUnite] || [baseUnite]
  // Include current unite if not already in list (backward compat)
  if (!options.includes(currentUnite)) options.push(currentUnite)
  return options
}
const TVA_OPTIONS = [5.5, 10, 20]
const TYPE_OPTIONS: { value: RecetteType; label: string }[] = [
  { value: 'recette', label: 'Recette (plat)' },
  { value: 'sous_recette', label: 'Sous-recette' },
]
</script>

<template>
  <div class="recette-detail" @click="closeDropdowns">
    <!-- Header -->
    <div class="page-header">
      <div>
        <button class="btn-back" @click="router.push('/recettes')">
          &larr; Retour
        </button>
        <h1>{{ isNew ? 'Nouvelle recette' : nom }}</h1>
      </div>
      <div v-if="!isNew && isAdmin" class="header-actions">
        <label class="toggle-actif">
          <input type="checkbox" v-model="actif" class="toggle-check" />
          <span class="toggle-slider" />
          <span class="toggle-label">{{ actif ? 'Actif' : 'Inactif' }}</span>
        </label>
        <button
          class="btn-delete"
          @click.stop="confirmDelete"
        >
          Supprimer
        </button>
      </div>
    </div>

    <!-- Delete confirmation -->
    <div v-if="showDeleteConfirm" class="confirm-overlay" @click.self="showDeleteConfirm = false">
      <div class="confirm-dialog">
        <p>Supprimer la recette <strong>{{ nom }}</strong> ?</p>
        <p v-if="sousRecetteParents.length > 0" class="confirm-warning">
          Cette recette est r&eacute;f&eacute;renc&eacute;e comme sous-recette dans : <strong>{{ sousRecetteParents.join(', ') }}</strong>. Ces r&eacute;f&eacute;rences seront retir&eacute;es automatiquement.
        </p>
        <p class="confirm-sub">Cette action est irr&eacute;versible.</p>
        <div class="confirm-actions">
          <button class="btn-secondary" @click="showDeleteConfirm = false">Annuler</button>
          <button class="btn-danger" :disabled="deleting" @click="handleDelete">
            {{ deleting ? 'Suppression...' : 'Confirmer' }}
          </button>
        </div>
      </div>
    </div>

    <!-- Error banner -->
    <div v-if="saveError" class="error-banner">{{ saveError }}</div>

    <!-- SECTION: Info de base -->
    <section class="form-section">
      <h2>Informations</h2>
      <div class="info-header" :class="{ 'has-photo': !!photoUrl }">
        <div v-if="photoUrl" class="recette-photo-container">
          <img :src="photoUrl" :alt="nom" class="recette-photo" />
        </div>
        <div class="info-fields">
          <div class="field full">
            <label>Nom</label>
            <input
              v-model="nom"
              type="text"
              placeholder="Nom de la recette"
              class="input"
            />
          </div>
          <!-- Zelty link -->
          <div class="field full">
            <label>Produit Zelty (caisse)</label>
            <div v-if="zeltyProductId" class="zelty-linked">
              <span class="zelty-linked-name">
                <span class="zelty-badge">Zelty</span>
                {{ linkedZeltyName }}
              </span>
              <button type="button" class="btn-unlink" @click="unlinkZelty">Délier</button>
            </div>
            <div v-else class="search-dropdown" @click.stop>
              <input
                v-model="zeltySearch"
                type="text"
                placeholder="Rechercher un produit Zelty..."
                class="input"
                @focus="openZeltyDropdown"
                @blur="closeZeltyDropdown"
              />
              <div v-if="zeltyLoading" class="dropdown-list">
                <div class="dropdown-item" style="justify-content:center;color:var(--text-tertiary);">
                  Chargement...
                </div>
              </div>
              <div v-else-if="showZeltyDropdown && filteredZeltyDishes.length > 0" class="dropdown-list">
                <button
                  v-for="dish in filteredZeltyDishes"
                  :key="dish.id"
                  type="button"
                  class="dropdown-item"
                  @mousedown.prevent="selectZeltyDish(dish)"
                >
                  <span>{{ dish.name }}</span>
                  <span class="dd-meta">ID {{ dish.id }}</span>
                </button>
              </div>
              <div v-else-if="showZeltyDropdown && zeltyLoaded && filteredZeltyDishes.length === 0" class="dropdown-list">
                <div class="dropdown-item" style="color:var(--text-tertiary);justify-content:center;">
                  Aucun produit disponible
                </div>
              </div>
            </div>
            <span v-if="zeltyProductId" class="field-hint">
              Lié au produit Zelty — le stock sera décrémenté automatiquement.
            </span>
          </div>
          <div class="info-fields-row">
            <div class="field">
              <label>Type</label>
              <select v-model="type" class="input">
                <option v-for="t in TYPE_OPTIONS" :key="t.value" :value="t.value">
                  {{ t.label }}
                </option>
              </select>
            </div>
            <div class="field">
              <label>Catégorie</label>
              <div class="search-dropdown" @click.stop>
                <input
                  v-model="categorie"
                  type="text"
                  placeholder="Ex: Bowls, Desserts..."
                  class="input"
                  @focus="showCategorieDropdown = true"
                  @blur="closeCategorieDropdown"
                />
                <div v-if="showCategorieDropdown && filteredCategories.length > 0" class="dropdown-list">
                  <button
                    v-for="cat in filteredCategories"
                    :key="cat"
                    class="dropdown-item"
                    @mousedown.prevent="selectCategorie(cat)"
                  >
                    {{ cat }}
                  </button>
                </div>
              </div>
            </div>
            <div class="field">
              <label>Nb portions</label>
              <input v-model.number="nbPortions" type="number" min="1" inputmode="numeric" class="input" />
            </div>
          </div>
        </div>
      </div>
      <div class="form-grid">
        <div class="field full">
          <label>Description</label>
          <textarea v-model="description" rows="2" placeholder="Description courte..." class="input textarea" />
        </div>
        <div class="field full">
          <label>Instructions de pr&eacute;paration</label>
          <textarea v-model="instructions" rows="4" placeholder="&Eacute;tapes de pr&eacute;paration..." class="input textarea" />
        </div>
      </div>
    </section>

    <!-- SECTION: Ingredients -->
    <section class="form-section">
      <h2>Ingr&eacute;dients</h2>

      <!-- Column headers -->
      <div v-if="ingredientLignes.length > 0" class="ingredient-header">
        <span class="ih-spacer"></span>
        <span class="ih-name"></span>
        <span class="ih-qty"></span>
        <span class="ih-unite"></span>
        <span class="ih-cost"></span>
        <span class="ih-canal" title="Sur place">SP</span>
        <span class="ih-canal" title="Emporter / Livraison">EMP</span>
        <span class="ih-remove"></span>
      </div>

      <!-- Current ingredients list -->
      <div class="ingredient-list">
        <div
          v-for="(ligne, idx) in ingredientLignes"
          :key="idx"
          class="ingredient-row"
        >
          <span class="ing-badge" :class="{ 'is-sr': ligne.sous_recette_id }">
            {{ ligne.sous_recette_id ? 'SR' : 'ING' }}
          </span>
          <router-link
            v-if="ligne.ingredient_id"
            :to="{ name: 'ingredient-detail', params: { id: ligne.ingredient_id } }"
            class="ing-name ing-link"
          >{{ ligne.label }}</router-link>
          <router-link
            v-else-if="ligne.sous_recette_id"
            :to="{ name: 'recette-detail', params: { id: ligne.sous_recette_id } }"
            class="ing-name ing-link"
          >{{ ligne.label }}</router-link>
          <span v-else class="ing-name">{{ ligne.label }}</span>
          <input
            v-model.number="ligne.quantite"
            type="number"
            min="0"
            step="0.01"
            inputmode="decimal"
            class="ing-qty"
          />
          <select v-model="ligne.unite" class="ing-unite-select" @click.stop>
            <option v-for="u in uniteOptionsFor(ligne.unite, ligne.ingredient_id)" :key="u" :value="u">{{ u }}</option>
          </select>
          <span class="ing-cost">
            {{
              (ligne.ingredient_id || ligne.sous_recette_id)
                ? ligneCost(ligne).toFixed(2)
                : '--'
            }} &euro;
          </span>
          <label class="canal-toggle" title="Sur place">
            <input type="checkbox" v-model="ligne.sur_place" />
            <span class="toggle-track"><span class="toggle-thumb"></span></span>
          </label>
          <label class="canal-toggle" title="Emporter / Livraison">
            <input type="checkbox" v-model="ligne.emporter" />
            <span class="toggle-track"><span class="toggle-thumb"></span></span>
          </label>
          <button class="btn-remove" @click="removeLigne(idx)">&times;</button>
        </div>
        <div v-if="ingredientLignes.length === 0" class="empty-small">
          Aucun ingr&eacute;dient ajout&eacute;
        </div>
      </div>

      <!-- Add ingredient -->
      <div class="add-row">
        <div class="search-dropdown" @click.stop>
          <input
            v-model="ingredientSearch"
            type="text"
            placeholder="Ajouter un ingr&eacute;dient..."
            class="input"
            @focus="showIngredientDropdown = true"
          />
          <div v-if="showIngredientDropdown && filteredIngredients.length > 0" class="dropdown-list">
            <button
              v-for="ing in filteredIngredients"
              :key="ing.id"
              class="dropdown-item"
              @click="addIngredient(ing)"
            >
              {{ ing.nom }}
              <span class="dd-meta">{{ ing.cout_unitaire.toFixed(2) }} &euro;/{{ ing.unite_stock }}</span>
            </button>
          </div>
        </div>
        <input
          v-model.number="newIngQty"
          type="number"
          min="0"
          step="0.01"
          inputmode="decimal"
          placeholder="Qt&eacute;"
          class="input input-sm"
        />
      </div>

      <!-- Add sous-recette -->
      <div class="add-row">
        <div class="search-dropdown" @click.stop>
          <input
            v-model="sousRecetteSearch"
            type="text"
            placeholder="Ajouter une sous-recette..."
            class="input"
            @focus="showSousRecetteDropdown = true"
          />
          <div v-if="showSousRecetteDropdown && filteredSousRecettes.length > 0" class="dropdown-list">
            <button
              v-for="sr in filteredSousRecettes"
              :key="sr.id"
              class="dropdown-item"
              @click="addSousRecette(sr)"
            >
              {{ sr.nom }}
              <span class="dd-meta">{{ sr.nb_portions }} portion(s)</span>
            </button>
          </div>
        </div>
        <input
          v-model.number="newSrQty"
          type="number"
          min="0"
          step="0.01"
          inputmode="decimal"
          placeholder="Qt&eacute; portions"
          class="input input-sm"
        />
      </div>

      <!-- Cost summary -->
      <div class="cost-summary">
        <div class="cost-row">
          <span>Coût matière total</span>
          <strong>{{ coutMatiere.toFixed(2) }} €</strong>
        </div>
        <div class="cost-row cost-row-canal">
          <span>Sur place (SP)</span>
          <strong>{{ coutMatiereSP.toFixed(2) }} €</strong>
        </div>
        <div class="cost-row cost-row-canal">
          <span>Emporter / Livraison (EMP)</span>
          <strong>{{ coutMatiereEMP.toFixed(2) }} €</strong>
        </div>
        <div class="cost-row" style="border-top: 1px solid var(--color-border); margin-top: 4px; padding-top: 10px;">
          <span>Coût par portion ({{ nbPortions }} portions)</span>
          <strong>{{ coutParPortion.toFixed(2) }} €</strong>
        </div>
      </div>

      <!-- Allergen summary -->
      <div v-if="recetteAllergens.length > 0" class="allergen-summary">
        <strong>Allerg&egrave;nes :</strong>
        <div class="allergen-tags">
          <span v-for="a in recetteAllergens" :key="a" class="allergen-tag">
            {{ ALLERGEN_LABELS[a] || a }}
          </span>
        </div>
      </div>
      <div v-else-if="!isNew && ingredientLignes.length > 0" class="allergen-summary allergen-none">
        Aucun allerg&egrave;ne d&eacute;tect&eacute;
      </div>
    </section>

    <!-- SECTION: Sub-recipe tree -->
    <section v-if="hasSubRecipes && !isNew" class="form-section">
      <h2>Arborescence sous-recettes</h2>
      <div class="tree">
        <template v-for="node in ingredientTree" :key="node.label + node.depth">
          <div class="tree-node" :style="{ paddingLeft: node.depth * 24 + 'px' }">
            <span class="tree-indent" v-if="node.depth > 0"></span>
            <span class="tree-label" :class="{ 'has-children': node.children.length > 0 }">
              {{ node.label }}
            </span>
            <span class="tree-qty">{{ node.quantite }} {{ node.unite }}</span>
            <span class="tree-cost">{{ node.cost.toFixed(2) }} &euro;</span>
          </div>
          <!-- Level 2 -->
          <template v-for="child in node.children" :key="child.label + child.depth">
            <div class="tree-node" :style="{ paddingLeft: child.depth * 24 + 'px' }">
              <span class="tree-indent"></span>
              <span class="tree-label" :class="{ 'has-children': child.children.length > 0 }">
                {{ child.label }}
              </span>
              <span class="tree-qty">{{ child.quantite }} {{ child.unite }}</span>
              <span class="tree-cost">{{ child.cost.toFixed(2) }} &euro;</span>
            </div>
            <!-- Level 3 -->
            <div
              v-for="grandchild in child.children"
              :key="grandchild.label + grandchild.depth"
              class="tree-node"
              :style="{ paddingLeft: grandchild.depth * 24 + 'px' }"
            >
              <span class="tree-indent"></span>
              <span class="tree-label">{{ grandchild.label }}</span>
              <span class="tree-qty">{{ grandchild.quantite }} {{ grandchild.unite }}</span>
              <span class="tree-cost">{{ grandchild.cost.toFixed(2) }} &euro;</span>
            </div>
          </template>
        </template>
      </div>
    </section>

    <!-- SECTION: Options (unified — taille, extra, sans, choix) -->
    <section class="form-section">
      <div class="section-header">
        <h2>Options</h2>
        <div class="add-option-wrapper" @click.stop>
          <button class="btn-add-small" @click="showAddOptionMenu = !showAddOptionMenu">+ Ajouter</button>
          <div v-if="showAddOptionMenu" class="add-option-menu">
            <button @click="addOption('taille'); showAddOptionMenu = false">Taille</button>
            <button @click="addOption('extra'); showAddOptionMenu = false">Extra</button>
            <button @click="addOption('sans'); showAddOptionMenu = false">Sans</button>
            <button @click="addOption('choix'); showAddOptionMenu = false">Choix</button>
          </div>
        </div>
      </div>
      <p class="section-hint">Synchronis&eacute;es depuis Zelty. Tailles, extras, retraits et choix.</p>
      <div class="options-list">
        <div v-for="(o, idx) in options" :key="idx" class="option-card">
          <div class="option-row-top">
            <span v-if="o.zelty_option_value_id" class="zelty-badge-xs" title="Synchronis&eacute; depuis Zelty">Z</span>
            <input
              v-model="o.nom"
              type="text"
              placeholder="Nom"
              class="input"
              :readonly="!!o.zelty_option_value_id"
            />
            <select v-model="o.type" class="input input-type">
              <option value="taille">Taille</option>
              <option value="extra">Extra</option>
              <option value="sans">Sans</option>
              <option value="choix">Choix</option>
            </select>
            <!-- Coefficient for taille -->
            <template v-if="o.type === 'taille'">
              <input
                v-model.number="o.coefficient"
                type="number"
                min="0.1"
                step="0.1"
                inputmode="decimal"
                placeholder="Coeff"
                class="input input-coeff"
              />
              <span class="option-preview">= {{ (coutParPortion * (o.coefficient || 1)).toFixed(2) }}&euro;/p</span>
            </template>
            <!-- Prix supplement for extra -->
            <template v-if="o.type === 'extra'">
              <span class="option-prix-label">+</span>
              <input
                v-model.number="o.prix_supplement"
                type="number"
                min="0"
                step="0.1"
                inputmode="decimal"
                placeholder="0.00"
                class="input input-prix"
              />
              <span class="option-prix-label">&euro;</span>
            </template>
            <button class="btn-remove" @click="removeOption(idx)">&times;</button>
          </div>
          <!-- Ingredient link row (for sans + extra only) -->
          <div v-if="o.type === 'sans' || o.type === 'extra'" class="option-row-ingredient">
            <template v-if="o.impact_stock && o.impact_stock.length > 0 && o.impact_stock[0] != null">
              <span class="opt-ing-label">
                {{ getOptIngredientLabel(o) || 'Ingr\u00e9dient inconnu' }}
              </span>
              <template v-if="o.type === 'extra'">
                <input
                  :value="(o.impact_stock[0] as any).quantite"
                  @input="(o.impact_stock[0] as any).quantite = Number(($event.target as HTMLInputElement).value)"
                  type="number"
                  min="0"
                  step="1"
                  inputmode="decimal"
                  placeholder="Qt&eacute;"
                  class="input input-qty"
                />
                <select
                  :value="(o.impact_stock[0] as any).unite"
                  @change="(o.impact_stock[0] as any).unite = ($event.target as HTMLSelectElement).value"
                  class="ing-unite-select"
                  @click.stop
                >
                  <option
                    v-for="u in uniteOptionsFor((o.impact_stock[0] as any).unite, (o.impact_stock[0] as any).ingredient_restaurant_id)"
                    :key="u" :value="u"
                  >{{ u }}</option>
                </select>
              </template>
              <button class="btn-remove-sm" @click="removeOptIngredient(idx)" title="Retirer le lien">&times;</button>
            </template>
            <template v-else>
              <div class="search-dropdown opt-ing-search" @click.stop>
                <input
                  :value="optIngSearch[idx] || ''"
                  @input="optIngSearch[idx] = ($event.target as HTMLInputElement).value"
                  type="text"
                  placeholder="Lier un ingr&eacute;dient..."
                  class="input"
                  style="width: 100%"
                  @focus="showOptIngDropdown[idx] = true"
                  @blur="closeOptIngDropdown(idx)"
                />
                <div v-if="showOptIngDropdown[idx] && filteredOptIngredients(idx).length > 0" class="dropdown-list">
                  <button
                    v-for="ing in filteredOptIngredients(idx)"
                    :key="ing.id"
                    class="dropdown-item"
                    @mousedown.prevent="selectOptIngredient(idx, ing)"
                  >
                    {{ ing.nom }}
                    <span class="dd-meta">{{ ing.unite_stock }}</span>
                  </button>
                </div>
              </div>
            </template>
          </div>
        </div>
        <div v-if="options.length === 0" class="empty-small">
          Aucune option
        </div>
      </div>
    </section>

    <!-- SECTION: Prix de vente multi-canal -->
    <section v-if="type === 'recette'" class="form-section">
      <h2>Prix de vente</h2>
      <div class="prix-canal-grid">
        <!-- Sur place -->
        <div class="prix-canal-card">
          <h3>Sur place</h3>
          <div class="prix-fields">
            <div class="field">
              <label>Prix TTC (&euro;)</label>
              <input
                v-model.number="prixSurPlaceTTC"
                type="number"
                min="0"
                step="0.1"
                inputmode="decimal"
                class="input"
              />
            </div>
            <div class="field">
              <label>TVA %</label>
              <select v-model.number="prixSurPlaceTVA" class="input">
                <option v-for="t in TVA_OPTIONS" :key="t" :value="t">{{ t }}%</option>
              </select>
            </div>
            <div class="prix-ht">
              HT : {{ prixSurPlaceTTC > 0 ? (prixSurPlaceTTC / (1 + prixSurPlaceTVA / 100)).toFixed(2) : '0.00' }} &euro;
            </div>
          </div>
        </div>

        <!-- Emporter -->
        <div class="prix-canal-card">
          <h3>&Agrave; emporter</h3>
          <div class="prix-fields">
            <div class="field">
              <label>Prix TTC (&euro;)</label>
              <input
                v-model.number="prixEmporterTTC"
                type="number"
                min="0"
                step="0.1"
                inputmode="decimal"
                class="input"
              />
            </div>
            <div class="field">
              <label>TVA %</label>
              <select v-model.number="prixEmporterTVA" class="input">
                <option v-for="t in TVA_OPTIONS" :key="t" :value="t">{{ t }}%</option>
              </select>
            </div>
            <div class="prix-ht">
              HT : {{ prixEmporterTTC > 0 ? (prixEmporterTTC / (1 + prixEmporterTVA / 100)).toFixed(2) : '0.00' }} &euro;
            </div>
          </div>
        </div>

        <!-- Livraison -->
        <div class="prix-canal-card">
          <h3>Livraison</h3>
          <div class="prix-fields">
            <div class="field">
              <label>Prix TTC (&euro;)</label>
              <input
                v-model.number="prixLivraisonTTC"
                type="number"
                min="0"
                step="0.1"
                inputmode="decimal"
                class="input"
              />
            </div>
            <div class="field">
              <label>TVA %</label>
              <select v-model.number="prixLivraisonTVA" class="input">
                <option v-for="t in TVA_OPTIONS" :key="t" :value="t">{{ t }}%</option>
              </select>
            </div>
            <div class="prix-ht">
              HT : {{ prixLivraisonTTC > 0 ? (prixLivraisonTTC / (1 + prixLivraisonTVA / 100)).toFixed(2) : '0.00' }} &euro;
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Save bar -->
    <div class="actions-bar">
      <button class="btn-secondary" @click="router.push('/recettes')">Annuler</button>
      <button
        class="btn-primary"
        :disabled="saving || !nom.trim()"
        @click="handleSave"
      >
        {{ saving ? 'Sauvegarde...' : isNew ? 'Cr&eacute;er la recette' : 'Enregistrer' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Page layout */
.recette-detail {
  max-width: 900px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
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
}

.header-actions {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 12px;
}

/* Toggle actif/inactif */
.toggle-actif {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  user-select: none;
}

.toggle-check {
  display: none;
}

.toggle-slider {
  width: 44px;
  height: 24px;
  background: #D1D5DB;
  border-radius: 12px;
  position: relative;
  transition: background 0.2s;
  flex-shrink: 0;
}

.toggle-slider::after {
  content: '';
  position: absolute;
  top: 2px;
  left: 2px;
  width: 20px;
  height: 20px;
  background: #fff;
  border-radius: 50%;
  transition: transform 0.2s;
}

.toggle-check:checked + .toggle-slider {
  background: var(--color-primary, #E85D2C);
}

.toggle-check:checked + .toggle-slider::after {
  transform: translateX(20px);
}

.toggle-label {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary, #4B5563);
}

.btn-delete {
  background: none;
  border: 2px solid var(--color-danger);
  color: var(--color-danger);
  border-radius: var(--radius-md);
  padding: 10px 20px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
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

.section-hint {
  font-size: 14px;
  color: var(--text-tertiary);
  margin-bottom: 12px;
}

/* Form grid */
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
.field-hint {
  font-size: 12px;
  color: var(--text-tertiary);
  margin-top: 4px;
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
  width: 100px;
  flex-shrink: 0;
}

/* Ingredient list */
.ingredient-list {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 16px;
}

.ingredient-row {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--bg-main);
  border-radius: var(--radius-sm);
  padding: 10px 14px;
}

.ing-badge {
  font-size: 11px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 4px;
  background: #dbeafe;
  color: #1e40af;
  flex-shrink: 0;
}

.ing-badge.is-sr {
  background: #fce7f3;
  color: #9d174d;
}

.ing-name {
  flex: 1;
  font-size: 15px;
  font-weight: 600;
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.ing-link {
  color: var(--color-primary);
  text-decoration: none;
  cursor: pointer;
}
.ing-link:hover {
  text-decoration: underline;
}

.info-header {
  display: flex;
  gap: 24px;
  margin-bottom: 16px;
}
.info-header:not(.has-photo) {
  display: block;
}
.info-header .recette-photo-container {
  flex-shrink: 0;
}
.info-header .info-fields {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.info-fields-row {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 16px;
}
.recette-photo-container {
  text-align: center;
}
.recette-photo {
  width: 180px;
  height: 180px;
  border-radius: 12px;
  object-fit: cover;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
@media (max-width: 700px) {
  .info-header {
    flex-direction: column;
    align-items: center;
  }
  .info-fields-row {
    grid-template-columns: 1fr 1fr;
  }
}

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

.ing-unite {
  font-size: 14px;
  color: var(--text-tertiary);
  width: 50px;
  flex-shrink: 0;
}

.ing-unite-select {
  width: 70px;
  height: 36px;
  border: 1.5px solid var(--border);
  border-radius: var(--radius-sm);
  font-size: 14px;
  color: var(--text-secondary);
  background: var(--bg-surface);
  padding: 0 4px;
  flex-shrink: 0;
  cursor: pointer;
}

.ing-unite-select:focus {
  outline: none;
  border-color: var(--color-primary);
}

.ing-cost {
  font-size: 14px;
  font-weight: 600;
  color: var(--color-primary);
  width: 70px;
  text-align: right;
  flex-shrink: 0;
}

/* Canal toggles */
.ingredient-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 14px 4px;
}

.ih-spacer { width: 36px; flex-shrink: 0; }
.ih-name { flex: 1; }
.ih-qty { width: 80px; flex-shrink: 0; }
.ih-unite { width: 70px; flex-shrink: 0; }
.ih-cost { width: 70px; flex-shrink: 0; }
.ih-canal {
  width: 42px;
  flex-shrink: 0;
  text-align: center;
  font-size: 11px;
  font-weight: 700;
  color: var(--text-tertiary);
  text-transform: uppercase;
}
.ih-remove { width: 36px; flex-shrink: 0; }

.canal-toggle {
  width: 42px;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.canal-toggle input {
  position: absolute;
  opacity: 0;
  width: 0;
  height: 0;
}

.toggle-track {
  width: 36px;
  height: 20px;
  background: #d1d5db;
  border-radius: 10px;
  position: relative;
  transition: background 0.2s;
}

.canal-toggle input:checked + .toggle-track {
  background: var(--color-primary);
}

.toggle-thumb {
  position: absolute;
  top: 2px;
  left: 2px;
  width: 16px;
  height: 16px;
  background: white;
  border-radius: 50%;
  transition: transform 0.2s;
  box-shadow: 0 1px 3px rgba(0,0,0,0.2);
}

.canal-toggle input:checked + .toggle-track .toggle-thumb {
  transform: translateX(16px);
}

.btn-remove {
  width: 36px;
  height: 36px;
  border: none;
  background: none;
  color: var(--color-danger);
  font-size: 22px;
  cursor: pointer;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-sm);
}

.btn-remove:active {
  background: #fef2f2;
}

.empty-small {
  font-size: 14px;
  color: var(--text-tertiary);
  padding: 12px 0;
  text-align: center;
}

/* Add row */
.add-row {
  display: flex;
  gap: 10px;
  align-items: flex-start;
  margin-bottom: 12px;
}

/* Zelty link */
.zelty-linked {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #f0fdf4;
  border: 1px solid #bbf7d0;
  border-radius: var(--radius-md);
  padding: 12px 14px;
  min-height: 48px;
  gap: 12px;
}

.zelty-linked-name {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 16px;
  font-weight: 500;
  color: var(--text-primary);
}

.zelty-badge {
  display: inline-block;
  background: #E85D2C;
  color: #fff;
  font-size: 11px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 4px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  flex-shrink: 0;
}

.btn-unlink {
  background: none;
  border: 1px solid var(--color-danger);
  color: var(--color-danger);
  border-radius: var(--radius-md);
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  min-height: 40px;
  flex-shrink: 0;
}

.search-dropdown {
  flex: 1;
  position: relative;
}

.dropdown-list {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  background: var(--bg-surface);
  border: 2px solid var(--border);
  border-top: none;
  border-radius: 0 0 var(--radius-md) var(--radius-md);
  max-height: 240px;
  overflow-y: auto;
  z-index: 50;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.dropdown-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  padding: 12px 14px;
  border: none;
  background: none;
  font-size: 15px;
  cursor: pointer;
  text-align: left;
}

.dropdown-item:active {
  background: var(--bg-main);
}

.dd-meta {
  font-size: 13px;
  color: var(--text-tertiary);
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

/* Allergens */
.allergen-summary {
  margin-top: 16px;
  padding: 12px 16px;
  background: rgba(239, 68, 68, 0.06);
  border-radius: var(--radius-md);
  border-left: 4px solid #ef4444;
  font-size: 15px;
}
.allergen-summary.allergen-none {
  background: rgba(34, 197, 94, 0.06);
  border-left-color: var(--color-success);
  color: var(--color-success);
}
.allergen-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  margin-top: 8px;
}
.allergen-tag {
  background: #ef4444;
  color: white;
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 13px;
  font-weight: 600;
}

.cost-row-canal {
  font-size: 14px;
  padding: 3px 0 3px 16px;
  opacity: 0.85;
}

.cost-row-canal strong {
  font-size: 15px;
}

/* Tree */
.tree {
  background: var(--bg-main);
  border-radius: var(--radius-md);
  padding: 12px 0;
}

.tree-node {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  font-size: 14px;
}

.tree-indent {
  display: inline-block;
  width: 12px;
  height: 12px;
  border-left: 2px solid var(--border);
  border-bottom: 2px solid var(--border);
  margin-right: 4px;
  flex-shrink: 0;
}

.tree-label {
  flex: 1;
  font-weight: 500;
}

.tree-label.has-children {
  font-weight: 700;
  color: var(--color-primary);
}

.tree-qty {
  color: var(--text-tertiary);
  font-size: 13px;
  flex-shrink: 0;
}

.tree-cost {
  font-weight: 600;
  font-size: 13px;
  color: var(--text-secondary);
  width: 70px;
  text-align: right;
  flex-shrink: 0;
}

/* Zelty badge */
.zelty-badge-xs {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  background: #FFF7ED;
  border: 1.5px solid var(--color-primary);
  color: var(--color-primary);
  border-radius: 4px;
  font-size: 11px;
  font-weight: 800;
  flex-shrink: 0;
}

/* Options (unified) */
.options-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.option-card {
  background: var(--bg-card);
  border-radius: var(--radius-md);
  padding: 12px;
  border: 1px solid var(--border);
}

.option-row-top {
  display: flex;
  align-items: center;
  gap: 10px;
}

.option-row-top .input:first-child,
.option-row-top .zelty-badge-xs + .input {
  flex: 1;
}

.option-row-top input[readonly] {
  background: var(--bg-main);
  color: var(--text-secondary);
  cursor: default;
}

.input-type {
  width: 100px;
  flex-shrink: 0;
}

.input-coeff {
  width: 80px;
  flex-shrink: 0;
}

.input-prix {
  width: 90px;
  flex-shrink: 0;
}

.option-preview {
  font-size: 13px;
  color: var(--text-tertiary);
  white-space: nowrap;
}

.option-prix-label {
  font-size: 15px;
  font-weight: 600;
  color: var(--text-secondary);
  flex-shrink: 0;
}

.option-row-ingredient {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-top: 8px;
  padding-top: 8px;
  padding-left: 16px;
  border-top: 1px solid var(--border);
  font-size: 14px;
}

.option-row-ingredient::before {
  content: '└';
  color: var(--text-tertiary);
  font-size: 13px;
  flex-shrink: 0;
}

.opt-ing-label {
  font-weight: 600;
  color: var(--text-primary);
}

.opt-ing-unite {
  color: var(--text-tertiary);
  font-size: 13px;
}

.input-qty {
  width: 70px;
  flex-shrink: 0;
}

.opt-ing-search {
  flex: 1;
}

.add-option-wrapper {
  position: relative;
}

.add-option-menu {
  position: absolute;
  right: 0;
  top: 100%;
  background: white;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  z-index: 10;
  display: flex;
  flex-direction: column;
  min-width: 120px;
}

.add-option-menu button {
  padding: 10px 16px;
  border: none;
  background: none;
  text-align: left;
  cursor: pointer;
  font-size: 15px;
  color: var(--text-primary);
}

.add-option-menu button:hover {
  background: var(--bg-main);
}

.btn-remove-sm {
  background: none;
  border: none;
  color: var(--color-danger, #dc2626);
  font-size: 16px;
  cursor: pointer;
  padding: 2px 6px;
  flex-shrink: 0;
}

.btn-add-small {
  background: none;
  border: 1.5px solid var(--color-primary);
  color: var(--color-primary);
  border-radius: var(--radius-md);
  padding: 6px 14px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
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

.prix-ht {
  font-size: 14px;
  color: var(--text-secondary);
  font-weight: 600;
}

/* Buttons */
.btn-add {
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 10px 18px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  flex-shrink: 0;
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

.btn-danger {
  background: var(--color-danger);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 14px 28px;
  font-size: 17px;
  font-weight: 700;
  cursor: pointer;
}

.btn-danger:disabled {
  opacity: 0.5;
}

/* Confirm dialog */
.confirm-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
}

.confirm-dialog {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 32px;
  max-width: 400px;
  width: 90%;
}

.confirm-dialog p {
  font-size: 18px;
  margin-bottom: 8px;
}

.confirm-warning {
  font-size: 14px;
  color: var(--warning, #e67e22);
  background: #fef3e2;
  border-radius: var(--radius-md);
  padding: 10px 14px;
  margin-bottom: 12px;
}
.confirm-sub {
  font-size: 14px !important;
  color: var(--text-tertiary);
  margin-bottom: 24px !important;
}

.confirm-actions {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* Responsive: single column on smaller iPads */
@media (max-width: 700px) {
  .form-grid {
    grid-template-columns: 1fr;
  }

  .prix-canal-grid {
    grid-template-columns: 1fr;
  }

  .add-row {
    flex-wrap: wrap;
  }

  .option-row-top {
    flex-wrap: wrap;
  }
}
</style>
