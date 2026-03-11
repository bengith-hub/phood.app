<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { restCall, storageUpload, storagePublicUrl } from '@/lib/rest-client'
import { useCommandesStore } from '@/stores/commandes'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useMercurialeStore } from '@/stores/mercuriale'
import { generateCommandePdf } from '@/lib/pdf-commande'
import { getEtablissement, emailSubjectPrefix, emailFooter } from '@/lib/email-templates'
import EmailTagInput from '@/components/EmailTagInput.vue'
import type { Config, Commande, CommandeLigne, Fournisseur, EtablissementInfo } from '@/types/database'

const route = useRoute()
const router = useRouter()
const commandesStore = useCommandesStore()
const fournisseursStore = useFournisseursStore()
const mercurialeStore = useMercurialeStore()

const commandeId = computed(() => route.params.id as string)

const commande = ref<Commande | null>(null)
const lignes = ref<CommandeLigne[]>([])
const fournisseur = ref<Fournisseur | null>(null)
const config = ref<Config | null>(null)
const loading = ref(true)

// Email form
const destinataires = ref<string[]>([])
const copies = ref<string[]>([])
const commentaire = ref('')

// Photo attachments
const photos = ref<{ file: File; preview: string }[]>([])
const photoInputRef = ref<HTMLInputElement | null>(null)

// Send state
const sending = ref(false)
const sendError = ref<string | null>(null)

// PDF preview
const pdfPreviewUrl = ref<string | null>(null)
const pdfGenerating = ref(false)

const etablissement = computed<EtablissementInfo>(() => getEtablissement(config.value))

const nbArticles = computed(() => lignes.value.length)
const totalHT = computed(() => commande.value?.montant_total_ht || 0)

function toLocalDateStr(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

async function generatePdfPreview() {
  if (!commande.value || !fournisseur.value) return
  pdfGenerating.value = true
  try {
    const commandeData: Commande = {
      ...commande.value,
      date_commande: commande.value.date_commande || toLocalDateStr(new Date()),
    }
    const pdf = await generateCommandePdf({
      commande: commandeData,
      lignes: lignes.value,
      fournisseur: fournisseur.value,
      getMercuriale: (id: string) => mercurialeStore.getById(id),
      etablissement: etablissement.value,
      commentaire: commentaire.value || undefined,
    })
    // Revoke previous URL
    if (pdfPreviewUrl.value) URL.revokeObjectURL(pdfPreviewUrl.value)
    pdfPreviewUrl.value = pdf.output('bloburl') as unknown as string
  } catch (e) {
    console.error('PDF preview generation error:', e)
  } finally {
    pdfGenerating.value = false
  }
}

// Debounced regeneration when commentaire changes
let commentaireTimer: ReturnType<typeof setTimeout> | null = null
watch(commentaire, () => {
  if (commentaireTimer) clearTimeout(commentaireTimer)
  commentaireTimer = setTimeout(() => generatePdfPreview(), 800)
})

onUnmounted(() => {
  if (pdfPreviewUrl.value) URL.revokeObjectURL(pdfPreviewUrl.value)
  if (commentaireTimer) clearTimeout(commentaireTimer)
})

onMounted(async () => {
  try {
    // Load data in parallel
    await Promise.all([
      commandesStore.fetchAll(),
      fournisseursStore.fetchAll(),
      mercurialeStore.fetchAll(),
    ])

    commande.value = commandesStore.getById(commandeId.value) || null
    if (!commande.value) {
      router.replace('/commandes')
      return
    }

    fournisseur.value = fournisseursStore.getById(commande.value.fournisseur_id) || null
    lignes.value = await commandesStore.fetchLignes(commandeId.value)

    // Load config
    const cfgData = await restCall<Config>('GET', 'config?select=*', undefined, { single: true })
    if (cfgData) config.value = cfgData

    // Pre-fill email recipients
    if (fournisseur.value?.email_commande) {
      destinataires.value = [fournisseur.value.email_commande]
    }
    const ccList: string[] = []
    if (fournisseur.value?.email_commande_bcc) ccList.push(fournisseur.value.email_commande_bcc)
    const etabEmail = getEtablissement(cfgData).email
    if (etabEmail && !ccList.includes(etabEmail)) ccList.push(etabEmail)
    copies.value = ccList

    // Generate initial PDF preview
    await generatePdfPreview()
  } catch (e) {
    console.error('CommandeRecapPage load error:', e)
  } finally {
    loading.value = false
  }
})

function addPhotos() {
  photoInputRef.value?.click()
}

function onPhotosSelected(e: Event) {
  const files = (e.target as HTMLInputElement).files
  if (!files) return
  for (const file of Array.from(files)) {
    if (file.type.startsWith('image/')) {
      photos.value.push({ file, preview: URL.createObjectURL(file) })
    }
  }
  // Reset input so same file can be re-selected
  if (photoInputRef.value) photoInputRef.value.value = ''
}

function removePhoto(index: number) {
  const photo = photos.value[index]
  if (photo) URL.revokeObjectURL(photo.preview)
  photos.value.splice(index, 1)
}

async function fileToBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => {
      const result = reader.result as string
      resolve(result.split(',')[1]!) // strip data:... prefix
    }
    reader.onerror = reject
    reader.readAsDataURL(file)
  })
}

async function handleEnvoyer() {
  if (!commande.value || !fournisseur.value || destinataires.value.length === 0) return

  sending.value = true
  sendError.value = null

  try {
    const etab = etablissement.value

    // Build commande data with current date
    const commandeData: Commande = {
      ...commande.value,
      date_commande: commande.value.date_commande || toLocalDateStr(new Date()),
    }

    // Generate PDF
    const pdf = await generateCommandePdf({
      commande: commandeData,
      lignes: lignes.value,
      fournisseur: fournisseur.value,
      getMercuriale: (id: string) => mercurialeStore.getById(id),
      etablissement: etab,
      commentaire: commentaire.value || undefined,
    })

    // Convert PDF to base64
    const pdfBase64 = pdf.output('datauristring').split(',')[1]!

    // Build attachments array
    const attachments: { filename: string; content: string; contentType: string }[] = [
      {
        filename: `${commandeData.numero}.pdf`,
        content: pdfBase64,
        contentType: 'application/pdf',
      },
    ]

    // Add photo attachments
    for (const photo of photos.value) {
      const base64 = await fileToBase64(photo.file)
      attachments.push({
        filename: photo.file.name,
        content: base64,
        contentType: photo.file.type,
      })
    }

    // Build email HTML
    const isModified = commande.value.statut !== 'brouillon'
    const subjectLabel = isModified ? 'Commande modifiée' : 'Nouvelle commande'
    const subject = `${emailSubjectPrefix(etab, subjectLabel)} | ${commandeData.numero}`

    const livraisonStr = commande.value.date_livraison_prevue
      ? new Date(commande.value.date_livraison_prevue).toLocaleDateString('fr-FR', { day: 'numeric', month: 'long', year: 'numeric' })
      : 'non précisée'

    const modifiedNote = isModified
      ? `<p style="background:#fef3cd;padding:10px;border-radius:6px;color:#856404;">⚠️ Cette commande <strong>annule et remplace</strong> la commande précédente ${commandeData.numero}.</p>`
      : ''

    const notesHtml = commentaire.value
      ? `<p><em>Notes : ${commentaire.value}</em></p>`
      : ''

    const html = `
      <div style="font-family: Arial, sans-serif; max-width: 600px;">
        <h2 style="color: #E85D2C;">${etab.nom} — ${etab.ville}</h2>
        <p>Bonjour,</p>
        ${modifiedNote}
        <p>Veuillez trouver ci-joint notre bon de commande <strong>${commandeData.numero}</strong>.</p>
        <table style="border-collapse: collapse; margin: 16px 0;">
          <tr><td style="padding: 4px 12px 4px 0; color: #666;">Livraison souhaitée :</td><td><strong>${livraisonStr}</strong></td></tr>
          <tr><td style="padding: 4px 12px 4px 0; color: #666;">Montant HT :</td><td><strong>${totalHT.value.toFixed(2)} €</strong></td></tr>
          <tr><td style="padding: 4px 12px 4px 0; color: #666;">Articles :</td><td><strong>${nbArticles.value}</strong></td></tr>
        </table>
        ${notesHtml}
        <p>Cordialement,<br/>L'équipe ${etab.nom}</p>
        ${emailFooter(etab)}
        <p style="font-size: 12px; color: #999;">Ce message a été envoyé automatiquement par PhoodApp.</p>
      </div>
    `

    // Build email payload
    const emailPayload: Record<string, unknown> = {
      to: destinataires.value,
      subject,
      html,
      attachments,
      from_name: etab.nom,
    }
    if (copies.value.length > 0) {
      emailPayload.cc = copies.value
    }

    // Send email
    const response = await fetch('/.netlify/functions/send-email', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(emailPayload),
    })

    if (!response.ok) {
      const errBody = await response.json().catch(() => ({ error: 'Erreur envoi email' }))
      throw new Error(errBody.error || `Email error ${response.status}`)
    }

    // Upload PDF to Supabase Storage
    try {
      const pdfBlob = pdf.output('blob')
      const pdfPath = `commandes/${commandeData.numero}.pdf`
      await storageUpload('pdfs', pdfPath, pdfBlob, {
        contentType: 'application/pdf',
        upsert: true,
      })
      const publicUrl = storagePublicUrl('pdfs', pdfPath)
      await commandesStore.updateCommande(commandeId.value, { pdf_url: publicUrl })
    } catch {
      console.warn('PDF upload to storage failed, continuing...')
    }

    // Update status to sent
    await commandesStore.updateStatut(commandeId.value, 'envoyee')
    router.push('/commandes')
  } catch (e: unknown) {
    sendError.value = e instanceof Error ? e.message : 'Erreur lors de l\'envoi'
    console.error('handleEnvoyer error:', e)
  } finally {
    sending.value = false
  }
}
</script>

<template>
  <div class="recap-page">
    <div v-if="loading" class="loading">Chargement...</div>

    <template v-else-if="commande && fournisseur">
      <div class="recap-layout">
        <!-- Left: Aperçu PDF -->
        <div class="recap-left">
          <h2>Aperçu du bon de commande</h2>
          <div class="recap-meta">
            <span class="recap-numero">{{ commande.numero }}</span>
            <span class="recap-sep">—</span>
            <span class="recap-fournisseur">{{ fournisseur.nom }}</span>
            <span class="recap-sep">—</span>
            <span class="recap-total">{{ totalHT.toFixed(2) }} EUR HT</span>
          </div>

          <div class="pdf-preview-container">
            <div v-if="pdfGenerating" class="pdf-loading">Génération du PDF...</div>
            <iframe
              v-else-if="pdfPreviewUrl"
              :src="pdfPreviewUrl"
              class="pdf-iframe"
              title="Aperçu du bon de commande PDF"
            />
            <div v-else class="pdf-loading">Chargement...</div>
          </div>
        </div>

        <!-- Right: Email form -->
        <div class="recap-right">
          <h2>Envoi de la commande par email</h2>

          <div class="field-group">
            <label>Destinataires <span class="required">*</span></label>
            <EmailTagInput
              v-model="destinataires"
              placeholder="Email du fournisseur..."
            />
          </div>

          <div class="field-group">
            <label>Copies (CC)</label>
            <EmailTagInput
              v-model="copies"
              placeholder="Ajouter un email en copie..."
            />
          </div>

          <div class="field-group">
            <label>Commentaire BDC</label>
            <textarea
              v-model="commentaire"
              rows="4"
              placeholder="Commentaire à inclure dans le bon de commande..."
              class="commentaire-input"
            />
          </div>

          <div class="field-group">
            <label>Photos jointes</label>
            <div class="photos-list">
              <div v-for="(photo, i) in photos" :key="i" class="photo-item">
                <img :src="photo.preview" :alt="photo.file.name" class="photo-thumb" />
                <span class="photo-name">{{ photo.file.name }}</span>
                <button type="button" class="photo-remove" @click="removePhoto(i)">&times;</button>
              </div>
              <button type="button" class="btn-add-photo" @click="addPhotos">
                + Ajouter des photos
              </button>
              <input
                ref="photoInputRef"
                type="file"
                accept="image/*"
                multiple
                class="hidden-input"
                @change="onPhotosSelected"
              />
            </div>
          </div>

          <div v-if="sendError" class="send-error">{{ sendError }}</div>

          <button
            class="btn-send"
            :disabled="sending || destinataires.length === 0"
            @click="handleEnvoyer"
          >
            {{ sending ? 'Envoi en cours...' : 'Envoyer la commande' }}
          </button>
        </div>
      </div>

      <!-- Back button -->
      <div class="recap-footer">
        <button class="btn-back" @click="router.push(`/commandes/${commandeId}`)">
          &larr; Retour au brouillon
        </button>
      </div>
    </template>
  </div>
</template>

<style scoped>
.recap-page {
  padding: 16px;
  max-width: 1200px;
  margin: 0 auto;
}

.loading {
  text-align: center;
  padding: 60px 0;
  font-size: 18px;
  color: var(--text-secondary, #4B5563);
}

.recap-layout {
  display: grid;
  grid-template-columns: 1fr 380px;
  gap: 24px;
  align-items: flex-start;
}

@media (max-width: 1000px) {
  .recap-layout {
    grid-template-columns: 1fr;
  }
  .pdf-iframe {
    height: 60vh;
  }
}

/* Left: Aperçu PDF */
.recap-left h2,
.recap-right h2 {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary, #1F2937);
  margin: 0 0 12px;
}

.recap-meta {
  font-size: 16px;
  color: var(--text-secondary, #4B5563);
  margin-bottom: 12px;
}
.recap-numero {
  font-weight: 700;
  color: var(--color-primary, #E85D2C);
}
.recap-sep {
  margin: 0 6px;
}
.recap-fournisseur {
  font-weight: 600;
}
.recap-total {
  font-weight: 700;
  color: var(--text-primary, #1F2937);
}

.pdf-preview-container {
  border: 1px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  overflow: hidden;
  background: #f5f5f5;
  min-height: 500px;
}

.pdf-iframe {
  width: 100%;
  height: 80vh;
  min-height: 500px;
  border: none;
  display: block;
}

.pdf-loading {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 300px;
  font-size: 16px;
  color: var(--text-secondary, #4B5563);
}

/* Right: Email form */
.recap-right {
  background: #fff;
  border: 1px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  padding: 20px;
  position: sticky;
  top: 80px;
}

.field-group {
  margin-bottom: 16px;
}

.field-group label {
  display: block;
  font-size: 15px;
  font-weight: 600;
  color: var(--text-primary, #1F2937);
  margin-bottom: 6px;
}

.required {
  color: #EF4444;
}

.commentaire-input {
  width: 100%;
  border: 1px solid var(--border, #D1D5DB);
  border-radius: var(--radius-sm, 8px);
  padding: 10px 12px;
  font-size: 15px;
  font-family: inherit;
  resize: vertical;
  min-height: 80px;
  background: #fff;
  color: var(--text-primary, #1F2937);
}
.commentaire-input:focus {
  outline: none;
  border-color: var(--color-primary, #E85D2C);
}

/* Photos */
.photos-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.photo-item {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 8px;
  background: #F9FAFB;
  border: 1px solid #E5E7EB;
  border-radius: 6px;
}

.photo-thumb {
  width: 40px;
  height: 40px;
  object-fit: cover;
  border-radius: 4px;
}

.photo-name {
  flex: 1;
  font-size: 13px;
  color: var(--text-secondary, #4B5563);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.photo-remove {
  width: 28px;
  height: 28px;
  border: none;
  background: #E5E7EB;
  border-radius: 50%;
  font-size: 18px;
  font-weight: 700;
  color: #6B7280;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0;
}
.photo-remove:hover {
  background: #EF4444;
  color: #fff;
}

.btn-add-photo {
  border: 1px dashed var(--border, #D1D5DB);
  background: transparent;
  border-radius: var(--radius-sm, 8px);
  padding: 10px;
  font-size: 14px;
  color: var(--text-secondary, #4B5563);
  cursor: pointer;
  text-align: center;
}
.btn-add-photo:hover {
  border-color: var(--color-primary, #E85D2C);
  color: var(--color-primary, #E85D2C);
}

.hidden-input {
  display: none;
}

.send-error {
  background: #FEE2E2;
  color: #991B1B;
  padding: 10px 14px;
  border-radius: 6px;
  font-size: 14px;
  margin-bottom: 12px;
}

.btn-send {
  width: 100%;
  padding: 14px;
  background: var(--color-primary, #E85D2C);
  color: #fff;
  border: none;
  border-radius: var(--radius-sm, 8px);
  font-size: 17px;
  font-weight: 700;
  cursor: pointer;
  min-height: 52px;
}
.btn-send:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Footer */
.recap-footer {
  margin-top: 20px;
  padding-top: 16px;
  border-top: 1px solid var(--border, #D1D5DB);
}

.btn-back {
  border: none;
  background: none;
  font-size: 16px;
  color: var(--color-primary, #E85D2C);
  cursor: pointer;
  padding: 8px 0;
  font-weight: 500;
}
</style>
