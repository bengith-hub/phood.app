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
  showEditor.value = true
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
            <div class="field full">
              <label>Nom *</label>
              <input v-model="editingFournisseur.nom" required />
            </div>
            <div class="field">
              <label>Contact</label>
              <input v-model="editingFournisseur.contact_nom" />
            </div>
            <div class="field">
              <label>Téléphone</label>
              <input v-model="editingFournisseur.telephone" type="tel" />
            </div>
            <div class="field full">
              <label>Email commande</label>
              <input v-model="editingFournisseur.email_commande" type="email" />
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
  gap: 8px;
  margin-bottom: 12px;
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
</style>
