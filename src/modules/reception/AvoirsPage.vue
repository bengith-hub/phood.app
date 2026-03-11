<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuth } from '@/composables/useAuth'
import { useFournisseursStore } from '@/stores/fournisseurs'
import { useCommandesStore } from '@/stores/commandes'
import { restCall } from '@/lib/rest-client'
import { loadConfig } from '@/lib/create-notification'
import { getEtablissement, emailSubjectPrefix, emailFooter } from '@/lib/email-templates'
import type { Avoir, StatutAvoir, Config } from '@/types/database'

const { isManagerOrAbove } = useAuth()
const fournisseursStore = useFournisseursStore()
const commandesStore = useCommandesStore()

const avoirs = ref<Avoir[]>([])
const loading = ref(false)
const statutFilter = ref<StatutAvoir | ''>('')
const selectedAvoir = ref<Avoir | null>(null)
const config = ref<Config | null>(null)
const relanceLoading = ref(false)

const STATUT_CONFIG: Record<StatutAvoir, { label: string; color: string }> = {
  en_attente: { label: 'En attente', color: '#9CA3AF' },
  envoyee: { label: 'Envoyee', color: '#3B82F6' },
  relancee: { label: 'Relancee', color: '#F59E0B' },
  acceptee: { label: 'Acceptee', color: '#22C55E' },
  refusee: { label: 'Refusee', color: '#EF4444' },
  expiree: { label: 'Expiree', color: '#6B7280' },
}

const filtered = computed(() => {
  if (!statutFilter.value) return avoirs.value
  return avoirs.value.filter(a => a.statut === statutFilter.value)
})

function getFournisseurNom(id: string) {
  return fournisseursStore.getById(id)?.nom || '—'
}

function getCommandeNumero(id: string | null) {
  if (!id) return '—'
  return commandesStore.getById(id)?.numero || '—'
}

function formatDate(d: string | null) {
  if (!d) return '—'
  return new Date(d).toLocaleDateString('fr-FR', { day: '2-digit', month: 'short', year: 'numeric' })
}

function formatMontant(n: number) {
  return `${n.toFixed(2)} €`
}

function daysSince(d: string) {
  return Math.floor((Date.now() - new Date(d).getTime()) / 86400000)
}

async function fetchAvoirs() {
  loading.value = true
  try {
    avoirs.value = await restCall<Avoir[]>('GET', 'avoirs?select=*&order=created_at.desc')
  } catch (e) {
    console.error('Failed to fetch avoirs:', e)
  } finally {
    loading.value = false
  }
}

async function updateStatut(avoir: Avoir, newStatut: StatutAvoir) {
  const updates: Record<string, unknown> = { statut: newStatut }
  if (newStatut === 'acceptee' || newStatut === 'refusee') {
    updates.date_reponse = new Date().toISOString()
  }
  try {
    await restCall('PATCH', `avoirs?id=eq.${avoir.id}`, updates)

    // If accepted/refused, close the order
    if ((newStatut === 'acceptee' || newStatut === 'refusee') && avoir.commande_id) {
      await commandesStore.updateStatut(avoir.commande_id, 'cloturee')
    }

    await fetchAvoirs()
    selectedAvoir.value = null
  } catch (e) {
    console.error('Failed to update avoir:', e)
    alert('Erreur lors de la mise a jour')
  }
}

async function sendRelance(avoir: Avoir) {
  relanceLoading.value = true
  try {
    const fournisseur = fournisseursStore.getById(avoir.fournisseur_id)
    if (!fournisseur?.email_commande) {
      alert('Pas d\'email fournisseur configure')
      return
    }

    const commandeNum = getCommandeNumero(avoir.commande_id)
    const today = new Date().toLocaleDateString('fr-FR')

    // Build relance email
    const emailHtml = buildRelanceEmailHtml(avoir, fournisseur.nom, commandeNum, today)

    await fetch('/.netlify/functions/send-email', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        to: fournisseur.email_commande,
        cc: config.value?.destinataires_email_avoir || [],
        subject: `${emailSubjectPrefix(getEtablissement(config.value), "RELANCE Demande d'avoir")} | ${commandeNum}`,
        html: emailHtml,
      }),
    })

    await restCall('PATCH', `avoirs?id=eq.${avoir.id}`, {
      statut: 'relancee',
      date_relance: new Date().toISOString(),
    })

    await fetchAvoirs()
    selectedAvoir.value = null
  } catch (e) {
    console.error('Relance failed:', e)
    alert('Erreur lors de l\'envoi de la relance')
  } finally {
    relanceLoading.value = false
  }
}

function buildRelanceEmailHtml(avoir: Avoir, _fournisseurNom: string, commandeNum: string, _date: string): string {
  const lignesHtml = (avoir.lignes_avoir || []).map(l => `
    <tr>
      <td style="padding:8px;border:1px solid #ddd;">${l.designation}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:center;">${l.quantite_commandee}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:center;">${l.quantite_recue}</td>
      <td style="padding:8px;border:1px solid #ddd;">${l.anomalie_type}</td>
      <td style="padding:8px;border:1px solid #ddd;text-align:right;">${l.balance.toFixed(2)} €</td>
    </tr>
  `).join('')

  return `
    <div style="font-family:sans-serif;max-width:700px;margin:0 auto;">
      <h2 style="color:#E85D2C;">RELANCE — Demande d'avoir</h2>
      <p>Bonjour,</p>
      <p>Nous n'avons pas recu de reponse a notre demande d'avoir du <strong>${formatDate(avoir.date_envoi)}</strong> concernant la commande <strong>${commandeNum}</strong>.</p>
      <p>Nous vous rappelons les anomalies constatees :</p>
      <table style="border-collapse:collapse;width:100%;margin:16px 0;">
        <thead>
          <tr style="background:#f3f4f6;">
            <th style="padding:8px;border:1px solid #ddd;text-align:left;">Produit</th>
            <th style="padding:8px;border:1px solid #ddd;">Cmd</th>
            <th style="padding:8px;border:1px solid #ddd;">Recu</th>
            <th style="padding:8px;border:1px solid #ddd;">Motif</th>
            <th style="padding:8px;border:1px solid #ddd;">Balance</th>
          </tr>
        </thead>
        <tbody>${lignesHtml}</tbody>
        <tfoot>
          <tr style="font-weight:bold;background:#fef2f2;">
            <td colspan="4" style="padding:8px;border:1px solid #ddd;">Total HT avoir demande</td>
            <td style="padding:8px;border:1px solid #ddd;text-align:right;">${avoir.montant_estime.toFixed(2)} €</td>
          </tr>
        </tfoot>
      </table>
      <p>Merci de nous faire un retour dans les plus brefs delais.</p>
      <hr style="border:none;border-top:1px solid #eee;margin:24px 0;">
      ${emailFooter(getEtablissement(config.value))}
    </div>
  `
}

onMounted(async () => {
  await Promise.all([
    fetchAvoirs(),
    fournisseursStore.fetchAll(),
    commandesStore.fetchAll(),
  ])
  config.value = await loadConfig()
})
</script>

<template>
  <div class="avoirs-page">
    <h1>Demandes d'avoir</h1>

    <div class="statut-filters">
      <button
        class="filter-btn"
        :class="{ active: !statutFilter }"
        @click="statutFilter = ''"
      >
        Toutes ({{ avoirs.length }})
      </button>
      <button
        v-for="(conf, statut) in STATUT_CONFIG"
        :key="statut"
        class="filter-btn"
        :class="{ active: statutFilter === statut }"
        @click="statutFilter = statut as StatutAvoir"
      >
        {{ conf.label }}
      </button>
    </div>

    <div v-if="loading" class="loading">Chargement...</div>

    <div v-else-if="filtered.length === 0" class="empty">
      Aucune demande d'avoir{{ statutFilter ? ' avec ce statut' : '' }}
    </div>

    <div v-else class="avoir-list">
      <div
        v-for="a in filtered"
        :key="a.id"
        class="avoir-card"
        :class="{ expanded: selectedAvoir?.id === a.id }"
        @click="selectedAvoir = selectedAvoir?.id === a.id ? null : a"
      >
        <div class="card-top">
          <div class="card-info">
            <span class="card-fournisseur">{{ getFournisseurNom(a.fournisseur_id) }}</span>
            <span class="card-commande">{{ getCommandeNumero(a.commande_id) }}</span>
          </div>
          <span
            class="badge-statut"
            :style="{ background: STATUT_CONFIG[a.statut].color }"
          >
            {{ STATUT_CONFIG[a.statut].label }}
          </span>
        </div>

        <div class="card-bottom">
          <span class="card-montant">{{ formatMontant(a.montant_estime) }} HT</span>
          <span class="card-date">{{ formatDate(a.created_at) }}</span>
          <span v-if="a.statut === 'envoyee' || a.statut === 'en_attente'" class="card-age">
            {{ daysSince(a.created_at) }}j
          </span>
        </div>

        <!-- Expanded detail -->
        <div v-if="selectedAvoir?.id === a.id" class="card-detail" @click.stop>
          <div v-if="a.commentaire" class="detail-note">
            <strong>Commentaire :</strong> {{ a.commentaire }}
          </div>

          <!-- Anomaly lines table -->
          <div v-if="a.lignes_avoir && a.lignes_avoir.length > 0" class="detail-table-wrap">
            <table class="detail-table">
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
                <tr v-for="(l, idx) in a.lignes_avoir" :key="idx">
                  <td>{{ l.designation }}</td>
                  <td class="center">{{ l.quantite_commandee }}</td>
                  <td class="center">{{ l.quantite_recue }}</td>
                  <td>{{ l.anomalie_type }}</td>
                  <td class="right">{{ l.balance.toFixed(2) }} €</td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <td colspan="4"><strong>Total</strong></td>
                  <td class="right"><strong>{{ a.montant_estime.toFixed(2) }} €</strong></td>
                </tr>
              </tfoot>
            </table>
          </div>

          <div class="detail-dates">
            <span v-if="a.date_envoi">Envoi : {{ formatDate(a.date_envoi) }}</span>
            <span v-if="a.date_relance">Relance : {{ formatDate(a.date_relance) }}</span>
            <span v-if="a.date_reponse">Reponse : {{ formatDate(a.date_reponse) }}</span>
            <span v-if="!a.email_envoye" class="tag-no-email">Sans email</span>
          </div>

          <!-- Actions for manager+ -->
          <div v-if="isManagerOrAbove" class="detail-actions">
            <template v-if="a.statut === 'envoyee' || a.statut === 'en_attente'">
              <button
                class="btn-action btn-relance"
                @click.stop="sendRelance(a)"
                :disabled="relanceLoading"
              >
                {{ relanceLoading ? 'Envoi...' : 'Relancer' }}
              </button>
              <button
                class="btn-action btn-accept"
                @click.stop="updateStatut(a, 'acceptee')"
              >
                Accepter
              </button>
              <button
                class="btn-action btn-refuse"
                @click.stop="updateStatut(a, 'refusee')"
              >
                Refuser
              </button>
            </template>
            <template v-else-if="a.statut === 'relancee'">
              <button
                class="btn-action btn-accept"
                @click.stop="updateStatut(a, 'acceptee')"
              >
                Accepter
              </button>
              <button
                class="btn-action btn-refuse"
                @click.stop="updateStatut(a, 'refusee')"
              >
                Refuser
              </button>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
h1 { font-size: 28px; margin-bottom: 16px; }

.statut-filters {
  display: flex;
  gap: 6px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 4px;
  margin-bottom: 20px;
}

.filter-btn {
  flex-shrink: 0;
  height: 44px;
  padding: 0 14px;
  border: 2px solid var(--border);
  border-radius: 22px;
  background: var(--bg-surface);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  white-space: nowrap;
}
.filter-btn.active {
  background: var(--color-primary);
  border-color: var(--color-primary);
  color: white;
}

.loading, .empty {
  text-align: center;
  color: var(--text-tertiary);
  padding: 60px 20px;
  font-size: 16px;
}

.avoir-list {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.avoir-card {
  background: var(--bg-surface);
  border-radius: var(--radius-md);
  padding: 16px 20px;
  cursor: pointer;
  box-shadow: 0 1px 2px rgba(0,0,0,0.04);
  border: 1px solid var(--border);
  transition: border-color 0.15s;
}
.avoir-card.expanded {
  border-color: var(--color-primary);
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}
.card-info { display: flex; flex-direction: column; gap: 2px; }
.card-fournisseur { font-size: 18px; font-weight: 600; }
.card-commande { font-size: 14px; color: var(--text-secondary); font-family: monospace; }

.badge-statut {
  padding: 3px 10px;
  border-radius: 10px;
  color: white;
  font-size: 12px;
  font-weight: 700;
  flex-shrink: 0;
}

.card-bottom {
  display: flex;
  gap: 16px;
  font-size: 14px;
  color: var(--text-secondary);
  align-items: center;
}
.card-montant {
  font-weight: 700;
  color: var(--text-primary);
  font-size: 16px;
}
.card-age {
  background: #fef2f2;
  color: #ef4444;
  padding: 2px 8px;
  border-radius: 8px;
  font-weight: 600;
  font-size: 13px;
}

/* Detail section */
.card-detail {
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid var(--border);
}

.detail-note {
  margin-bottom: 12px;
  font-size: 15px;
  color: var(--text-secondary);
  background: var(--bg-main);
  padding: 10px 14px;
  border-radius: var(--radius-sm);
}

.detail-table-wrap {
  overflow-x: auto;
  margin-bottom: 12px;
}

.detail-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 14px;
}
.detail-table th, .detail-table td {
  padding: 8px 10px;
  border: 1px solid var(--border);
  text-align: left;
}
.detail-table th {
  background: var(--bg-main);
  font-weight: 700;
  font-size: 12px;
  text-transform: uppercase;
  color: var(--text-tertiary);
}
.detail-table .center { text-align: center; }
.detail-table .right { text-align: right; }
.detail-table tfoot td {
  background: #fef2f2;
}

.detail-dates {
  display: flex;
  gap: 16px;
  font-size: 13px;
  color: var(--text-tertiary);
  margin-bottom: 12px;
  flex-wrap: wrap;
}
.tag-no-email {
  background: #e5e7eb;
  color: #374151;
  padding: 2px 8px;
  border-radius: 6px;
  font-weight: 600;
}

.detail-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.btn-action {
  height: 48px;
  padding: 0 20px;
  border: none;
  border-radius: var(--radius-md);
  font-size: 15px;
  font-weight: 700;
  cursor: pointer;
}
.btn-action:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-relance { background: #FEF3C7; color: #92400E; }
.btn-accept { background: #D1FAE5; color: #065F46; }
.btn-refuse { background: #FEE2E2; color: #991B1B; }
</style>
