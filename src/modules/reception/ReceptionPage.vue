<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useCommandesStore } from '@/stores/commandes'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useAuth } from '@/composables/useAuth'
import { restCall, storageUpload } from '@/lib/rest-client'
import { compressImage, blobToBase64 } from '@/lib/image-compress'
import type { Commande, CommandeLigne, AnomalieType } from '@/types/database'

const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()
const mercurialeStore = useMercurialeStore()
const { user, isManagerOrAbove } = useAuth()

// Steps: select → photo → compare → validate
type Step = 'select' | 'photo' | 'compare' | 'validate'
const step = ref<Step>('select')
const selectedCommande = ref<Commande | null>(null)
const commandeLignes = ref<CommandeLigne[]>([])
const photoBlob = ref<Blob | null>(null)
const photoPreview = ref<string | null>(null)
const iaLoading = ref(false)
const iaResult = ref<Record<string, unknown> | null>(null)
const validating = ref(false)

// Reception lines for comparison
interface ReceptionLigneEdit {
  commande_ligne_id: string | null
  mercuriale_id: string
  designation: string
  quantite_attendue: number
  quantite_recue: number
  quantite_acceptee: number
  anomalie_type: AnomalieType | null
  anomalie_detail: string
  prix_bl: number | null
}
const receptionLignes = ref<ReceptionLigneEdit[]>([])

const commandesAReceptionner = computed(() =>
  commandesStore.commandes.filter(c => c.statut === 'envoyee')
)

function getFournisseurNom(id: string) {
  return fournisseursStore.getById(id)?.nom || '—'
}

function getMercurialeNom(id: string) {
  return mercurialeStore.getById(id)?.designation || '—'
}

async function selectCommande(cmd: Commande) {
  selectedCommande.value = cmd
  commandeLignes.value = await commandesStore.fetchLignes(cmd.id)

  // Pre-fill reception lines from order lines
  receptionLignes.value = commandeLignes.value.map(cl => ({
    commande_ligne_id: cl.id,
    mercuriale_id: cl.mercuriale_id,
    designation: getMercurialeNom(cl.mercuriale_id),
    quantite_attendue: cl.quantite,
    quantite_recue: cl.quantite, // default: same as ordered
    quantite_acceptee: cl.quantite,
    anomalie_type: null,
    anomalie_detail: '',
    prix_bl: null,
  }))

  step.value = 'photo'
}

async function handlePhotoCapture(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return

  // Compress image
  const compressed = await compressImage(file)
  photoBlob.value = compressed
  photoPreview.value = URL.createObjectURL(compressed)
}

async function analyzeWithAI() {
  if (!photoBlob.value) return

  iaLoading.value = true
  try {
    const base64 = await blobToBase64(photoBlob.value)

    // Send to Netlify function
    const response = await fetch('/.netlify/functions/analyze-bl', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        image_base64: base64,
        commande_lignes: receptionLignes.value.map(l => ({
          designation: l.designation,
          quantite: l.quantite_attendue,
          unite: mercurialeStore.getById(l.mercuriale_id)?.unite_stock || 'unité',
        })),
      }),
    })

    if (response.ok) {
      const result = await response.json()
      iaResult.value = result

      // Auto-match IA results to reception lines
      if (result.lignes) {
        for (const iaLine of result.lignes as { designation: string; quantite: number; prix_unitaire?: number }[]) {
          // Simple matching by name similarity
          const match = receptionLignes.value.find(rl =>
            rl.designation.toLowerCase().includes(iaLine.designation.toLowerCase().substring(0, 10)) ||
            iaLine.designation.toLowerCase().includes(rl.designation.toLowerCase().substring(0, 10))
          )
          if (match) {
            match.quantite_recue = iaLine.quantite
            match.quantite_acceptee = iaLine.quantite
            if (iaLine.prix_unitaire) match.prix_bl = iaLine.prix_unitaire
          }
        }
      }
    }
  } catch (e) {
    console.error('IA analysis failed:', e)
    // Continue without IA — manual entry fallback
  } finally {
    iaLoading.value = false
    step.value = 'compare'
  }
}

function skipIA() {
  step.value = 'compare'
}

function detectAnomalie(ligne: ReceptionLigneEdit) {
  if (ligne.quantite_recue === 0) {
    ligne.anomalie_type = 'manquant'
  } else if (ligne.quantite_recue < ligne.quantite_attendue) {
    ligne.anomalie_type = 'quantite'
  } else {
    ligne.anomalie_type = null
  }
  ligne.quantite_acceptee = ligne.quantite_recue
}

const hasAnomalies = computed(() =>
  receptionLignes.value.some(l => l.anomalie_type !== null)
)

async function handleValidate() {
  if (!selectedCommande.value || !user.value) return

  const nbAnomalies = receptionLignes.value.filter(l => l.anomalie_type).length
  const msg = nbAnomalies > 0
    ? `Valider la réception avec ${nbAnomalies} anomalie(s) ?\nLes stocks seront mis à jour.`
    : 'Valider la réception ?\nLes stocks seront mis à jour.'
  if (!confirm(msg)) return

  validating.value = true
  try {
    // Upload photo if exists
    let photoUrl: string | null = null
    if (photoBlob.value) {
      const fileName = `${selectedCommande.value.numero}_${Date.now()}.jpg`
      try {
        const result = await storageUpload('bl-photos', fileName, photoBlob.value, { contentType: 'image/jpeg' })
        photoUrl = result.path
      } catch {
        console.warn('BL photo upload failed, continuing...')
      }
    }

    // Create reception record
    const reception = await restCall<{ id: string }>(
      'POST',
      'receptions',
      {
        commande_id: selectedCommande.value.id,
        photo_bl_url: photoUrl,
        ia_extraction: iaResult.value,
        validee: !hasAnomalies.value,
        created_by: user.value.id,
      },
      { single: true },
    )

    // Create reception lines
    const lignesInsert = receptionLignes.value.map(l => ({
      reception_id: reception.id,
      commande_ligne_id: l.commande_ligne_id,
      mercuriale_id: l.mercuriale_id,
      quantite_attendue: l.quantite_attendue,
      quantite_recue: l.quantite_recue,
      quantite_acceptee: l.quantite_acceptee,
      anomalie_type: l.anomalie_type,
      anomalie_detail: l.anomalie_detail || null,
      prix_bl: l.prix_bl,
    }))
    await restCall('POST', 'reception_lignes', lignesInsert)

    // Update order status
    await commandesStore.updateStatut(
      selectedCommande.value.id,
      hasAnomalies.value ? 'controlee' : 'validee'
    )

    // Increment stocks for accepted quantities
    for (const l of receptionLignes.value) {
      if (l.quantite_acceptee > 0) {
        const merc = mercurialeStore.getById(l.mercuriale_id)
        if (merc?.ingredient_restaurant_id) {
          // Upsert stock via RPC
          await restCall('POST', 'rpc/increment_stock', {
            p_ingredient_id: merc.ingredient_restaurant_id,
            p_quantite: l.quantite_acceptee,
          })
        }
      }
    }

    // Reset and go back to selection
    step.value = 'validate'
  } catch (e) {
    console.error('Validation failed:', e)
    alert('Erreur lors de la validation')
  } finally {
    validating.value = false
  }
}

function reset() {
  step.value = 'select'
  selectedCommande.value = null
  commandeLignes.value = []
  photoBlob.value = null
  photoPreview.value = null
  iaResult.value = null
  receptionLignes.value = []
}

onMounted(async () => {
  await Promise.all([
    commandesStore.fetchAll(),
    fournisseursStore.fetchAll(),
    mercurialeStore.fetchAll(),
  ])
})
</script>

<template>
  <div class="reception-page">
    <!-- Step 1: Select order to receive -->
    <div v-if="step === 'select'">
      <h1>Réception</h1>

      <div v-if="commandesAReceptionner.length === 0" class="empty">
        Aucune commande en attente de réception
      </div>

      <div v-else class="commande-select-list">
        <h2>Commandes en attente</h2>
        <div
          v-for="cmd in commandesAReceptionner"
          :key="cmd.id"
          class="cmd-card"
          @click="selectCommande(cmd)"
        >
          <span class="cmd-numero">{{ cmd.numero }}</span>
          <span class="cmd-fournisseur">{{ getFournisseurNom(cmd.fournisseur_id) }}</span>
          <span class="cmd-date" v-if="cmd.date_livraison_prevue">
            Livr. prévue {{ new Date(cmd.date_livraison_prevue).toLocaleDateString('fr-FR') }}
          </span>
        </div>
      </div>
    </div>

    <!-- Step 2: Take photo of BL -->
    <div v-else-if="step === 'photo'">
      <button class="btn-back" @click="reset">← Retour</button>
      <h1>Photo du BL</h1>
      <p class="subtitle">{{ selectedCommande?.numero }} — {{ getFournisseurNom(selectedCommande?.fournisseur_id || '') }}</p>

      <div class="photo-section">
        <div v-if="!photoPreview" class="photo-capture">
          <label class="capture-btn">
            Prendre une photo du BL
            <input
              type="file"
              accept="image/*"
              capture="environment"
              @change="handlePhotoCapture"
              class="visually-hidden"
            />
          </label>
        </div>

        <div v-else class="photo-preview">
          <img :src="photoPreview" alt="Photo BL" />
          <div class="photo-actions">
            <button class="btn-secondary" @click="photoPreview = null; photoBlob = null">
              Reprendre
            </button>
            <button class="btn-primary" @click="analyzeWithAI" :disabled="iaLoading">
              {{ iaLoading ? 'Analyse IA...' : 'Analyser avec IA' }}
            </button>
            <button class="btn-secondary" @click="skipIA">
              Saisie manuelle
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Step 3: Compare BC vs BL -->
    <div v-else-if="step === 'compare'">
      <button class="btn-back" @click="step = 'photo'">← Photo</button>
      <h1>Contrôle réception</h1>
      <p class="subtitle">{{ selectedCommande?.numero }} — {{ getFournisseurNom(selectedCommande?.fournisseur_id || '') }}</p>

      <div class="compare-table">
        <div class="compare-header">
          <span class="col-name">Produit</span>
          <span class="col-qty">Commandé</span>
          <span class="col-qty">Reçu</span>
          <span class="col-status">Statut</span>
        </div>

        <div
          v-for="(ligne, idx) in receptionLignes"
          :key="idx"
          class="compare-row"
          :class="{ anomalie: ligne.anomalie_type }"
        >
          <span class="col-name">{{ ligne.designation }}</span>
          <span class="col-qty">{{ ligne.quantite_attendue }}</span>
          <span class="col-qty">
            <input
              v-model.number="ligne.quantite_recue"
              type="number"
              inputmode="numeric"
              min="0"
              class="qty-input-sm"
              @change="detectAnomalie(ligne)"
            />
          </span>
          <span class="col-status">
            <select v-model="ligne.anomalie_type" class="anomalie-select">
              <option :value="null">OK</option>
              <option value="manquant">Manquant</option>
              <option value="quantite">Quantité</option>
              <option value="casse">Cassé</option>
              <option value="substitue">Substitué</option>
              <option value="qualite">Qualité</option>
              <option value="prix">Prix</option>
              <option value="non_commande">Non commandé</option>
            </select>
          </span>
        </div>
      </div>

      <div v-if="hasAnomalies" class="anomalie-summary">
        {{ receptionLignes.filter(l => l.anomalie_type).length }} anomalie(s) détectée(s)
      </div>

      <div class="actions-bar">
        <button
          v-if="isManagerOrAbove"
          class="btn-primary"
          @click="handleValidate"
          :disabled="validating"
        >
          {{ validating ? 'Validation...' : hasAnomalies ? 'Valider avec anomalies' : 'Valider la réception' }}
        </button>
      </div>
    </div>

    <!-- Step 4: Done -->
    <div v-else-if="step === 'validate'">
      <div class="success-screen">
        <div class="success-icon">✅</div>
        <h2>Réception validée</h2>
        <p>{{ selectedCommande?.numero }} — Les stocks ont été mis à jour.</p>
        <button class="btn-primary" @click="reset">Nouvelle réception</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
h1 { font-size: 28px; margin-bottom: 8px; }
h2 { font-size: 22px; margin-bottom: 16px; }
.subtitle { color: var(--text-secondary); margin-bottom: 20px; font-size: 16px; }

.btn-back {
  border: none;
  background: none;
  font-size: 16px;
  color: var(--color-primary);
  cursor: pointer;
  padding: 0;
  margin-bottom: 12px;
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

.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-secondary {
  background: var(--bg-surface);
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 14px 20px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
}

.empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 60px 20px;
}

/* Select order */
.commande-select-list { display: flex; flex-direction: column; gap: 10px; }
.cmd-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 16px 20px;
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  cursor: pointer;
  box-shadow: 0 1px 2px rgba(0,0,0,0.04);
}
.cmd-card:active { background: var(--bg-hover); }
.cmd-numero { font-family: monospace; font-weight: 700; }
.cmd-fournisseur { font-size: 18px; font-weight: 600; flex: 1; }
.cmd-date { font-size: 14px; color: var(--text-tertiary); }

/* Photo */
.photo-section { margin-top: 20px; }
.capture-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 200px;
  border: 3px dashed var(--border);
  border-radius: var(--radius-lg);
  font-size: 18px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  background: var(--bg-surface);
}
.photo-preview img {
  width: 100%;
  max-height: 400px;
  object-fit: contain;
  border-radius: var(--radius-md);
  margin-bottom: 16px;
}
.photo-actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

/* Compare table */
.compare-table { margin-top: 16px; }
.compare-header {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  gap: 8px;
  padding: 12px 16px;
  font-size: 13px;
  font-weight: 700;
  color: var(--text-tertiary);
  text-transform: uppercase;
}
.compare-row {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  gap: 8px;
  padding: 12px 16px;
  background: var(--bg-surface);
  border-radius: var(--radius-sm);
  margin-bottom: 4px;
  align-items: center;
}
.compare-row.anomalie {
  border-left: 4px solid var(--color-danger);
}
.col-name { font-weight: 600; font-size: 15px; }
.col-qty { font-size: 16px; text-align: center; }
.qty-input-sm {
  width: 72px;
  height: 44px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  text-align: center;
  font-size: 16px;
  font-weight: 700;
}
.anomalie-select {
  height: 44px;
  border: 2px solid var(--border);
  border-radius: var(--radius-sm);
  font-size: 14px;
  padding: 0 8px;
  width: 100%;
}
.anomalie-summary {
  margin-top: 16px;
  padding: 12px 16px;
  background: #fef2f2;
  color: var(--color-danger);
  border-radius: var(--radius-md);
  font-weight: 600;
}
.actions-bar {
  margin-top: 24px;
  display: flex;
  justify-content: flex-end;
  gap: 12px;
}

/* Success */
.success-screen {
  text-align: center;
  padding: 80px 20px;
}
.success-icon { font-size: 64px; margin-bottom: 16px; }
.success-screen h2 { font-size: 28px; }
.success-screen p { color: var(--text-secondary); margin-bottom: 32px; }
</style>
