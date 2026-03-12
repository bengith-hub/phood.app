<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useIngredientsStore } from '@/stores/ingredients'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useFournisseursStore } from '@/stores/fournisseurs'
import type { IngredientRestaurant, Allergene } from '@/types/database'
import { calculateCoutUnitaire } from '@/lib/unit-conversion'

const route = useRoute()
const router = useRouter()
const store = useIngredientsStore()
const mercurialeStore = useMercurialeStore()
const fournisseursStore = useFournisseursStore()

const saving = ref(false)
const uploadingPhoto = ref(false)
const photoInputRef = ref<HTMLInputElement | null>(null)
const mercurialePhotoUrl = ref<string | null>(null)
const mercurialeSku = ref<string | null>(null)
const mercurialeDesignation = ref<string | null>(null)

/** Mercuriale products linked to this ingredient (for preferred supplier selector) */
const linkedMercuriale = computed(() => {
  if (isNew.value) return []
  return mercurialeStore.getByIngredientId(ingredientId.value)
})

function getFournisseurNom(fournisseurId: string) {
  return fournisseursStore.getById(fournisseurId)?.nom ?? 'Inconnu'
}

async function changePreferredSupplier(mercurialeId: string | null) {
  if (isNew.value) return
  form.value.fournisseur_prefere_id = mercurialeId
  try {
    const merc = mercurialeId ? mercurialeStore.getById(mercurialeId) : null
    // Recalculate cout_unitaire from the new preferred supplier
    const newCout = merc ? calculateCoutUnitaire(merc, form.value.unite_stock || 'kg') : 0
    form.value.cout_unitaire = newCout
    await store.save({
      id: ingredientId.value,
      fournisseur_prefere_id: mercurialeId,
      cout_unitaire: newCout,
      cout_source: 'mercuriale',
      cout_maj_date: new Date().toISOString(),
    } as Partial<IngredientRestaurant> & { id: string })
    // Update local enriched data
    mercurialeDesignation.value = merc?.designation ?? null
    mercurialeSku.value = merc?.ref_fournisseur ?? null
    mercurialePhotoUrl.value = merc?.photo_url ?? null
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur changement fournisseur')
  }
}

const ingredientId = computed(() => route.params.id as string)
const isNew = computed(() => !ingredientId.value || ingredientId.value === 'new')
const displayPhotoUrl = computed(() => form.value.photo_url || mercurialePhotoUrl.value)

// Form data
const form = ref<Partial<IngredientRestaurant>>({
  nom: '',
  unite_stock: 'kg',
  categorie: null,
  allergenes: [],
  contient: null,
  rendement: 1,
  stock_tampon: 0,
  photo_url: null,
  actif: true,
})

const UNITES = ['g', 'kg', 'mL', 'cl', 'L', 'unite', 'piece', 'botte']

const ALL_ALLERGENES: { key: Allergene; label: string }[] = [
  { key: 'gluten', label: 'Gluten' },
  { key: 'crustaces', label: 'Crustacés' },
  { key: 'oeufs', label: 'Oeufs' },
  { key: 'poissons', label: 'Poissons' },
  { key: 'arachides', label: 'Arachides' },
  { key: 'soja', label: 'Soja' },
  { key: 'lait', label: 'Lait' },
  { key: 'fruits_a_coque', label: 'Fruits à coque' },
  { key: 'celeri', label: 'Céleri' },
  { key: 'moutarde', label: 'Moutarde' },
  { key: 'sesame', label: 'Sésame' },
  { key: 'sulfites', label: 'Sulfites' },
  { key: 'lupin', label: 'Lupin' },
  { key: 'mollusques', label: 'Mollusques' },
]

/** Format cost with enough precision (up to 4 decimals for g/mL) */
function formatCout(val: number): string {
  if (val >= 0.01) return val.toFixed(2)
  if (val >= 0.001) return val.toFixed(3)
  return val.toFixed(4)
}

function toggleAllergene(key: Allergene) {
  const list = form.value.allergenes as Allergene[]
  const idx = list.indexOf(key)
  if (idx >= 0) list.splice(idx, 1)
  else list.push(key)
}

function hasAllergene(key: Allergene) {
  return (form.value.allergenes as Allergene[]).includes(key)
}

async function handleSave() {
  if (!form.value.nom?.trim()) return
  saving.value = true
  try {
    // Strip enriched fields that don't belong to the DB table
    const { mercuriale_photo_url, mercuriale_sku, mercuriale_designation, fournisseur_nom, fournisseur_id: _fid, ...cleanForm } = form.value as Record<string, unknown>
    await store.save({
      ...cleanForm,
      id: isNew.value ? undefined : ingredientId.value,
    } as Partial<IngredientRestaurant> & { id?: string })
    router.back()
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur de sauvegarde')
  } finally {
    saving.value = false
  }
}

async function handleDelete() {
  if (!ingredientId.value) return
  if (!confirm(`Supprimer « ${form.value.nom} » ?\nCette action est irréversible.`)) return
  try {
    await store.remove(ingredientId.value)
    router.push('/recettes')
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur de suppression')
  }
}

function triggerPhotoUpload() {
  photoInputRef.value?.click()
}

async function handlePhotoSelected(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file || isNew.value) return

  uploadingPhoto.value = true
  try {
    const url = await store.uploadPhoto(ingredientId.value, file)
    form.value.photo_url = url
  } catch (e: unknown) {
    alert(e instanceof Error ? e.message : 'Erreur upload photo')
  } finally {
    uploadingPhoto.value = false
    input.value = ''
  }
}

onMounted(async () => {
  await Promise.all([
    store.ingredients.length === 0 ? store.fetchAll() : Promise.resolve(),
    mercurialeStore.items.length === 0 ? mercurialeStore.fetchAll() : Promise.resolve(),
    fournisseursStore.fournisseurs.length === 0 ? fournisseursStore.fetchAll() : Promise.resolve(),
  ])
  if (!isNew.value) {
    const existing = store.getById(ingredientId.value)
    if (existing) {
      // Capture enriched mercuriale data before spreading to form
      mercurialePhotoUrl.value = (existing as Record<string, unknown>).mercuriale_photo_url as string | null ?? null
      mercurialeSku.value = (existing as Record<string, unknown>).mercuriale_sku as string | null ?? null
      mercurialeDesignation.value = (existing as Record<string, unknown>).mercuriale_designation as string | null ?? null
      form.value = { ...existing, allergenes: [...existing.allergenes] }
    }
  }
})
</script>

<template>
  <div class="ingredient-detail">
    <div class="page-header">
      <button class="btn-back" @click="router.back()">&#8592; Retour</button>
      <h1>{{ isNew ? 'Nouvel ingrédient' : form.nom }}</h1>
    </div>

    <input
      ref="photoInputRef"
      type="file"
      accept="image/*"
      capture="environment"
      class="visually-hidden"
      @change="handlePhotoSelected"
    />

    <!-- Photo -->
    <div class="photo-section">
      <button
        class="photo-btn"
        :class="{ uploading: uploadingPhoto }"
        :disabled="isNew"
        @click="triggerPhotoUpload"
      >
        <img v-if="displayPhotoUrl" :src="displayPhotoUrl" :alt="form.nom || ''" />
        <div v-else-if="uploadingPhoto" class="photo-spinner">...</div>
        <div v-else class="photo-placeholder">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
          <span>Ajouter photo</span>
        </div>
      </button>
    </div>

    <!-- Supplier selector -->
    <div v-if="!isNew" class="supplier-section">
      <span class="supplier-label">Fournisseur préféré</span>
      <div v-if="linkedMercuriale.length > 0" class="supplier-selector">
        <select
          :value="form.fournisseur_prefere_id || ''"
          class="field-input"
          @change="changePreferredSupplier(($event.target as HTMLSelectElement).value || null)"
        >
          <option value="">— Aucun préféré —</option>
          <option
            v-for="m in linkedMercuriale"
            :key="m.id"
            :value="m.id"
          >
            {{ m.designation }} — {{ getFournisseurNom(m.fournisseur_id) }} ({{ m.prix_unitaire_ht.toFixed(2) }} €)
          </option>
        </select>
        <div v-if="mercurialeSku" class="supplier-sku">SKU : {{ mercurialeSku }}</div>
      </div>
      <div v-else class="supplier-empty">
        <span>Aucun produit fournisseur relié à cet ingrédient</span>
        <button class="btn-link" @click="router.push('/mercuriale')">Voir la mercuriale</button>
      </div>
      <div class="supplier-hint">Le fournisseur préféré détermine le coût unitaire de cet ingrédient.</div>
    </div>

    <!-- Form -->
    <div class="form-section">
      <label class="field">
        <span class="field-label">Nom *</span>
        <input v-model="form.nom" type="text" class="field-input" placeholder="Nom de l'ingrédient" />
      </label>

      <div class="field-row">
        <label class="field">
          <span class="field-label">Unité de stock</span>
          <select v-model="form.unite_stock" class="field-input">
            <option v-for="u in UNITES" :key="u" :value="u">{{ u }}</option>
          </select>
        </label>
        <label class="field">
          <span class="field-label">Catégorie</span>
          <input v-model="form.categorie" type="text" class="field-input" placeholder="Ex: Légumes" list="cat-list" />
          <datalist id="cat-list">
            <option v-for="c in store.categories" :key="c" :value="c" />
          </datalist>
        </label>
      </div>

      <div class="field-row">
        <label class="field">
          <span class="field-label">Rendement</span>
          <input v-model.number="form.rendement" type="number" step="0.01" min="0" max="1" class="field-input" />
        </label>
        <label class="field">
          <span class="field-label">Stock tampon</span>
          <input v-model.number="form.stock_tampon" type="number" step="0.1" min="0" class="field-input" />
        </label>
      </div>

      <label class="field">
        <span class="field-label">Contient (composition libre)</span>
        <textarea v-model="form.contient" rows="2" class="field-input field-textarea" placeholder="Ex: eau, sucre, arôme naturel..." />
      </label>

      <!-- Allergènes -->
      <div class="field">
        <span class="field-label">Allergènes</span>
        <div class="allergen-grid">
          <button
            v-for="a in ALL_ALLERGENES"
            :key="a.key"
            :class="['allergen-btn', { active: hasAllergene(a.key) }]"
            @click="toggleAllergene(a.key)"
          >
            {{ a.label }}
          </button>
        </div>
      </div>

      <!-- Actif toggle -->
      <label class="toggle-field">
        <input type="checkbox" v-model="form.actif" class="toggle-check" />
        <span>Ingrédient actif</span>
      </label>

      <!-- Cost info (read-only) -->
      <div v-if="!isNew && form.cout_unitaire" class="info-row">
        <span class="info-label">Coût unitaire</span>
        <span class="info-value">{{ formatCout(form.cout_unitaire ?? 0) }} €/{{ form.unite_stock }}</span>
      </div>
    </div>

    <!-- Actions -->
    <div class="actions-bar">
      <button v-if="!isNew" class="btn-danger" @click="handleDelete">Supprimer</button>
      <div class="spacer" />
      <button class="btn-secondary" @click="router.back()">Annuler</button>
      <button class="btn-primary" :disabled="saving || !form.nom?.trim()" @click="handleSave">
        {{ saving ? 'Sauvegarde...' : 'Enregistrer' }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.ingredient-detail {
  max-width: 600px;
}

.page-header {
  margin-bottom: 20px;
}
.btn-back {
  background: none;
  border: none;
  font-size: 16px;
  color: var(--color-primary);
  cursor: pointer;
  padding: 8px 0;
  font-weight: 600;
}
h1 {
  font-size: 28px;
  margin-top: 4px;
}

.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
}

/* Photo */
.photo-section {
  margin-bottom: 24px;
}
.photo-btn {
  width: 120px;
  height: 120px;
  border-radius: var(--radius-md);
  border: 2px dashed var(--border);
  background: var(--bg-main);
  cursor: pointer;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
  transition: border-color 0.15s;
}
.photo-btn:active {
  border-color: var(--color-primary);
}
.photo-btn.uploading {
  opacity: 0.5;
  pointer-events: none;
}
.photo-btn img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.photo-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  color: var(--text-tertiary);
  font-size: 13px;
}
.photo-spinner {
  font-size: 18px;
  color: var(--text-tertiary);
  animation: pulse 1s infinite;
}
@keyframes pulse {
  0%, 100% { opacity: 0.4; }
  50% { opacity: 1; }
}

/* Supplier section */
.supplier-section {
  background: var(--bg-main);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 12px 16px;
  margin-bottom: 20px;
}
.supplier-label {
  display: block;
  font-size: 12px;
  font-weight: 600;
  color: var(--text-tertiary);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  margin-bottom: 8px;
}
.supplier-selector select {
  width: 100%;
  height: 48px;
  font-size: 16px;
}
.supplier-sku {
  font-size: 14px;
  font-weight: 600;
  color: var(--color-primary);
  margin-top: 6px;
}
.supplier-empty {
  display: flex;
  flex-direction: column;
  gap: 8px;
  color: var(--text-tertiary);
  font-size: 14px;
}
.supplier-empty .btn-link {
  background: none;
  border: none;
  color: var(--color-primary);
  font-weight: 600;
  font-size: 15px;
  cursor: pointer;
  padding: 0;
  text-align: left;
  text-decoration: underline;
}
.supplier-hint {
  font-size: 13px;
  color: var(--text-tertiary);
  margin-top: 8px;
}

/* Form */
.form-section {
  display: flex;
  flex-direction: column;
  gap: 16px;
  margin-bottom: 24px;
}
.field {
  display: flex;
  flex-direction: column;
  gap: 6px;
  flex: 1;
}
.field-label {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
}
.field-input {
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 14px;
  font-size: 18px;
  background: var(--bg-surface);
}
.field-input:focus {
  outline: none;
  border-color: var(--color-primary);
}
.field-textarea {
  height: auto;
  padding: 12px 14px;
  font-size: 16px;
  resize: vertical;
}
.field-row {
  display: flex;
  gap: 12px;
}

/* Allergènes */
.allergen-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.allergen-btn {
  height: 48px;
  padding: 0 16px;
  border: 2px solid var(--border);
  border-radius: 24px;
  background: var(--bg-surface);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
}
.allergen-btn.active {
  background: #fef3c7;
  border-color: #f59e0b;
  color: #92400e;
}

/* Toggle */
.toggle-field {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  padding: 8px 0;
}
.toggle-check {
  width: 22px;
  height: 22px;
  cursor: pointer;
}

/* Info row */
.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: var(--bg-main);
  border-radius: var(--radius-md);
}
.info-label {
  font-size: 14px;
  color: var(--text-secondary);
}
.info-value {
  font-size: 18px;
  font-weight: 700;
  color: var(--color-primary);
}

/* Actions */
.actions-bar {
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 20px 0;
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
.btn-primary:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}
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
</style>
