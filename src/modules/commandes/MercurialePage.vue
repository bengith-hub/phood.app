<script setup lang="ts">
import { ref, onMounted, computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useIngredientsStore } from '@/stores/ingredients'
import type { Mercuriale, Conditionnement } from '@/types/database'

const route = useRoute()
const mercurialeStore = useMercurialeStore()
const fournisseursStore = useFournisseursStore()
const ingredientsStore = useIngredientsStore()

// Filters
const search = ref('')
const filterFournisseurId = ref<string | null>(null)
const filterCategorie = ref<string | null>(null)
const filterActif = ref(true)
const showHelp = ref(false)

// Photo upload
const uploadingPhotoId = ref<string | null>(null)
const photoInputRef = ref<HTMLInputElement | null>(null)
const pendingPhotoProductId = ref<string | null>(null)

// Edit modal
const showEditor = ref(false)
const editingProduct = ref<Partial<Mercuriale> | null>(null)
const saving = ref(false)

// Bulk selection mode
const selectionMode = ref(false)
const selectedIds = ref<Set<string>>(new Set())
const bulkActioning = ref(false)

function toggleSelectionMode() {
  selectionMode.value = !selectionMode.value
  if (!selectionMode.value) selectedIds.value = new Set()
}

function toggleSelected(id: string) {
  const s = new Set(selectedIds.value)
  if (s.has(id)) { s.delete(id) } else { s.add(id) }
  selectedIds.value = s
}

function selectAll() {
  selectedIds.value = new Set(displayedProducts.value.map(p => p.id))
}

function deselectAll() {
  selectedIds.value = new Set()
}

async function bulkDeactivate() {
  const count = selectedIds.value.size
  if (count === 0) return
  if (!confirm(`Désactiver ${count} produit${count > 1 ? 's' : ''} ?`)) return
  bulkActioning.value = true
  try {
    await mercurialeStore.bulkSetActif([...selectedIds.value], false)
    selectedIds.value = new Set()
    selectionMode.value = false
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur de désactivation')
  } finally {
    bulkActioning.value = false
  }
}

async function bulkActivate() {
  const count = selectedIds.value.size
  if (count === 0) return
  bulkActioning.value = true
  try {
    await mercurialeStore.bulkSetActif([...selectedIds.value], true)
    selectedIds.value = new Set()
    selectionMode.value = false
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur de réactivation')
  } finally {
    bulkActioning.value = false
  }
}

// Photo search
const photoSearchResults = ref<{ url: string; thumbnail: string; title: string }[]>([])
const photoSearching = ref(false)
const photoSearchQuery = ref('')
const showPhotoSearch = ref(false)
const photoUploading = ref(false)

// Initialize from route param
watch(() => route.params.fournisseurId, (id) => {
  if (id) filterFournisseurId.value = id as string
}, { immediate: true })

const UNITES = ['kg', 'g', 'L', 'cl', 'mL', 'unite', 'piece', 'botte', 'carton', 'barquette']
const TVA_OPTIONS = [5.5, 10, 20]

// Filtered products
const displayedProducts = computed(() => {
  let result = filterActif.value ? mercurialeStore.actifs : mercurialeStore.items
  if (filterFournisseurId.value) {
    result = result.filter(m => m.fournisseur_id === filterFournisseurId.value)
  }
  if (filterCategorie.value) {
    result = result.filter(m => m.categorie === filterCategorie.value)
  }
  if (search.value) {
    const q = search.value.toLowerCase()
    result = result.filter(m =>
      m.designation.toLowerCase().includes(q) ||
      m.ref_fournisseur?.toLowerCase().includes(q) ||
      m.categorie?.toLowerCase().includes(q)
    )
  }
  return result.sort((a, b) => a.designation.localeCompare(b.designation, 'fr'))
})

function getFournisseurNom(fournisseurId: string): string {
  return fournisseursStore.getById(fournisseurId)?.nom || 'Inconnu'
}

function getIngredientNom(ingredientId: string | null): string | null {
  if (!ingredientId) return null
  return ingredientsStore.getById(ingredientId)?.nom ?? null
}

function formatConditionnement(cond: Conditionnement) {
  return `${cond.nom} (${cond.quantite} ${cond.unite})`
}

function formatPrix(prix: number, unite: string, conditionnements?: Conditionnement[]) {
  // prix_unitaire_ht = prix par conditionnement de commande
  // Afficher le type de conditionnement (colis, carton, sachet...) au lieu de l'unité de stock
  const cmd = conditionnements?.find(c => c.utilise_commande)
  if (cmd && cmd.quantite > 1 && cmd.nom) {
    // Extraire le type: "Colis de 500pcs" → "colis", "carton de 5kg" → "carton"
    const label = (cmd.nom.split(/[\s_]/)[0] ?? '').toLowerCase()
    return `${prix.toFixed(2)} €/${label}`
  }
  return `${prix.toFixed(2)} €/${unite}`
}

// Photo upload
function triggerPhotoUpload(productId: string) {
  pendingPhotoProductId.value = productId
  photoInputRef.value?.click()
}

async function handlePhotoSelected(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file || !pendingPhotoProductId.value) return

  const productId = pendingPhotoProductId.value
  uploadingPhotoId.value = productId
  try {
    await mercurialeStore.uploadPhoto(productId, file)
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur upload photo')
  } finally {
    uploadingPhotoId.value = null
    pendingPhotoProductId.value = null
    input.value = ''
  }
}

// Edit modal
function openEditor(product: Mercuriale) {
  editingProduct.value = {
    ...product,
    conditionnements: product.conditionnements
      ? JSON.parse(JSON.stringify(product.conditionnements))
      : [],
  }
  isCreating.value = false
  showEditor.value = true
}

const isCreating = ref(false)

function openCreator() {
  editingProduct.value = {
    designation: '',
    fournisseur_id: filterFournisseurId.value || (fournisseursStore.actifs[0]?.id ?? ''),
    categorie: '',
    ref_fournisseur: '',
    prix_unitaire_ht: 0,
    tva: 5.5,
    unite_commande: 'kg',
    unite_stock: 'kg',
    coefficient_conversion: 1,
    conditionnements: [],
    actif: true,
    photo_url: null,
    notes: '',
    notes_internes: '',
    dlc_ddm_jours: null,
    pertes_pct: null,
  }
  isCreating.value = true
  showEditor.value = true
}

function closeEditor() {
  showEditor.value = false
  showPhotoSearch.value = false
  photoSearchQuery.value = ''
  photoSearchResults.value = []
  editingProduct.value = null
}

async function handleSave() {
  if (!editingProduct.value?.designation?.trim()) return
  // For creation, fournisseur is required
  if (isCreating.value && !editingProduct.value.fournisseur_id) {
    alert('Veuillez sélectionner un fournisseur')
    return
  }
  saving.value = true
  try {
    await mercurialeStore.save(editingProduct.value as Partial<Mercuriale> & { id?: string })
    closeEditor()
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur de sauvegarde')
  } finally {
    saving.value = false
  }
}

async function handleDeleteProduct() {
  if (!editingProduct.value?.id) return
  const nom = editingProduct.value.designation || 'ce produit'
  if (!confirm(`Supprimer \u00AB ${nom} \u00BB ?\nCette action est irr\u00E9versible.`)) return
  try {
    await mercurialeStore.deleteItem(editingProduct.value.id)
    closeEditor()
  } catch (e: unknown) {
    // PostgrestError is a POJO (not instanceof Error) — access .message and .code directly
    const err = e as Record<string, unknown>
    const msg = (err?.message as string) || String(e)
    const code = (err?.code as string) || ''
    if (msg.includes('violates foreign key') || msg.includes('foreign_key') || code === '23503' || msg.includes('23503')) {
      const wantDeactivate = confirm(
        `Impossible de supprimer \u00AB ${nom} \u00BB car il est li\u00E9 \u00E0 des ingr\u00E9dients ou commandes.\n\nVoulez-vous le d\u00E9sactiver \u00E0 la place ?`
      )
      if (wantDeactivate) {
        try {
          await mercurialeStore.save({ id: editingProduct.value.id, actif: false } as Partial<Mercuriale> & { id: string })
          closeEditor()
        } catch (e2: unknown) {
          const err2 = e2 as Record<string, unknown>
          alert((err2?.message as string) || 'Erreur de d\u00E9sactivation')
        }
      }
    } else {
      alert(msg || 'Erreur de suppression')
    }
  }
}

// Conditionnement helpers
function addConditionnement() {
  if (!editingProduct.value) return
  if (!editingProduct.value.conditionnements) {
    editingProduct.value.conditionnements = []
  }
  const conds = editingProduct.value.conditionnements as Conditionnement[]
  conds.push({
    nom: '',
    quantite: 1,
    unite: editingProduct.value.unite_stock || 'kg',
    utilise_commande: conds.length === 0,
  })
}

function removeConditionnement(index: number) {
  const conds = editingProduct.value?.conditionnements as Conditionnement[] | undefined
  conds?.splice(index, 1)
}

function setConditionnementCommande(index: number) {
  const conds = editingProduct.value?.conditionnements as Conditionnement[] | undefined
  if (!conds) return
  for (let i = 0; i < conds.length; i++) {
    conds[i]!.utilise_commande = (i === index)
  }
}

function setConditionnementFacturation(index: number) {
  const conds = editingProduct.value?.conditionnements as Conditionnement[] | undefined
  if (!conds) return
  for (let i = 0; i < conds.length; i++) {
    conds[i]!.utilise_facturation = (i === index)
  }
}

// Photo search functions
function openPhotoSearch() {
  photoSearchQuery.value = editingProduct.value?.designation || ''
  photoSearchResults.value = []
  showPhotoSearch.value = true
}

async function doPhotoSearch() {
  if (!photoSearchQuery.value.trim()) return
  photoSearching.value = true
  photoSearchResults.value = []
  try {
    photoSearchResults.value = await mercurialeStore.searchPhotos(photoSearchQuery.value)
  } catch (e: unknown) {
    const err = e as Record<string, unknown>
    alert((err?.message as string) || 'Erreur recherche photo')
  } finally {
    photoSearching.value = false
  }
}

async function selectPhoto(imageUrl: string, thumbnailUrl?: string) {
  if (!editingProduct.value?.id) return
  photoUploading.value = true
  try {
    const newUrl = await mercurialeStore.uploadPhotoFromUrl(editingProduct.value.id, imageUrl, thumbnailUrl)
    editingProduct.value.photo_url = newUrl
    showPhotoSearch.value = false
    photoSearchResults.value = []
  } catch (e: unknown) {
    const err = e as Record<string, unknown>
    alert((err?.message as string) || 'Erreur upload photo')
  } finally {
    photoUploading.value = false
  }
}

onMounted(async () => {
  await Promise.all([
    fournisseursStore.fetchAll(),
    mercurialeStore.fetchAll(),
    ingredientsStore.ingredients.length === 0 ? ingredientsStore.fetchAll() : Promise.resolve(),
  ])
})
</script>

<template>
  <div class="mercuriale-page">
    <h1>Mercuriale</h1>

    <!-- Contextual help banner -->
    <button class="help-toggle" @click="showHelp = !showHelp">
      <span class="help-icon">?</span>
      <span>{{ showHelp ? 'Masquer l\'aide' : 'Comment ça marche ?' }}</span>
    </button>
    <div v-if="showHelp" class="help-banner">
      <div class="help-title">Mercuriale = catalogue produits fournisseur</div>
      <div class="help-desc">
        Les produits que vous commandez chez vos fournisseurs (référence, prix, conditionnement).
        Chaque produit doit être relié à un ingrédient restaurant pour le suivi de stock et le calcul de coût.
        Un ingrédient peut avoir plusieurs fournisseurs, un seul est le « préféré » (utilisé pour le coût).
      </div>
      <div class="help-schema"><strong>PRODUIT FOURNISSEUR</strong> &rarr; Ingrédient &rarr; Recette vendue (Zelty)</div>
    </div>

    <!-- Hidden file input for photo upload -->
    <input
      ref="photoInputRef"
      type="file"
      accept="image/*"
      capture="environment"
      class="visually-hidden"
      @change="handlePhotoSelected"
    />

    <!-- Filters bar -->
    <div class="filters-bar">
      <input
        v-model="search"
        type="search"
        placeholder="Rechercher un produit..."
        class="search-input"
      />
      <select v-model="filterFournisseurId" class="filter-select">
        <option :value="null">Tous les fournisseurs</option>
        <option v-for="f in fournisseursStore.actifs" :key="f.id" :value="f.id">
          {{ f.nom }}
        </option>
      </select>
      <select v-model="filterCategorie" class="filter-select">
        <option :value="null">Toutes cat&eacute;gories</option>
        <option v-for="cat in mercurialeStore.allCategories" :key="cat" :value="cat">
          {{ cat }}
        </option>
      </select>
      <label class="filter-toggle">
        <input type="checkbox" v-model="filterActif" />
        Actifs
      </label>
      <span class="result-count">{{ displayedProducts.length }} produits</span>
      <button
        class="btn-select-mode"
        :class="{ active: selectionMode }"
        @click="toggleSelectionMode"
      >
        {{ selectionMode ? 'Annuler' : 'S\u00e9lectionner' }}
      </button>
      <button class="btn-add-product" @click="openCreator" title="Ajouter un produit fournisseur">+</button>
    </div>

    <div v-if="mercurialeStore.loading" class="loading">Chargement...</div>

    <div v-else-if="displayedProducts.length === 0" class="empty">
      Aucun produit trouv&eacute;
    </div>

    <!-- Product list -->
    <div v-else class="product-list">
      <!-- Select all / deselect all bar -->
      <div v-if="selectionMode" class="select-all-bar">
        <button class="btn-select-all" @click="selectAll">Tout s&eacute;lectionner ({{ displayedProducts.length }})</button>
        <button v-if="selectedIds.size > 0" class="btn-deselect-all" @click="deselectAll">Tout d&eacute;s&eacute;lectionner</button>
        <span v-if="selectedIds.size > 0" class="selection-count">{{ selectedIds.size }} s&eacute;lectionn&eacute;(s)</span>
      </div>

      <div
        v-for="p in displayedProducts"
        :key="p.id"
        class="product-card"
        :class="{ selected: selectionMode && selectedIds.has(p.id) }"
        @click="selectionMode ? toggleSelected(p.id) : openEditor(p)"
      >
        <div class="product-row">
          <!-- Checkbox in selection mode -->
          <label v-if="selectionMode" class="bulk-checkbox" @click.stop>
            <input
              type="checkbox"
              :checked="selectedIds.has(p.id)"
              @change="toggleSelected(p.id)"
            />
          </label>

          <!-- Photo thumbnail -->
          <button
            class="product-photo"
            :class="{ uploading: uploadingPhotoId === p.id }"
            @click.stop="selectionMode ? toggleSelected(p.id) : triggerPhotoUpload(p.id)"
          >
            <img v-if="p.photo_url" :src="p.photo_url" :alt="p.designation" />
            <span v-else-if="uploadingPhotoId === p.id" class="photo-spinner">...</span>
            <svg v-else width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
          </button>

          <!-- Product info -->
          <div class="product-info">
            <div class="product-header">
              <span class="product-name">{{ p.designation }}</span>
              <span v-if="!p.actif" class="badge-inactive">Inactif</span>
            </div>
            <div class="product-meta">
              <span class="product-supplier">{{ getFournisseurNom(p.fournisseur_id) }}</span>
              <span v-if="p.categorie" class="product-category">{{ p.categorie }}</span>
              <span v-if="p.ref_fournisseur" class="product-sku">{{ p.ref_fournisseur }}</span>
              <span v-if="getIngredientNom(p.ingredient_restaurant_id)" class="badge-linked" :title="'Relié à : ' + getIngredientNom(p.ingredient_restaurant_id)">
                {{ getIngredientNom(p.ingredient_restaurant_id) }}
              </span>
              <span v-else class="badge-unlinked">Non relié</span>
            </div>
            <div class="product-details">
              <span class="product-price">{{ formatPrix(p.prix_unitaire_ht, p.unite_stock, p.conditionnements as Conditionnement[]) }}</span>
              <span v-if="p.tva" class="product-tva">TVA {{ p.tva }}%</span>
            </div>
            <div v-if="p.conditionnements && (p.conditionnements as Conditionnement[]).length > 0" class="product-cond">
              <span
                v-for="(c, i) in (p.conditionnements as Conditionnement[])"
                :key="i"
                class="cond-badge"
                :class="{ primary: c.utilise_commande }"
              >
                {{ formatConditionnement(c) }}
              </span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Bulk action bar -->
    <Teleport to="body">
      <Transition name="slide-up">
        <div v-if="selectionMode && selectedIds.size > 0" class="bulk-action-bar">
          <span class="bulk-count">{{ selectedIds.size }} produit{{ selectedIds.size > 1 ? 's' : '' }}</span>
          <button
            v-if="filterActif"
            class="btn-bulk btn-bulk-deactivate"
            :disabled="bulkActioning"
            @click="bulkDeactivate"
          >
            {{ bulkActioning ? 'En cours...' : 'D\u00e9sactiver' }}
          </button>
          <button
            v-else
            class="btn-bulk btn-bulk-activate"
            :disabled="bulkActioning"
            @click="bulkActivate"
          >
            {{ bulkActioning ? 'En cours...' : 'R\u00e9activer' }}
          </button>
        </div>
      </Transition>
    </Teleport>

    <!-- Edit modal -->
    <div v-if="showEditor && editingProduct" class="modal-overlay" @click.self="closeEditor">
      <div class="modal">
        <div class="modal-header">
          <h2>{{ isCreating ? 'Ajouter un produit' : 'Modifier produit' }}</h2>
          <button class="btn-close" @click="closeEditor">&times;</button>
        </div>

        <form @submit.prevent="handleSave" class="modal-body">
          <div class="form-grid">
            <!-- Fournisseur (creation only) -->
            <div v-if="isCreating" class="field full">
              <label>Fournisseur *</label>
              <select v-model="editingProduct.fournisseur_id" required>
                <option value="" disabled>Choisir un fournisseur</option>
                <option v-for="f in fournisseursStore.actifs" :key="f.id" :value="f.id">
                  {{ f.nom }}
                </option>
              </select>
            </div>

            <!-- Identification -->
            <div class="field full">
              <label>D&eacute;signation *</label>
              <input v-model="editingProduct.designation" required />
            </div>
            <div class="field">
              <label>R&eacute;f&eacute;rence fournisseur</label>
              <input v-model="editingProduct.ref_fournisseur" />
            </div>
            <div class="field">
              <label>Cat&eacute;gorie</label>
              <input v-model="editingProduct.categorie" list="cat-list" />
              <datalist id="cat-list">
                <option v-for="c in mercurialeStore.allCategories" :key="c" :value="c" />
              </datalist>
            </div>

            <!-- Ingrédient relié -->
            <div class="field full">
              <label>Ingr&eacute;dient reli&eacute;</label>
              <select v-model="editingProduct.ingredient_restaurant_id">
                <option :value="null">&mdash; Non reli&eacute; &mdash;</option>
                <option
                  v-for="ing in ingredientsStore.actifs"
                  :key="ing.id"
                  :value="ing.id"
                >
                  {{ ing.nom }} ({{ ing.unite_stock }}){{ ing.categorie ? ` — ${ing.categorie}` : '' }}
                </option>
              </select>
            </div>

            <!-- Prix -->
            <div class="field">
              <label>Prix unitaire HT (&euro;)</label>
              <input v-model.number="editingProduct.prix_unitaire_ht" type="number" step="any" min="0" />
            </div>
            <div class="field">
              <label>TVA (%)</label>
              <select v-model.number="editingProduct.tva">
                <option v-for="t in TVA_OPTIONS" :key="t" :value="t">{{ t }}%</option>
              </select>
            </div>

            <!-- Unit&eacute;s -->
            <div class="field">
              <label>Unit&eacute; de commande</label>
              <select v-model="editingProduct.unite_commande">
                <option v-for="u in UNITES" :key="u" :value="u">{{ u }}</option>
              </select>
            </div>
            <div class="field">
              <label>Unit&eacute; de stock</label>
              <select v-model="editingProduct.unite_stock">
                <option v-for="u in UNITES" :key="u" :value="u">{{ u }}</option>
              </select>
            </div>
            <div class="field">
              <label>Coefficient conversion</label>
              <input v-model.number="editingProduct.coefficient_conversion" type="number" step="0.001" min="0" />
            </div>

            <!-- Conditionnements -->
            <div class="field full">
              <label>Conditionnements</label>
              <div
                v-for="(c, i) in (editingProduct.conditionnements as Conditionnement[])"
                :key="i"
                class="cond-edit-row"
              >
                <input v-model="c.nom" placeholder="Nom (ex: Carton)" class="cond-input-nom" />
                <input v-model.number="c.quantite" type="number" step="0.01" min="0" class="cond-input-qty" placeholder="Qt&eacute;" />
                <input v-model="c.unite" placeholder="Unit&eacute;" class="cond-input-unite" />
                <label class="cond-radio">
                  <input type="radio" name="cond-cmd" :checked="c.utilise_commande" @change="setConditionnementCommande(i)" />
                  Cmd
                </label>
                <label class="cond-radio">
                  <input type="radio" name="cond-fact" :checked="c.utilise_facturation" @change="setConditionnementFacturation(i)" />
                  Fact
                </label>
                <button type="button" class="btn-remove-cond" @click="removeConditionnement(i)">&times;</button>
              </div>
              <button type="button" class="btn-add-cond" @click="addConditionnement">
                + Ajouter un conditionnement
              </button>
            </div>

            <!-- DLC / Pertes -->
            <div class="field">
              <label>DLC/DDM (jours)</label>
              <input v-model.number="editingProduct.dlc_ddm_jours" type="number" min="0" />
            </div>
            <div class="field">
              <label>Pertes (%)</label>
              <input v-model.number="editingProduct.pertes_pct" type="number" step="0.1" min="0" max="100" />
            </div>

            <!-- Photo -->
            <div class="field full">
              <label>Photo</label>
              <div class="photo-section">
                <div v-if="editingProduct.photo_url" class="photo-preview">
                  <img :src="editingProduct.photo_url" alt="Photo produit" />
                </div>
                <div class="photo-actions">
                  <button type="button" class="btn-photo-search" @click="openPhotoSearch">
                    Chercher une photo
                  </button>
                </div>
              </div>

              <!-- Photo search panel -->
              <div v-if="showPhotoSearch" class="photo-search-panel">
                <div class="photo-search-bar">
                  <input
                    v-model="photoSearchQuery"
                    type="text"
                    placeholder="Nom du produit..."
                    class="photo-search-input"
                    @keyup.enter="doPhotoSearch"
                  />
                  <button
                    type="button"
                    class="btn-primary btn-sm"
                    :disabled="photoSearching || !photoSearchQuery.trim()"
                    @click="doPhotoSearch"
                  >
                    {{ photoSearching ? 'Recherche...' : 'Rechercher' }}
                  </button>
                  <button type="button" class="btn-close-sm" @click="showPhotoSearch = false">&times;</button>
                </div>

                <div v-if="photoSearching" class="photo-search-loading">Recherche en cours...</div>

                <div v-else-if="photoSearchResults.length > 0" class="photo-results-grid">
                  <button
                    v-for="(img, i) in photoSearchResults"
                    :key="i"
                    type="button"
                    class="photo-result"
                    :disabled="photoUploading"
                    @click="selectPhoto(img.url, img.thumbnail)"
                  >
                    <img :src="img.thumbnail" :alt="img.title" loading="lazy" />
                  </button>
                </div>

                <div v-if="photoUploading" class="photo-uploading-overlay">
                  T&eacute;l&eacute;chargement en cours...
                </div>
              </div>
            </div>

            <!-- Notes -->
            <div class="field full">
              <label>Notes</label>
              <textarea v-model="editingProduct.notes" rows="2" />
            </div>
            <div class="field full">
              <label>Notes internes</label>
              <textarea v-model="editingProduct.notes_internes" rows="2" />
            </div>

            <!-- Actif -->
            <div class="field">
              <label class="checkbox-label">
                <input type="checkbox" v-model="editingProduct.actif" />
                Actif
              </label>
            </div>
          </div>

          <div class="modal-actions">
            <button
              v-if="!isCreating && editingProduct.id"
              type="button"
              class="btn-danger"
              @click="handleDeleteProduct"
            >
              Supprimer
            </button>
            <div class="spacer" />
            <button type="button" class="btn-secondary" @click="closeEditor">Annuler</button>
            <button type="submit" class="btn-primary" :disabled="saving || !editingProduct.designation?.trim()">
              {{ saving ? 'Sauvegarde...' : (isCreating ? 'Cr\u00e9er' : 'Enregistrer') }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
h1 {
  font-size: 28px;
  margin-bottom: 16px;
}

/* Help banner */
.help-toggle {
  display: flex;
  align-items: center;
  gap: 8px;
  background: none;
  border: none;
  font-size: 14px;
  font-weight: 600;
  color: var(--color-info, #3b82f6);
  cursor: pointer;
  padding: 0 0 10px;
}
.help-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  border-radius: 50%;
  background: var(--color-info, #3b82f6);
  color: white;
  font-size: 13px;
  font-weight: 700;
}
.help-banner {
  background: color-mix(in srgb, var(--color-info, #3b82f6) 6%, var(--bg-surface));
  border: 1px solid color-mix(in srgb, var(--color-info, #3b82f6) 25%, var(--border));
  border-radius: var(--radius-md);
  padding: 14px 16px;
  margin-bottom: 16px;
  font-size: 14px;
  line-height: 1.5;
}
.help-title {
  font-weight: 700;
  font-size: 15px;
  margin-bottom: 6px;
  color: var(--text-primary);
}
.help-desc {
  color: var(--text-secondary);
  margin-bottom: 6px;
}
.help-schema {
  font-size: 13px;
  font-weight: 600;
  color: var(--color-info, #3b82f6);
  padding-top: 6px;
  border-top: 1px solid color-mix(in srgb, var(--color-info, #3b82f6) 15%, var(--border));
}

.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
}

/* Filters */
.filters-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
  margin-bottom: 20px;
}
.search-input {
  flex: 1;
  min-width: 200px;
  max-width: 400px;
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-surface);
}
.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}
.filter-select {
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 16px;
  background: var(--bg-surface);
  min-width: 160px;
}
.filter-select:focus {
  outline: none;
  border-color: var(--color-primary);
}
.filter-toggle {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}
.filter-toggle input {
  width: 20px;
  height: 20px;
  cursor: pointer;
}
.result-count {
  color: var(--text-tertiary);
  font-size: 15px;
  white-space: nowrap;
}

/* Selection mode button */
.btn-select-mode {
  height: 44px;
  padding: 0 16px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-surface);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-secondary);
  white-space: nowrap;
}
.btn-select-mode.active {
  border-color: var(--color-primary);
  color: var(--color-primary);
  background: rgba(234, 88, 12, 0.06);
}

.btn-add-product {
  width: 52px;
  height: 52px;
  min-width: 52px;
  border: none;
  border-radius: 50%;
  background: var(--color-primary);
  color: white;
  font-size: 28px;
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 2px 8px rgba(232, 93, 44, 0.3);
}
.btn-add-product:active {
  background: #d4521f;
}

/* Select all bar */
.select-all-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 0;
  margin-bottom: 4px;
}
.btn-select-all, .btn-deselect-all {
  height: 40px;
  padding: 0 14px;
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  background: var(--bg-surface);
  font-size: 14px;
  cursor: pointer;
  color: var(--text-secondary);
}
.btn-select-all:active, .btn-deselect-all:active {
  background: var(--bg-page);
}
.selection-count {
  font-size: 14px;
  font-weight: 600;
  color: var(--color-primary);
}

/* Bulk checkbox on product card */
.bulk-checkbox {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  padding: 4px;
}
.bulk-checkbox input[type="checkbox"] {
  width: 24px;
  height: 24px;
  cursor: pointer;
  accent-color: var(--color-primary);
}
.product-card.selected {
  box-shadow: 0 0 0 2px var(--color-primary);
  background: rgba(234, 88, 12, 0.03);
}

/* Bulk action bar (fixed bottom) */
.bulk-action-bar {
  position: fixed;
  bottom: 80px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 14px 24px;
  background: var(--bg-surface);
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.18);
  z-index: 100;
}
.bulk-count {
  font-size: 16px;
  font-weight: 700;
  color: var(--text-primary);
  white-space: nowrap;
}
.btn-bulk {
  height: 48px;
  padding: 0 24px;
  border: none;
  border-radius: var(--radius-md);
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
  white-space: nowrap;
}
.btn-bulk-deactivate {
  background: #dc2626;
  color: #fff;
}
.btn-bulk-deactivate:active {
  background: #b91c1c;
}
.btn-bulk-activate {
  background: #16a34a;
  color: #fff;
}
.btn-bulk-activate:active {
  background: #15803d;
}
.btn-bulk:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* Slide-up transition */
.slide-up-enter-active, .slide-up-leave-active {
  transition: all 0.25s ease;
}
.slide-up-enter-from, .slide-up-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(30px);
}

.loading, .empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 60px 20px;
}

/* Product list */
.product-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.product-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
  cursor: pointer;
  transition: box-shadow 0.15s;
}
.product-card:active {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.product-row {
  display: flex;
  gap: 14px;
  align-items: flex-start;
}

/* Photo */
.product-photo {
  width: 64px;
  height: 64px;
  min-width: 64px;
  border-radius: var(--radius-sm);
  border: 2px dashed var(--border);
  background: var(--bg-main);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  overflow: hidden;
  color: var(--text-tertiary);
  padding: 0;
  transition: border-color 0.15s;
}
.product-photo:active { border-color: var(--color-primary); }
.product-photo img { width: 100%; height: 100%; object-fit: cover; border-radius: 6px; }
.product-photo.uploading { opacity: 0.5; pointer-events: none; }
.photo-spinner { font-size: 14px; color: var(--text-tertiary); animation: pulse 1s infinite; }
@keyframes pulse { 0%, 100% { opacity: 0.4; } 50% { opacity: 1; } }

/* Product info */
.product-info { flex: 1; min-width: 0; }
.product-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 4px; }
.product-name { font-size: 16px; font-weight: 600; }
.badge-inactive {
  font-size: 11px;
  font-weight: 700;
  padding: 2px 8px;
  border-radius: 10px;
  background: #fee2e2;
  color: #dc2626;
  text-transform: uppercase;
}
.product-meta {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 4px;
  flex-wrap: wrap;
}
.product-supplier {
  font-size: 13px;
  color: var(--color-primary);
  font-weight: 600;
}
.product-category {
  font-size: 13px;
  color: var(--text-tertiary);
}
.product-sku {
  font-size: 12px;
  color: var(--text-tertiary);
  font-family: monospace;
  background: var(--bg-main);
  padding: 1px 6px;
  border-radius: 4px;
}
.badge-linked {
  font-size: 11px;
  font-weight: 600;
  color: #166534;
  background: #dcfce7;
  padding: 2px 8px;
  border-radius: 10px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 140px;
}
.badge-unlinked {
  font-size: 11px;
  font-weight: 600;
  color: #9a3412;
  background: #ffedd5;
  padding: 2px 8px;
  border-radius: 10px;
}
.product-details { display: flex; gap: 12px; margin-bottom: 6px; }
.product-price { font-size: 18px; font-weight: 700; color: var(--color-primary); }
.product-tva { font-size: 13px; color: var(--text-tertiary); align-self: center; }
.product-cond { display: flex; gap: 6px; flex-wrap: wrap; }
.cond-badge { font-size: 12px; padding: 4px 8px; border-radius: 6px; background: var(--bg-main); color: var(--text-secondary); }
.cond-badge.primary { background: var(--color-primary); color: white; font-weight: 600; }

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  padding: 20px;
}
.modal {
  background: var(--bg-surface);
  border-radius: var(--radius-lg, 16px);
  width: 100%;
  max-width: 640px;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
}
.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid var(--border);
}
.modal-header h2 { font-size: 20px; margin: 0; }
.btn-close {
  width: 40px;
  height: 40px;
  border: none;
  background: none;
  font-size: 24px;
  cursor: pointer;
  color: var(--text-tertiary);
  border-radius: 50%;
}
.btn-close:hover { background: var(--bg-main); }
.modal-body { padding: 24px; }

/* Form grid */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 24px;
}
.field { display: flex; flex-direction: column; gap: 6px; }
.field.full { grid-column: 1 / -1; }
.field label {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
}
.field input, .field select, .field textarea {
  height: 48px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 14px;
  font-size: 16px;
  color: var(--text-primary);
  background: var(--bg-surface);
  caret-color: var(--text-primary);
}
.field input:focus, .field select:focus, .field textarea:focus {
  outline: none;
  border-color: var(--color-primary);
}
.field textarea {
  height: auto;
  padding: 12px 14px;
  resize: vertical;
}
.checkbox-label {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  font-size: 16px;
}
.checkbox-label input { width: 20px; height: 20px; cursor: pointer; }

/* Conditionnement editing */
.cond-edit-row {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 8px;
}
.cond-input-nom { flex: 2; }
.cond-input-qty { flex: 1; max-width: 80px; }
.cond-input-unite { flex: 1; max-width: 80px; }
.cond-edit-row input {
  height: 44px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 10px;
  font-size: 15px;
}
.cond-edit-row input:focus {
  outline: none;
  border-color: var(--color-primary);
}
.cond-radio {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 13px;
  font-weight: 600;
  white-space: nowrap;
  color: var(--text-secondary);
}
.cond-radio input { width: 18px; height: 18px; cursor: pointer; }
.btn-remove-cond {
  width: 36px;
  height: 36px;
  min-width: 36px;
  border: none;
  background: #fef2f2;
  color: #ef4444;
  border-radius: 50%;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}
.btn-add-cond {
  background: transparent;
  border: 2px dashed var(--border);
  border-radius: var(--radius-md);
  padding: 12px;
  width: 100%;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-tertiary);
  cursor: pointer;
  margin-top: 4px;
}
.btn-add-cond:active { border-color: var(--color-primary); color: var(--color-primary); }

/* Modal actions */
.modal-actions {
  display: flex;
  gap: 12px;
  align-items: center;
  padding-top: 20px;
  border-top: 1px solid var(--border);
}
.spacer { flex: 1; }
.btn-primary {
  height: 52px;
  padding: 0 28px;
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-secondary {
  height: 52px;
  padding: 0 24px;
  background: var(--bg-surface);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}
.btn-danger {
  height: 52px;
  padding: 0 20px;
  background: none;
  border: 2px solid #ef4444;
  border-radius: var(--radius-md);
  color: #ef4444;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

/* Photo search */
.photo-section {
  display: flex;
  gap: 16px;
  align-items: flex-start;
}

.photo-preview {
  width: 80px;
  height: 80px;
  border-radius: var(--radius-md);
  overflow: hidden;
  border: 2px solid var(--border);
  flex-shrink: 0;
}

.photo-preview img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.photo-actions {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.btn-photo-search {
  height: 44px;
  padding: 0 16px;
  background: var(--bg-main);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  color: var(--text-primary);
  white-space: nowrap;
}

.btn-photo-search:active {
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.photo-search-panel {
  margin-top: 12px;
  background: var(--bg-main);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 12px;
  position: relative;
}

.photo-search-bar {
  display: flex;
  gap: 8px;
  align-items: center;
  margin-bottom: 12px;
}

.photo-search-input {
  flex: 1;
  height: 44px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  padding: 0 12px;
  font-size: 15px;
  background: var(--bg-surface);
}

.photo-search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.btn-sm {
  height: 44px !important;
  padding: 0 16px !important;
  font-size: 14px !important;
}

.btn-close-sm {
  width: 36px;
  height: 36px;
  border: none;
  background: none;
  font-size: 22px;
  cursor: pointer;
  color: var(--text-tertiary);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.photo-search-loading {
  text-align: center;
  padding: 20px;
  color: var(--text-tertiary);
  font-size: 14px;
}

.photo-results-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 8px;
}

.photo-result {
  aspect-ratio: 1;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  overflow: hidden;
  cursor: pointer;
  padding: 0;
  background: white;
  transition: border-color 0.15s;
}

.photo-result:active,
.photo-result:hover {
  border-color: var(--color-primary);
}

.photo-result:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.photo-result img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.photo-uploading-overlay {
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.85);
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: var(--radius-md);
  font-weight: 600;
  color: var(--color-primary);
  font-size: 15px;
}
</style>
