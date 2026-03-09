import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import { db } from '@/lib/dexie'
import type { FacturePennylane, AchatHorsCommande } from '@/types/database'

export type StatutRapprochement = FacturePennylane['statut_rapprochement']

export interface EcartFacture {
  facture: FacturePennylane
  commandeMontantHt: number
  ecartHt: number
  ecartPct: number
}

export const useFacturesStore = defineStore('factures', () => {
  const factures = ref<FacturePennylane[]>([])
  const achatsHorsCommande = ref<AchatHorsCommande[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  // --- Computed filters ---
  const nonRapprochees = computed(() =>
    factures.value.filter(f => f.statut_rapprochement === 'non_rapprochee')
  )
  const rapprochees = computed(() =>
    factures.value.filter(f => f.statut_rapprochement === 'rapprochee')
  )
  const ecarts = computed(() =>
    factures.value.filter(f => f.statut_rapprochement === 'ecart_detecte')
  )
  const depannages = computed(() =>
    factures.value.filter(f => f.statut_rapprochement === 'depannage')
  )

  // --- Monthly summary ---
  const currentMonthFactures = computed(() => {
    const now = new Date()
    const year = now.getFullYear()
    const month = now.getMonth()
    return factures.value.filter(f => {
      if (!f.date_facture) return false
      const d = new Date(f.date_facture)
      return d.getFullYear() === year && d.getMonth() === month
    })
  })

  const summaryMois = computed(() => {
    const mois = currentMonthFactures.value
    return {
      total: mois.length,
      rapprochees: mois.filter(f => f.statut_rapprochement === 'rapprochee').length,
      ecarts: mois.filter(f => f.statut_rapprochement === 'ecart_detecte').length,
      depannages: mois.filter(f => f.statut_rapprochement === 'depannage').length,
      totalHt: mois.reduce((s, f) => s + f.montant_ht, 0),
      totalTtc: mois.reduce((s, f) => s + f.montant_ttc, 0),
    }
  })

  // --- Fetch all data ---
  async function fetchAll() {
    loading.value = true
    error.value = null
    try {
      if (navigator.onLine) {
        const [facturesData, achatsData] = await Promise.all([
          restCall<FacturePennylane[]>('GET', 'factures_pennylane?select=*&order=date_facture.desc'),
          restCall<AchatHorsCommande[]>('GET', 'achats_hors_commande?select=*&order=date_achat.desc'),
        ])

        factures.value = facturesData
        achatsHorsCommande.value = achatsData

        await db.facturesPennylane.clear()
        await db.facturesPennylane.bulkPut(facturesData)
        await db.achatsHorsCommande.clear()
        await db.achatsHorsCommande.bulkPut(achatsData)
      } else {
        factures.value = await db.facturesPennylane.reverse().sortBy('date_facture')
        achatsHorsCommande.value = await db.achatsHorsCommande.reverse().sortBy('date_achat')
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement factures'
      factures.value = await db.facturesPennylane.reverse().sortBy('date_facture')
      achatsHorsCommande.value = await db.achatsHorsCommande.reverse().sortBy('date_achat')
    } finally {
      loading.value = false
    }
  }

  // --- Rapprochement: link invoice to a reception/BL ---
  async function rapprocher(factureId: string, receptionId: string) {
    const reception = await restCall<{ commande_id: string }>(
      'GET',
      `receptions?id=eq.${receptionId}&select=commande_id`,
      undefined,
      { single: true },
    )

    const commande = await restCall<{ montant_total_ht: number }>(
      'GET',
      `commandes?id=eq.${reception.commande_id}&select=montant_total_ht`,
      undefined,
      { single: true },
    )

    const facture = factures.value.find(f => f.id === factureId)
    if (!facture) throw new Error('Facture introuvable')

    const ecartPct = Math.abs(facture.montant_ht - commande.montant_total_ht) / commande.montant_total_ht * 100
    const statut: StatutRapprochement = ecartPct > 2 ? 'ecart_detecte' : 'rapprochee'

    await restCall('PATCH', `factures_pennylane?id=eq.${factureId}`, {
      reception_id: receptionId,
      statut_rapprochement: statut,
    })

    await fetchAll()
    return { statut, ecartPct }
  }

  // --- Detect depannage ---
  async function detecterDepannage() {
    const candidats = factures.value.filter(
      f => f.statut_rapprochement === 'non_rapprochee' && !f.reception_id
    )

    if (candidats.length === 0) return 0

    let count = 0
    for (const facture of candidats) {
      try {
        const matchingCommandes = await restCall<{ id: string }[]>(
          'GET',
          `commandes?fournisseur_id=eq.${facture.fournisseur_id || ''}&statut=in.(envoyee,receptionnee,controlee,validee,cloturee)&select=id&limit=1`,
        )

        if (!matchingCommandes || matchingCommandes.length === 0) {
          await restCall('PATCH', `factures_pennylane?id=eq.${facture.id}`, {
            statut_rapprochement: 'depannage',
          })
          count++

          const fournisseurNom = facture.fournisseur_id || 'Inconnu'
          await restCall('POST', 'achats_hors_commande', {
            facture_pennylane_id: facture.id,
            fournisseur_nom: fournisseurNom,
            montant_ht: facture.montant_ht,
            date_achat: facture.date_facture || new Date().toISOString().split('T')[0],
            description: `Achat dépannage détecté automatiquement (facture ${facture.numero || facture.pennylane_id})`,
          })
        }
      } catch {
        // Continue with other factures on error
      }
    }

    await fetchAll()
    return count
  }

  // --- Get ecarts ---
  async function getEcarts(): Promise<EcartFacture[]> {
    const results: EcartFacture[] = []

    const facturesAvecReception = factures.value.filter(f => f.reception_id)

    for (const facture of facturesAvecReception) {
      try {
        const reception = await restCall<{ commande_id: string } | null>(
          'GET',
          `receptions?id=eq.${facture.reception_id!}&select=commande_id`,
          undefined,
          { maybeSingle: true },
        )

        if (!reception) continue

        const commande = await restCall<{ montant_total_ht: number } | null>(
          'GET',
          `commandes?id=eq.${reception.commande_id}&select=montant_total_ht`,
          undefined,
          { maybeSingle: true },
        )

        if (!commande) continue

        const ecartHt = facture.montant_ht - commande.montant_total_ht
        const ecartPct = commande.montant_total_ht !== 0
          ? (ecartHt / commande.montant_total_ht) * 100
          : 0

        if (Math.abs(ecartPct) > 0.5) {
          results.push({
            facture,
            commandeMontantHt: commande.montant_total_ht,
            ecartHt,
            ecartPct,
          })
        }
      } catch {
        // Skip factures with errors
      }
    }

    return results.sort((a, b) => Math.abs(b.ecartPct) - Math.abs(a.ecartPct))
  }

  // --- Helpers ---
  function getById(id: string) {
    return factures.value.find(f => f.id === id)
  }

  function getAchatsForFacture(factureId: string) {
    return achatsHorsCommande.value.filter(a => a.facture_pennylane_id === factureId)
  }

  return {
    factures, achatsHorsCommande, loading, error,
    nonRapprochees, rapprochees, ecarts, depannages,
    currentMonthFactures, summaryMois,
    fetchAll, rapprocher, detecterDepannage, getEcarts,
    getById, getAchatsForFacture,
  }
})
