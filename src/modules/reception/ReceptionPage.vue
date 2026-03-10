<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useCommandesStore } from '@/stores/commandes'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useMercurialeStore } from '@/stores/mercuriale'
import { useAuth } from '@/composables/useAuth'
import { restCall, storageUpload } from '@/lib/rest-client'
import { compressImage, blobToBase64 } from '@/lib/image-compress'
import { createNotificationForAdmins, loadConfig } from '@/lib/create-notification'
import type { Commande, CommandeLigne, AnomalieType, AvoirLigne } from '@/types/database'

const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()
const mercurialeStore = useMercurialeStore()
const { user, isManagerOrAbove } = useAuth()

// Steps: select → photo → compare → (avoir if anomalies) → validate
type Step = 'select' | 'photo' | 'compare' | 'avoir' | 'validate'
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

// Avoir (credit note) state
const avoirComment = ref('')
const avoirSending = ref(false)
const avoirPhotos = ref<{ blob: Blob; preview: string }[]>([])

const anomalieLines = computed(() =>
  receptionLignes.value.filter(l => l.anomalie_type !== null)
)

const avoirLignes = computed<AvoirLigne[]>(() =>
  anomalieLines.value.map(l => {
    const merc = mercurialeStore.getById(l.mercuriale_id)
    const prixBc = merc?.prix_unitaire_ht || 0
    const prixBl = l.prix_bl || prixBc
    const ecartQty = l.quantite_attendue - l.quantite_recue
    const balance = ecartQty * prixBc
    return {
      designation: l.designation,
      sku: merc?.ref_fournisseur || null,
      quantite_commandee: l.quantite_attendue,
      quantite_recue: l.quantite_recue,
      prix_unitaire_bc: prixBc,
      prix_unitaire_bl: prixBl,
      anomalie_type: l.anomalie_type!,
      anomalie_detail: l.anomalie_detail,
      balance: Math.abs(balance),
    }
  })
)

const avoirTotal = computed(() =>
  avoirLignes.value.reduce((sum, l) => sum + l.balance, 0)
)

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

  // If anomalies exist, go to avoir step instead of direct validation
  if (hasAnomalies.value) {
    step.value = 'avoir'
    return
  }

  if (!confirm('Valider la réception ?\nLes stocks seront mis à jour.')) return
  await performValidation(false)
}

/**
 * Core validation logic: creates reception, updates stocks, detects prices.
 * Called after avoir decision (send/skip) or direct validation (no anomalies).
 */
async function performValidation(withAvoir: boolean) {
  if (!selectedCommande.value || !user.value) return

  validating.value = true
  try {
    // Upload BL photo if exists
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
    const newStatut = withAvoir ? 'avoir_en_cours' : (hasAnomalies.value ? 'controlee' : 'validee')
    await commandesStore.updateStatut(selectedCommande.value.id, newStatut)

    // Increment stocks for accepted quantities
    for (const l of receptionLignes.value) {
      if (l.quantite_acceptee > 0) {
        const merc = mercurialeStore.getById(l.mercuriale_id)
        if (merc?.ingredient_restaurant_id) {
          await restCall('POST', 'rpc/increment_stock', {
            p_ingredient_id: merc.ingredient_restaurant_id,
            p_quantite: l.quantite_acceptee,
          })
        }
      }
    }

    // Detect price changes and create notifications
    await detectPriceChanges(receptionLignes.value)

    // Create avoir record if requested
    if (withAvoir) {
      // Upload anomaly photos
      const uploadedPhotos: string[] = []
      for (const photo of avoirPhotos.value) {
        try {
          const fileName = `avoir_${selectedCommande.value.numero}_${Date.now()}_${uploadedPhotos.length}.jpg`
          const result = await storageUpload('anomalies', fileName, photo.blob, { contentType: 'image/jpeg' })
          uploadedPhotos.push(result.path)
        } catch {
          console.warn('Anomaly photo upload failed, continuing...')
        }
      }

      await restCall('POST', 'avoirs', {
        reception_id: reception.id,
        fournisseur_id: selectedCommande.value.fournisseur_id,
        commande_id: selectedCommande.value.id,
        montant_estime: avoirTotal.value,
        statut: 'en_attente',
        commentaire: avoirComment.value || null,
        lignes_avoir: avoirLignes.value,
        photos_anomalies: uploadedPhotos,
      }, { single: true })
    }

    step.value = 'validate'
  } catch (e) {
    console.error('Validation failed:', e)
    alert('Erreur lors de la validation')
  } finally {
    validating.value = false
  }
}

/**
 * Send avoir email to supplier then validate reception.
 */
async function handleAvoirSendEmail() {
  if (!selectedCommande.value) return

  const fournisseur = fournisseursStore.getById(selectedCommande.value.fournisseur_id)
  if (!fournisseur?.email_commande) {
    alert('Aucun email fournisseur configure. Utilisez "Valider sans envoyer".')
    return
  }

  avoirSending.value = true
  try {
    const config = await loadConfig()
    const today = new Date().toLocaleDateString('fr-FR')
    const commandeNum = selectedCommande.value.numero

    // Build email HTML
    const emailHtml = buildAvoirEmailHtml(commandeNum, fournisseur.nom, today)

    await fetch('/.netlify/functions/send-email', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        to: fournisseur.email_commande,
        cc: config?.destinataires_email_avoir || [],
        subject: `${today} | Demande d'avoir | Phood | Begles | ${commandeNum}`,
        html: emailHtml,
      }),
    })

    // Perform validation with avoir
    await performValidation(true)

    // Update avoir to envoyee status with email flag
    // Find the just-created avoir and update it
    const avoirs = await restCall<{ id: string }[]>(
      'GET',
      `avoirs?commande_id=eq.${selectedCommande.value.id}&select=id&order=created_at.desc&limit=1`
    )
    if (avoirs.length > 0) {
      await restCall('PATCH', `avoirs?id=eq.${avoirs[0]!.id}`, {
        statut: 'envoyee',
        date_envoi: new Date().toISOString(),
        email_envoye: true,
      })
    }
  } catch (e) {
    console.error('Avoir email send failed:', e)
    alert('Erreur lors de l\'envoi. Vous pouvez reessayer ou valider sans envoyer.')
  } finally {
    avoirSending.value = false
  }
}

/**
 * Validate avoir without sending email (internal tracking only).
 */
async function handleAvoirSkipEmail() {
  if (!confirm('Valider l\'avoir sans envoyer d\'email ?\nL\'anomalie sera tracee dans l\'application.')) return
  await performValidation(true)
}

function buildAvoirEmailHtml(commandeNum: string, _fournisseurNom: string, _date: string): string {
  const lignesHtml = avoirLignes.value.map(l => `
    <tr>
      <td style="padding:8px;border:1px solid #ddd;">${l.designation}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:center;">${l.sku || '—'}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:center;">${l.quantite_commandee}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:center;">${l.quantite_recue}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:right;">${l.prix_unitaire_bc?.toFixed(2) || '—'} €</td>
      <td style="padding:8px;border:1px solid #ddd;">${l.anomalie_type}${l.anomalie_detail ? ' — ' + l.anomalie_detail : ''}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:right;">${l.balance.toFixed(2)} €</td>
    </tr>
  `).join('')

  const commentHtml = avoirComment.value
    ? `<p style="margin-top:16px;"><strong>Commentaire :</strong> ${avoirComment.value}</p>`
    : ''

  return `
    <div style="font-family:sans-serif;max-width:750px;margin:0 auto;">
      <h2 style="color:#E85D2C;">Demande d'avoir — ${commandeNum}</h2>
      <p>Bonjour,</p>
      <p>Suite a la reception de la commande <strong>${commandeNum}</strong>, nous avons constate les anomalies suivantes :</p>
      <table style="border-collapse:collapse;width:100%;margin:16px 0;">
        <thead>
          <tr style="background:#f3f4f6;">
            <th style="padding:8px;border:1px solid #ddd;text-align:left;">Produit</th>
            <th style="padding:8px;border:1px solid #ddd;">SKU</th>
            <th style="padding:8px;border:1px solid #ddd;">Cmd</th>
            <th style="padding:8px;border:1px solid #ddd;">Recu</th>
            <th style="padding:8px;border:1px solid #ddd;">Prix BC</th>
            <th style="padding:8px;border:1px solid #ddd;">Motif</th>
            <th style="padding:8px;border:1px solid #ddd;">Balance</th>
          </tr>
        </thead>
        <tbody>${lignesHtml}</tbody>
        <tfoot>
          <tr style="font-weight:bold;background:#fef2f2;">
            <td colspan="6" style="padding:8px;border:1px solid #ddd;">Total HT de l'avoir demande</td>
            <td style="padding:8px;border:1px solid #ddd;text-align:right;">${avoirTotal.value.toFixed(2)} €</td>
          </tr>
        </tfoot>
      </table>
      ${commentHtml}
      <p>Merci de bien vouloir traiter cette demande dans les meilleurs delais.</p>
      <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
      <p style="color:#888;font-size:13px;">Phood Restaurant — Centre Commercial Rives d'Arcins — Begles<br/>team.begles@phood-restaurant.fr</p>
    </div>
  `
}

async function handleAnomalyPhotoCapture(event: Event) {
  const input = event.target as HTMLInputElement
  const file = input.files?.[0]
  if (!file) return
  const compressed = await compressImage(file)
  avoirPhotos.value.push({
    blob: compressed,
    preview: URL.createObjectURL(compressed),
  })
  input.value = '' // allow re-capture
}

/**
 * Compare BL prices with mercuriale prices. If gap exceeds threshold:
 * 1. Record in historique_prix
 * 2. Update mercuriale.prix_unitaire_ht (BL price is the truth)
 * 3. Create prix_ecart notification for admins
 */
async function detectPriceChanges(lignes: ReceptionLigneEdit[]) {
  try {
    const config = await loadConfig()
    const seuil = config?.seuil_ecart_prix_pct ?? 10

    const alertLines: { designation: string; ancien: number; nouveau: number; ecart: number }[] = []

    for (const l of lignes) {
      if (l.prix_bl == null || l.prix_bl <= 0) continue

      const merc = mercurialeStore.getById(l.mercuriale_id)
      if (!merc || !merc.prix_unitaire_ht || merc.prix_unitaire_ht <= 0) continue

      const ecartPct = Math.abs(l.prix_bl - merc.prix_unitaire_ht) / merc.prix_unitaire_ht * 100

      // Always record price history if price changed
      if (Math.abs(l.prix_bl - merc.prix_unitaire_ht) > 0.01) {
        await restCall('POST', 'historique_prix', {
          mercuriale_id: l.mercuriale_id,
          prix_ancien: merc.prix_unitaire_ht,
          prix_nouveau: l.prix_bl,
          source: 'bl',
          valide_par: user.value?.id || null,
        }).catch(() => {})

        // Update mercuriale price (BL = truth)
        await restCall('PATCH', `mercuriale?id=eq.${l.mercuriale_id}`, {
          prix_unitaire_ht: l.prix_bl,
        }).catch(() => {})
      }

      if (ecartPct > seuil) {
        alertLines.push({
          designation: l.designation,
          ancien: merc.prix_unitaire_ht,
          nouveau: l.prix_bl,
          ecart: Math.round(ecartPct),
        })
      }
    }

    if (alertLines.length > 0) {
      const first = alertLines[0]!
      const titre = alertLines.length === 1
        ? `Prix modifié : ${first.designation}`
        : `${alertLines.length} écarts de prix détectés`
      const message = alertLines
        .map(a => `${a.designation} : ${a.ancien.toFixed(2)}€ → ${a.nouveau.toFixed(2)}€ (${a.ecart > 0 ? '+' : ''}${a.ecart}%)`)
        .join('\n')
      await createNotificationForAdmins('prix_ecart', titre, message)
    }
  } catch (e) {
    console.error('Price change detection failed:', e)
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
  avoirComment.value = ''
  avoirPhotos.value = []
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

    <!-- Step 4: Avoir (credit note request) -->
    <div v-else-if="step === 'avoir'">
      <button class="btn-back" @click="step = 'compare'">← Controle</button>
      <h1>Demande d'avoir</h1>
      <p class="subtitle">{{ selectedCommande?.numero }} — {{ getFournisseurNom(selectedCommande?.fournisseur_id || '') }}</p>

      <!-- Anomaly summary table -->
      <div class="avoir-table-wrap">
        <table class="avoir-table">
          <thead>
            <tr>
              <th>Produit</th>
              <th>Cmd</th>
              <th>Recu</th>
              <th>Motif</th>
              <th>Balance</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(l, idx) in avoirLignes" :key="idx">
              <td>{{ l.designation }}</td>
              <td class="center">{{ l.quantite_commandee }}</td>
              <td class="center">{{ l.quantite_recue }}</td>
              <td>{{ l.anomalie_type }}</td>
              <td class="right">{{ l.balance.toFixed(2) }} €</td>
            </tr>
          </tbody>
          <tfoot>
            <tr>
              <td colspan="4"><strong>Total HT avoir</strong></td>
              <td class="right"><strong>{{ avoirTotal.toFixed(2) }} €</strong></td>
            </tr>
          </tfoot>
        </table>
      </div>

      <!-- Anomaly photos -->
      <div class="avoir-photos">
        <h3>Photos justificatives</h3>
        <div class="photos-grid">
          <div v-for="(photo, idx) in avoirPhotos" :key="idx" class="photo-thumb">
            <img :src="photo.preview" alt="Anomalie" />
            <button class="photo-remove" @click="avoirPhotos.splice(idx, 1)">×</button>
          </div>
          <label class="photo-add-btn">
            + Photo
            <input
              type="file"
              accept="image/*"
              capture="environment"
              @change="handleAnomalyPhotoCapture"
              class="visually-hidden"
            />
          </label>
        </div>
      </div>

      <!-- Comment -->
      <div class="avoir-comment">
        <h3>Commentaire (optionnel)</h3>
        <textarea
          v-model="avoirComment"
          placeholder="Accord verbal avec le livreur, details supplementaires..."
          rows="3"
          class="comment-textarea"
        ></textarea>
      </div>

      <!-- Actions -->
      <div class="avoir-actions">
        <button
          class="btn-primary btn-send"
          @click="handleAvoirSendEmail"
          :disabled="avoirSending || validating"
        >
          {{ avoirSending ? 'Envoi...' : 'Envoyer au fournisseur' }}
        </button>
        <button
          class="btn-secondary"
          @click="handleAvoirSkipEmail"
          :disabled="avoirSending || validating"
        >
          {{ validating ? 'Validation...' : 'Valider sans envoyer' }}
        </button>
      </div>
    </div>

    <!-- Step 5: Done -->
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

/* Avoir step */
.avoir-table-wrap { overflow-x: auto; margin-bottom: 20px; }
.avoir-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 15px;
}
.avoir-table th, .avoir-table td {
  padding: 10px 12px;
  border: 1px solid var(--border);
  text-align: left;
}
.avoir-table th {
  background: var(--bg-main);
  font-weight: 700;
  font-size: 12px;
  text-transform: uppercase;
  color: var(--text-tertiary);
}
.avoir-table .center { text-align: center; }
.avoir-table .right { text-align: right; }
.avoir-table tfoot td { background: #fef2f2; }

.avoir-photos { margin-bottom: 20px; }
.avoir-photos h3 { font-size: 16px; margin-bottom: 10px; }
.photos-grid {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.photo-thumb {
  position: relative;
  width: 80px;
  height: 80px;
  border-radius: var(--radius-sm);
  overflow: hidden;
}
.photo-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.photo-remove {
  position: absolute;
  top: 2px;
  right: 2px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: rgba(0,0,0,0.6);
  color: white;
  border: none;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}
.photo-add-btn {
  width: 80px;
  height: 80px;
  border: 2px dashed var(--border);
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
  color: var(--text-secondary);
  cursor: pointer;
  background: var(--bg-surface);
}

.avoir-comment { margin-bottom: 20px; }
.avoir-comment h3 { font-size: 16px; margin-bottom: 8px; }
.comment-textarea {
  width: 100%;
  border: 2px solid var(--border);
  border-radius: var(--radius-md);
  padding: 12px 14px;
  font-size: 16px;
  font-family: inherit;
  resize: vertical;
  background: var(--bg-surface);
}
.comment-textarea:focus {
  outline: none;
  border-color: var(--color-primary);
}

.avoir-actions {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}
.btn-send { flex: 1; min-width: 200px; }

.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  border: 0;
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
