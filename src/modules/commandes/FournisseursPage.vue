<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useAuth } from '@/composables/useAuth'
import type { Fournisseur } from '@/types/database'

const router = useRouter()
const store = useFournisseursStore()
const { isAdmin } = useAuth()

const search = ref('')
const showEditor = ref(false)
const editingFournisseur = ref<Partial<Fournisseur> | null>(null)

// Logo search
const logoSearching = ref(false)
const logoResults = ref<{ url: string; source: string; label: string; thumbnail?: string }[]>([])

// Email chips
const emailChips = ref<string[]>([])
const emailBccChips = ref<string[]>([])
const emailInput = ref('')
const emailBccInput = ref('')
const emailInputEl = ref<HTMLInputElement | null>(null)
const emailBccInputEl = ref<HTMLInputElement | null>(null)

const JOURS = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']
const JOURS_COURTS = ['D', 'L', 'Ma', 'Me', 'J', 'V', 'S']

const filtered = computed(() => {
  const q = search.value.toLowerCase()
  if (!q) return store.fournisseurs
  return store.fournisseurs.filter(f =>
    f.nom.toLowerCase().includes(q) ||
    f.contact_nom?.toLowerCase().includes(q) ||
    f.email_commande?.toLowerCase().includes(q)
  )
})

function openEditor(fournisseur?: Fournisseur) {
  editingFournisseur.value = fournisseur
    ? { ...fournisseur }
    : {
        nom: '',
        contact_nom: '',
        email_commande: '',
        email_commande_bcc: '',
        telephone: '',
        jours_commande: [],
        jours_livraison: [],
        delai_commande_livraison: {},
        heure_limite_commande: null,
        duree_couverture_defaut: 5,
        franco_minimum: 0,
        mode_envoi: 'email',
        actif: true,
      }
  // Parse emails into chips
  emailChips.value = parseEmails(editingFournisseur.value.email_commande)
  emailBccChips.value = parseEmails(editingFournisseur.value.email_commande_bcc)
  emailInput.value = ''
  emailBccInput.value = ''
  // Reset logo search
  logoResults.value = []
  logoSearching.value = false
  showEditor.value = true
}

/** Parse semicolon/comma-separated email string into array */
function parseEmails(val: string | null | undefined): string[] {
  if (!val) return []
  return val.split(/[;,\s]+/).map(e => e.trim()).filter(e => e.includes('@'))
}

/** Join email array back to semicolon-separated string */
function joinEmails(arr: string[]): string {
  return arr.join('; ')
}

type EmailField = 'to' | 'bcc'

function getEmailRefs(field: EmailField) {
  return field === 'to'
    ? { input: emailInput, chips: emailChips }
    : { input: emailBccInput, chips: emailBccChips }
}

/** Add email to a chip list */
function addEmail(field: EmailField) {
  const { input, chips } = getEmailRefs(field)
  const val = input.value.trim().toLowerCase()
  if (!val || !val.includes('@') || !val.includes('.')) return
  if (!chips.value.includes(val)) {
    chips.value.push(val)
  }
  input.value = ''
}

/** Handle keydown on email input — add on Enter, Tab, semicolon, comma */
function handleEmailKey(e: KeyboardEvent, field: EmailField) {
  const { input, chips } = getEmailRefs(field)
  if (['Enter', 'Tab', ';', ','].includes(e.key)) {
    e.preventDefault()
    addEmail(field)
  }
  // Backspace on empty input → remove last chip
  if (e.key === 'Backspace' && !input.value && chips.value.length > 0) {
    chips.value.pop()
  }
}

/** Handle paste → split into multiple emails */
function handleEmailPaste(e: ClipboardEvent, field: EmailField) {
  e.preventDefault()
  const { input, chips } = getEmailRefs(field)
  const text = e.clipboardData?.getData('text') || ''
  const emails = text.split(/[;,\s]+/).map(s => s.trim().toLowerCase()).filter(s => s.includes('@') && s.includes('.'))
  for (const em of emails) {
    if (!chips.value.includes(em)) {
      chips.value.push(em)
    }
  }
  input.value = ''
}

function removeEmailChip(field: EmailField, idx: number) {
  const { chips } = getEmailRefs(field)
  chips.value.splice(idx, 1)
}

/** Search logo for current supplier */
async function handleSearchLogo() {
  if (!editingFournisseur.value?.nom) return
  logoSearching.value = true
  logoResults.value = []
  try {
    const results = await store.searchLogo(
      editingFournisseur.value.nom,
      joinEmails(emailChips.value) || undefined
    )
    logoResults.value = results
  } catch {
    // silent
  } finally {
    logoSearching.value = false
  }
}

/** Select a logo from search results */
function selectLogo(url: string) {
  if (!editingFournisseur.value) return
  editingFournisseur.value.logo_url = url
  logoResults.value = []
}

/** Toggle a delivery day on/off and clean up delays */
function toggleLivraisonDay(idx: number) {
  if (!editingFournisseur.value) return
  const current = editingFournisseur.value.jours_livraison || []
  if (current.includes(idx)) {
    editingFournisseur.value.jours_livraison = current.filter((j: number) => j !== idx)
    // Remove delay entry for this day
    const delais = { ...(editingFournisseur.value.delai_commande_livraison as Record<string, number> || {}) }
    delete delais[String(idx)]
    editingFournisseur.value.delai_commande_livraison = delais
  } else {
    editingFournisseur.value.jours_livraison = [...current, idx]
    // Set default delay = 1
    setDelai(idx, 1)
  }
}

function closeEditor() {
  showEditor.value = false
  editingFournisseur.value = null
}

async function handleSave() {
  if (!editingFournisseur.value) return
  try {
    // Flush any pending email input
    if (emailInput.value.trim()) addEmail('to')
    if (emailBccInput.value.trim()) addEmail('bcc')

    // Write email chips back to string fields
    editingFournisseur.value.email_commande = joinEmails(emailChips.value) || null
    editingFournisseur.value.email_commande_bcc = joinEmails(emailBccChips.value) || null

    // Auto-compute jours_commande from delivery days + delays
    const livDays = editingFournisseur.value.jours_livraison || []
    const delais = (editingFournisseur.value.delai_commande_livraison || {}) as Record<string, number>
    const orderDays = new Set<number>()
    for (const d of livDays) {
      const delai = delais[String(d)] ?? 1
      orderDays.add(getJourCommande(d, delai))
    }
    editingFournisseur.value.jours_commande = [...orderDays]

    await store.save(editingFournisseur.value)
    closeEditor()
  } catch (e: unknown) {
    const err = e as Record<string, unknown>
    alert((err?.message as string) || 'Erreur de sauvegarde')
  }
}

function formatFranco(montant: number) {
  return montant > 0 ? `${montant.toFixed(0)} €` : 'Aucun'
}

/** Get the delay in days for a specific delivery day */
function getDelai(deliveryDay: number): number {
  const delais = editingFournisseur.value?.delai_commande_livraison as Record<string, number> | null
  return delais?.[String(deliveryDay)] ?? 1
}

/** Set the delay for a specific delivery day */
function setDelai(deliveryDay: number, days: number) {
  if (!editingFournisseur.value) return
  const current = (editingFournisseur.value.delai_commande_livraison || {}) as Record<string, number>
  editingFournisseur.value.delai_commande_livraison = {
    ...current,
    [String(deliveryDay)]: Math.max(1, days),
  }
}

/** Calculate order day from delivery day - delay */
function getJourCommande(deliveryDay: number, delai: number): number {
  return ((deliveryDay - (delai % 7)) + 7) % 7
}

/**
 * "A pour B" notation: delay 1 = A pour B, delay 2 = A pour C, etc.
 * Standard restaurant vocabulary for order-to-delivery lead time.
 */
function getDelaiLabel(delai: number): string {
  const letter = String.fromCharCode(65 + delai) // 1→B, 2→C, 3→D...
  return `A pour ${letter}`
}

/**
 * Check if the order day falls in the previous week (S-1).
 * Example: ordering Friday for delivery Monday = previous week's Friday.
 */
function isPreviousWeek(deliveryDay: number, orderDay: number): boolean {
  // Convert to Mon=0..Sun=6 ordering for logical week comparison
  const livOrd = (deliveryDay + 6) % 7
  const cmdOrd = (orderDay + 6) % 7
  return cmdOrd >= livOrd
}

/** Get sorted delivery days for the editing fournisseur */
function sortedLivraisonDays(): number[] {
  const jours = editingFournisseur.value?.jours_livraison || []
  return [...jours].sort((a, b) => ((a || 7) - (b || 7)))
}

/** Format delivery schedule summary for card display */
function formatSchedule(f: Fournisseur): string {
  if (!f.jours_livraison || f.jours_livraison.length === 0) return '—'
  const delais = (f.delai_commande_livraison || {}) as Record<string, number>
  const sorted = [...f.jours_livraison].sort((a, b) => ((a || 7) - (b || 7)))
  return sorted.map(d => {
    const delai = delais[String(d)] ?? 1
    const orderDay = getJourCommande(d, delai)
    const s1 = isPreviousWeek(d, orderDay) ? '(S-1)' : ''
    return `Cmd ${JOURS_COURTS[orderDay]}${s1} → Liv ${JOURS_COURTS[d]}`
  }).join(' | ')
}

async function handleDelete() {
  if (!editingFournisseur.value?.id) return
  const nom = editingFournisseur.value.nom || 'ce fournisseur'
  const id = editingFournisseur.value.id

  // First try simple delete
  try {
    await store.remove(id)
    closeEditor()
    return
  } catch (e: unknown) {
    // PostgrestError is a POJO (not instanceof Error) — access .message and .code directly
    const err = e as Record<string, unknown>
    const msg = (err?.message as string) || String(e)
    const code = (err?.code as string) || ''
    if (!(msg.includes('violates foreign key') || msg.includes('foreign_key') || code === '23503' || msg.includes('23503'))) {
      alert(msg || 'Erreur de suppression')
      return
    }
  }

  // FK constraint — offer 3 options
  const choice = prompt(
    `« ${nom} » est lié à des produits mercuriale, commandes ou ingrédients.\n\nQue souhaitez-vous faire ?\n\n` +
    `1 — Supprimer le fournisseur ET tous ses produits mercuriale\n` +
    `    ⚠️ IRRÉVERSIBLE — les lignes de commande liées seront aussi perdues\n\n` +
    `2 — Désactiver le fournisseur (masqué mais données conservées)\n\n` +
    `Tapez 1 ou 2 (ou annuler) :`
  )

  if (choice === '1') {
    if (!confirm(`⚠️ ATTENTION : Supprimer « ${nom} » ET tous ses produits ?\n\nCette action est IRRÉVERSIBLE.`)) return
    try {
      await store.removeWithProducts(id)
      closeEditor()
    } catch (e2: unknown) {
      const err2 = e2 as Record<string, unknown>
      alert((err2?.message as string) || 'Erreur de suppression en cascade')
    }
  } else if (choice === '2') {
    try {
      await store.deactivate(id)
      closeEditor()
    } catch (e2: unknown) {
      const err2 = e2 as Record<string, unknown>
      alert((err2?.message as string) || 'Erreur de désactivation')
    }
  }
}

onMounted(() => store.fetchAll())
</script>

<template>
  <div class="fournisseurs-page">
    <div class="page-header">
      <h1>Fournisseurs</h1>
      <button v-if="isAdmin" class="btn-primary" @click="openEditor()">
        + Ajouter
      </button>
    </div>

    <input
      v-model="search"
      type="search"
      placeholder="Rechercher un fournisseur..."
      class="search-input"
    />

    <div v-if="store.loading" class="loading">Chargement...</div>

    <div v-else-if="filtered.length === 0" class="empty">
      Aucun fournisseur trouvé
    </div>

    <div v-else class="fournisseur-list">
      <div
        v-for="f in filtered"
        :key="f.id"
        class="fournisseur-card"
        :class="{ inactive: !f.actif }"
        @click="isAdmin ? openEditor(f) : undefined"
      >
        <div class="card-header">
          <div v-if="f.logo_url" class="card-logo">
            <img :src="f.logo_url" :alt="f.nom" />
          </div>
          <div v-else class="card-logo card-logo-placeholder">
            {{ f.nom.charAt(0).toUpperCase() }}
          </div>
          <span class="card-nom">{{ f.nom }}</span>
          <span v-if="!f.actif" class="badge-inactive">Inactif</span>
          <span v-if="f.franco_minimum > 0" class="badge-franco">
            Franco {{ formatFranco(f.franco_minimum) }}
          </span>
        </div>
        <div class="card-details">
          <div v-if="f.contact_nom" class="detail">
            <span class="detail-label">Contact</span>
            <span>{{ f.contact_nom }}</span>
          </div>
          <div v-if="f.email_commande" class="detail">
            <span class="detail-label">Email</span>
            <span>{{ f.email_commande }}</span>
          </div>
          <div v-if="f.telephone" class="detail">
            <span class="detail-label">Tél</span>
            <span>{{ f.telephone }}</span>
          </div>
          <div class="detail schedule-detail">
            <span class="detail-label">Planning</span>
            <span>{{ formatSchedule(f) }}</span>
          </div>
          <div v-if="f.heure_limite_commande" class="detail">
            <span class="detail-label">Heure limite</span>
            <span>{{ f.heure_limite_commande }}</span>
          </div>
        </div>
        <button
          class="btn-produits"
          @click.stop="router.push(`/mercuriale/${f.id}`)"
        >
          Voir les produits →
        </button>
      </div>
    </div>

    <!-- Editor Modal -->
    <div v-if="showEditor && editingFournisseur" class="modal-overlay" @click.self="closeEditor">
      <div class="modal">
        <div class="modal-header">
          <h2>{{ editingFournisseur.id ? 'Modifier' : 'Nouveau' }} fournisseur</h2>
          <button class="btn-close" @click="closeEditor">✕</button>
        </div>

        <form @submit.prevent="handleSave" class="modal-body">
          <div class="form-grid">
            <!-- Logo + Nom -->
            <div class="field full logo-nom-row">
              <div v-if="editingFournisseur.logo_url" class="editor-logo">
                <img :src="editingFournisseur.logo_url" :alt="editingFournisseur.nom || ''" />
              </div>
              <div v-else class="editor-logo editor-logo-placeholder">
                {{ (editingFournisseur.nom || '?').charAt(0).toUpperCase() }}
              </div>
              <div class="field" style="flex:1">
                <label>Nom *</label>
                <input v-model="editingFournisseur.nom" required />
              </div>
            </div>
            <!-- Logo URL + search -->
            <div class="field full">
              <label>Logo</label>
              <div class="logo-url-row">
                <input v-model="editingFournisseur.logo_url" type="url" placeholder="https://..." style="flex:1" />
                <button
                  type="button"
                  class="btn-search-logo"
                  @click="handleSearchLogo"
                  :disabled="logoSearching || !editingFournisseur.nom"
                >
                  {{ logoSearching ? '...' : 'Rechercher' }}
                </button>
              </div>
              <!-- Logo search results -->
              <div v-if="logoResults.length > 0" class="logo-results">
                <div
                  v-for="(logo, i) in logoResults"
                  :key="i"
                  class="logo-result-item"
                  @click="selectLogo(logo.url)"
                >
                  <img :src="logo.thumbnail || logo.url" :alt="logo.label" />
                  <span class="logo-result-label">{{ logo.label }}</span>
                </div>
              </div>
              <div v-if="logoSearching" class="logo-search-status">Recherche en cours...</div>
              <div v-if="!logoSearching && logoResults.length === 0 && editingFournisseur.logo_url === null" class="logo-search-status" style="display:none"></div>
            </div>
            <div class="field">
              <label>Contact</label>
              <input v-model="editingFournisseur.contact_nom" />
            </div>
            <div class="field">
              <label>Téléphone</label>
              <input v-model="editingFournisseur.telephone" type="tel" />
            </div>

            <!-- Email commande — chip input -->
            <div class="field full">
              <label>Email commande</label>
              <div class="email-chips-container" @click="emailInputEl?.focus()">
                <span v-for="(email, i) in emailChips" :key="i" class="email-chip">
                  {{ email }}
                  <button type="button" class="chip-remove" @click.stop="removeEmailChip('to', i)">×</button>
                </span>
                <input
                  ref="emailInputEl"
                  v-model="emailInput"
                  type="text"
                  inputmode="email"
                  class="email-chip-input"
                  placeholder="Ajouter un email..."
                  @keydown="handleEmailKey($event, 'to')"
                  @paste="handleEmailPaste($event, 'to')"
                  @blur="addEmail('to')"
                />
              </div>
            </div>

            <!-- Email BCC — chip input -->
            <div class="field full">
              <label>Email BCC (copie cachée)</label>
              <div class="email-chips-container" @click="emailBccInputEl?.focus()">
                <span v-for="(email, i) in emailBccChips" :key="i" class="email-chip email-chip-bcc">
                  {{ email }}
                  <button type="button" class="chip-remove" @click.stop="removeEmailChip('bcc', i)">×</button>
                </span>
                <input
                  ref="emailBccInputEl"
                  v-model="emailBccInput"
                  type="text"
                  inputmode="email"
                  class="email-chip-input"
                  placeholder="Ajouter un email en copie..."
                  @keydown="handleEmailKey($event, 'bcc')"
                  @paste="handleEmailPaste($event, 'bcc')"
                  @blur="addEmail('bcc')"
                />
              </div>
            </div>

            <div class="field">
              <label>SIRET</label>
              <input v-model="editingFournisseur.siret" placeholder="123 456 789 00012" />
            </div>
            <div class="field">
              <label>Franco minimum (€)</label>
              <input
                v-model.number="editingFournisseur.franco_minimum"
                type="number"
                inputmode="numeric"
                min="0"
                step="1"
              />
            </div>
            <div class="field">
              <label>Couverture par défaut (jours)</label>
              <input
                v-model.number="editingFournisseur.duree_couverture_defaut"
                type="number"
                inputmode="numeric"
                min="1"
                max="30"
                placeholder="5"
              />
            </div>
            <div class="field">
              <label>Heure limite commande</label>
              <input
                v-model="editingFournisseur.heure_limite_commande"
                type="time"
              />
            </div>

            <div class="field full">
              <label>Jours de livraison</label>
              <div class="day-toggles">
                <button
                  v-for="(jour, idx) in JOURS"
                  :key="idx"
                  type="button"
                  class="day-btn"
                  :class="{ selected: editingFournisseur.jours_livraison?.includes(idx) }"
                  @click="toggleLivraisonDay(idx)"
                >
                  {{ jour }}
                </button>
              </div>
            </div>

            <div v-if="editingFournisseur.jours_livraison?.length" class="field full">
              <label>Planning commande → livraison</label>
              <div class="delivery-schedule">
                <div v-for="day in sortedLivraisonDays()" :key="day" class="schedule-row">
                  <span class="schedule-cmd">
                    Cmd <strong>{{ JOURS[getJourCommande(day, getDelai(day))] }}</strong>
                    <span v-if="isPreviousWeek(day, getJourCommande(day, getDelai(day)))" class="badge-s1">S-1</span>
                  </span>
                  <span class="schedule-arrow">→</span>
                  <span class="schedule-liv">
                    Liv <strong>{{ JOURS[day] }}</strong>
                  </span>
                  <div class="schedule-delay">
                    <button type="button" class="delay-btn" @click="setDelai(day, getDelai(day) - 1)" :disabled="getDelai(day) <= 1">−</button>
                    <span class="delay-value">{{ getDelaiLabel(getDelai(day)) }}</span>
                    <button type="button" class="delay-btn" @click="setDelai(day, getDelai(day) + 1)">+</button>
                  </div>
                </div>
              </div>
            </div>

            <div class="field full">
              <label>Notes</label>
              <textarea v-model="editingFournisseur.notes" rows="3" />
            </div>

            <div class="field">
              <label class="checkbox-label">
                <input type="checkbox" v-model="editingFournisseur.actif" />
                Actif
              </label>
            </div>
          </div>

          <div class="modal-actions">
            <button
              v-if="editingFournisseur.id"
              type="button"
              class="btn-danger"
              @click="handleDelete"
            >
              Supprimer
            </button>
            <span class="spacer" />
            <button type="button" class="btn-secondary" @click="closeEditor">Annuler</button>
            <button type="submit" class="btn-primary">Enregistrer</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h1 { font-size: 28px; }

.btn-primary {
  background: var(--color-primary);
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 24px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}

.btn-secondary {
  background: var(--bg-main);
  color: var(--text-primary);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 12px 24px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

.search-input {
  width: 100%;
  max-width: 480px;
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-surface);
  margin-bottom: 20px;
}

.search-input:focus {
  outline: none;
  border-color: var(--color-primary);
}

.loading, .empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 60px 20px;
  font-size: 16px;
}

.fournisseur-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
  gap: 16px;
}

.fournisseur-card {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  padding: 20px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
  cursor: pointer;
  transition: box-shadow 0.15s;
}

.fournisseur-card:active {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
}

.fournisseur-card.inactive {
  opacity: 0.5;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
}

.card-logo {
  width: 44px;
  height: 44px;
  border-radius: 10px;
  overflow: hidden;
  flex-shrink: 0;
  border: 1px solid var(--border);
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.card-logo img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 4px;
}

.card-logo-placeholder {
  background: var(--color-primary);
  color: white;
  font-size: 20px;
  font-weight: 800;
  border: none;
}

.card-nom {
  font-size: 20px;
  font-weight: 700;
  flex: 1;
}

.badge-inactive {
  background: var(--text-tertiary);
  color: white;
  padding: 2px 8px;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 600;
}

.badge-franco {
  background: var(--color-primary);
  color: white;
  padding: 2px 8px;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 600;
}

.card-details {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.detail {
  display: flex;
  gap: 8px;
  font-size: 15px;
}

.detail-label {
  color: var(--text-tertiary);
  min-width: 80px;
  flex-shrink: 0;
}

/* Modal */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 100;
  padding: 20px;
}

.modal {
  background: var(--bg-surface);
  border-radius: var(--radius-lg);
  width: 100%;
  max-width: 600px;
  max-height: 90dvh;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  border-bottom: 1px solid var(--border);
}

.modal-header h2 {
  font-size: 22px;
}

.btn-close {
  width: 48px;
  height: 48px;
  border: none;
  background: transparent;
  font-size: 24px;
  cursor: pointer;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.modal-body {
  padding: 24px;
}

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
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary);
}

.field input,
.field textarea {
  height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 16px;
  font-size: 18px;
  background: var(--bg-main);
  color: var(--text-primary);
}

.field textarea {
  height: auto;
  padding: 12px 16px;
  resize: vertical;
}

.field input:focus,
.field textarea:focus {
  outline: none;
  border-color: var(--color-primary);
}

.checkbox-label {
  flex-direction: row !important;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}

.checkbox-label input[type="checkbox"] {
  width: 24px;
  height: 24px;
}

.day-toggles {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.day-btn {
  min-width: 52px;
  height: 48px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-main);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
}

.day-btn.selected {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.modal-actions {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 24px;
  padding-top: 20px;
  border-top: 1px solid var(--border);
}
.modal-actions .spacer {
  flex: 1;
}
.btn-produits {
  margin-top: 12px;
  width: 100%;
  padding: 10px 16px;
  background: rgba(232, 93, 44, 0.08);
  color: var(--color-primary);
  border: 1px solid rgba(232, 93, 44, 0.2);
  border-radius: var(--radius-md);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  text-align: center;
}
.btn-produits:active {
  background: rgba(232, 93, 44, 0.16);
}

.btn-danger {
  background: #ef4444;
  color: white;
  border: none;
  border-radius: var(--radius-md);
  padding: 12px 20px;
  font-size: 16px;
  font-weight: 700;
  cursor: pointer;
}

/* Delivery schedule editor */
.delivery-schedule {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.schedule-row {
  display: flex;
  align-items: center;
  gap: 10px;
  background: var(--bg-main);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 10px 14px;
  flex-wrap: wrap;
}

.schedule-cmd {
  font-size: 16px;
  color: var(--text-secondary);
  min-width: 80px;
}

.schedule-cmd strong {
  color: var(--color-primary);
}

.schedule-arrow {
  font-size: 18px;
  color: var(--text-tertiary);
}

.schedule-liv {
  font-size: 16px;
  color: var(--text-secondary);
  min-width: 80px;
}

.schedule-liv strong {
  color: var(--text-primary);
  font-weight: 700;
}

.schedule-delay {
  margin-left: auto;
  display: flex;
  align-items: center;
  gap: 6px;
}

.delay-btn {
  width: 40px;
  height: 40px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--bg-surface);
  font-size: 20px;
  font-weight: 700;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--text-primary);
}

.delay-btn:disabled {
  opacity: 0.3;
  cursor: not-allowed;
}

.delay-btn:active:not(:disabled) {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.delay-value {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-primary);
  min-width: 72px;
  text-align: center;
  white-space: nowrap;
}

.logo-nom-row {
  display: flex !important;
  flex-direction: row !important;
  align-items: flex-end;
  gap: 14px;
}

.editor-logo {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  overflow: hidden;
  flex-shrink: 0;
  border: 2px solid var(--border);
  background: white;
  display: flex;
  align-items: center;
  justify-content: center;
}

.editor-logo img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 6px;
}

.editor-logo-placeholder {
  background: var(--color-primary);
  color: white;
  font-size: 28px;
  font-weight: 800;
  border: none;
}

.badge-s1 {
  display: inline-block;
  background: #f59e0b;
  color: white;
  font-size: 11px;
  font-weight: 700;
  padding: 1px 5px;
  border-radius: 4px;
  margin-left: 4px;
  vertical-align: middle;
}

.schedule-detail {
  flex-wrap: wrap;
}

.schedule-detail span:last-child {
  font-size: 14px;
  line-height: 1.4;
}

/* Logo search */
.logo-url-row {
  display: flex;
  gap: 8px;
}

.btn-search-logo {
  height: 52px;
  padding: 0 16px;
  background: var(--bg-main);
  border: 2px solid var(--color-primary);
  border-radius: var(--radius-md);
  color: var(--color-primary);
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}

.btn-search-logo:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}

.logo-results {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin-top: 10px;
}

.logo-result-item {
  width: 72px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
  cursor: pointer;
  padding: 6px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  background: white;
  transition: border-color 0.15s;
}

.logo-result-item:active {
  border-color: var(--color-primary);
}

.logo-result-item img {
  width: 56px;
  height: 56px;
  object-fit: contain;
}

.logo-result-label {
  font-size: 10px;
  color: var(--text-tertiary);
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 68px;
}

.logo-search-status {
  font-size: 14px;
  color: var(--text-tertiary);
  margin-top: 6px;
}

/* Email chip input */
.email-chips-container {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  min-height: 52px;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 8px 12px;
  background: var(--bg-main);
  cursor: text;
  align-items: center;
  transition: border-color 0.15s;
}

.email-chips-container:focus-within {
  border-color: var(--color-primary);
}

.email-chip {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background: var(--color-primary);
  color: white;
  padding: 4px 10px;
  border-radius: 20px;
  font-size: 14px;
  font-weight: 500;
  line-height: 1.4;
  max-width: 100%;
  word-break: break-all;
}

.email-chip-bcc {
  background: #6366f1;
}

.chip-remove {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  background: rgba(255, 255, 255, 0.3);
  border: none;
  border-radius: 50%;
  color: white;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  padding: 0;
  line-height: 1;
  flex-shrink: 0;
}

.chip-remove:active {
  background: rgba(255, 255, 255, 0.5);
}

.email-chip-input {
  border: none !important;
  background: transparent !important;
  outline: none !important;
  height: 32px !important;
  min-width: 160px;
  flex: 1;
  font-size: 16px !important;
  padding: 0 !important;
  color: var(--text-primary);
}

.email-chip-input::placeholder {
  color: var(--text-tertiary);
  font-size: 14px;
}
</style>
