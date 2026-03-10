<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRecettesStore } from '@/stores/recettes'
import { useIngredientsStore } from '@/stores/ingredients'
import { useAuth } from '@/composables/useAuth'
import { restCall } from '@/lib/rest-client'
import type {
  Recette,
  RecetteType,
  RecetteVariante,
  RecetteModificateur,
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
}
const ingredientLignes = ref<IngredientLigne[]>([])

// Variantes
const variantes = ref<RecetteVariante[]>([])

// Modificateurs
const modificateurs = ref<RecetteModificateur[]>([])

// Search dropdowns
const ingredientSearch = ref('')
const sousRecetteSearch = ref('')
const showIngredientDropdown = ref(false)
const showSousRecetteDropdown = ref(false)
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

const coutMatiere = computed<number>(() => {
  let total = 0
  for (const ligne of ingredientLignes.value) {
    if (ligne.ingredient_id) {
      total += ligne.quantite * getIngredientCost(ligne.ingredient_id)
    } else if (ligne.sous_recette_id) {
      const sr = recettesStore.getById(ligne.sous_recette_id)
      if (sr) {
        const srCost = recettesStore.calculateCost(ligne.sous_recette_id, getIngredientCost)
        const costPerPortion = sr.nb_portions > 0 ? srCost / sr.nb_portions : srCost
        total += ligne.quantite * costPerPortion
      }
    }
  }
  return total
})

const coutParPortion = computed(() =>
  nbPortions.value > 0 ? coutMatiere.value / nbPortions.value : 0
)

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
        const srCost = recettesStore.calculateCost(ri.sous_recette_id, getIngredientCost)
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
  if (newIngQty.value <= 0) return
  ingredientLignes.value.push({
    ingredient_id: ing.id,
    sous_recette_id: null,
    quantite: newIngQty.value,
    unite: newIngUnite.value || ing.unite_stock,
    label: ing.nom,
  })
  ingredientSearch.value = ''
  newIngQty.value = 0
  newIngUnite.value = 'kg'
  showIngredientDropdown.value = false
}

function addSousRecette(sr: Recette) {
  if (newSrQty.value <= 0) return
  ingredientLignes.value.push({
    ingredient_id: null,
    sous_recette_id: sr.id,
    quantite: newSrQty.value,
    unite: 'portion(s)',
    label: sr.nom,
  })
  sousRecetteSearch.value = ''
  newSrQty.value = 0
  showSousRecetteDropdown.value = false
}

function removeLigne(index: number) {
  ingredientLignes.value.splice(index, 1)
}

function addVariante() {
  variantes.value.push({ nom: '', coefficient: 1 })
}

function removeVariante(index: number) {
  variantes.value.splice(index, 1)
}

function addModificateur() {
  modificateurs.value.push({
    nom: '',
    type: 'extra',
    ingredients: [],
    prix_supplement: 0,
  })
}

function removeModificateur(index: number) {
  modificateurs.value.splice(index, 1)
}

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
      variantes: variantes.value.length > 0 ? variantes.value : null,
      modificateurs: modificateurs.value.length > 0 ? modificateurs.value : null,
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
    actif.value = r.actif
    variantes.value = r.variantes ? [...r.variantes] : []
    modificateurs.value = r.modificateurs
      ? r.modificateurs.map(m => ({ ...m, ingredients: [...m.ingredients] }))
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
      }
    })
  }
})

// Close dropdowns on outside click
function closeDropdowns() {
  showIngredientDropdown.value = false
  showSousRecetteDropdown.value = false
}

const UNITE_OPTIONS = ['kg', 'g', 'L', 'mL', 'cl', 'unite', 'piece', 'botte']
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
      <div class="form-grid">
        <div class="field full">
          <label>Nom</label>
          <input
            v-model="nom"
            type="text"
            placeholder="Nom de la recette"
            class="input"
            :disabled="!!zeltyProductId"
          />
          <span v-if="zeltyProductId" class="field-hint">Synchronisé depuis Zelty — nom non modifiable</span>
        </div>
        <div class="field">
          <label>Type</label>
          <select v-model="type" class="input">
            <option v-for="t in TYPE_OPTIONS" :key="t.value" :value="t.value">
              {{ t.label }}
            </option>
          </select>
        </div>
        <div class="field">
          <label>Cat&eacute;gorie</label>
          <input v-model="categorie" type="text" placeholder="Ex: Bowls, Desserts..." class="input" />
        </div>
        <div class="field">
          <label>Nb portions</label>
          <input v-model.number="nbPortions" type="number" min="1" inputmode="numeric" class="input" />
        </div>
        <div class="field">
          <label>Co&ucirc;t emballage (&euro;)</label>
          <input v-model.number="coutEmballage" type="number" min="0" step="0.01" inputmode="decimal" class="input" />
        </div>
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
          <span class="ing-name">{{ ligne.label }}</span>
          <input
            v-model.number="ligne.quantite"
            type="number"
            min="0"
            step="0.01"
            inputmode="decimal"
            class="ing-qty"
          />
          <span class="ing-unite">{{ ligne.unite }}</span>
          <span class="ing-cost">
            {{
              ligne.ingredient_id
                ? (ligne.quantite * getIngredientCost(ligne.ingredient_id)).toFixed(2)
                : '--'
            }} &euro;
          </span>
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
        <select v-model="newIngUnite" class="input input-sm">
          <option v-for="u in UNITE_OPTIONS" :key="u" :value="u">{{ u }}</option>
        </select>
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
          <span>Co&ucirc;t mati&egrave;re total</span>
          <strong>{{ coutMatiere.toFixed(2) }} &euro;</strong>
        </div>
        <div class="cost-row">
          <span>Co&ucirc;t par portion ({{ nbPortions }} portions)</span>
          <strong>{{ coutParPortion.toFixed(2) }} &euro;</strong>
        </div>
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

    <!-- SECTION: Variantes -->
    <section class="form-section">
      <div class="section-header">
        <h2>Variantes</h2>
        <button class="btn-add" @click="addVariante">+ Ajouter</button>
      </div>
      <p class="section-hint">Ex : &laquo; Grande +50% &raquo; &rarr; coefficient 1.5</p>
      <div class="variante-list">
        <div v-for="(v, idx) in variantes" :key="idx" class="variante-row">
          <input
            v-model="v.nom"
            type="text"
            placeholder="Nom (ex: Grande)"
            class="input"
          />
          <input
            v-model.number="v.coefficient"
            type="number"
            min="0.1"
            step="0.1"
            inputmode="decimal"
            class="input input-sm"
          />
          <span class="variante-preview">
            = {{ (coutParPortion * v.coefficient).toFixed(2) }} &euro;/portion
          </span>
          <button class="btn-remove" @click="removeVariante(idx)">&times;</button>
        </div>
        <div v-if="variantes.length === 0" class="empty-small">
          Aucune variante
        </div>
      </div>
    </section>

    <!-- SECTION: Modificateurs -->
    <section class="form-section">
      <div class="section-header">
        <h2>Modificateurs</h2>
        <button class="btn-add" @click="addModificateur">+ Ajouter</button>
      </div>
      <p class="section-hint">Extras, retraits avec liens ingr&eacute;dients et suppl&eacute;ment prix</p>
      <div class="mod-list">
        <div v-for="(m, idx) in modificateurs" :key="idx" class="mod-row">
          <input
            v-model="m.nom"
            type="text"
            placeholder="Nom (ex: Extra sauce)"
            class="input"
          />
          <select v-model="m.type" class="input input-sm">
            <option value="extra">Extra</option>
            <option value="sans">Sans</option>
            <option value="remplacement">Remplacement</option>
          </select>
          <input
            v-model.number="m.prix_supplement"
            type="number"
            min="0"
            step="0.1"
            inputmode="decimal"
            placeholder="Suppl. &euro;"
            class="input input-sm"
          />
          <button class="btn-remove" @click="removeModificateur(idx)">&times;</button>
        </div>
        <div v-if="modificateurs.length === 0" class="empty-small">
          Aucun modificateur
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

.ing-cost {
  font-size: 14px;
  font-weight: 600;
  color: var(--color-primary);
  width: 70px;
  text-align: right;
  flex-shrink: 0;
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

/* Variantes */
.variante-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.variante-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.variante-row .input:first-child {
  flex: 1;
}

.variante-preview {
  font-size: 13px;
  color: var(--text-tertiary);
  white-space: nowrap;
  min-width: 120px;
}

/* Modificateurs */
.mod-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.mod-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.mod-row .input:first-child {
  flex: 1;
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

  .variante-row,
  .mod-row {
    flex-wrap: wrap;
  }
}
</style>
