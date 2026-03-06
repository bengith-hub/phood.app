import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
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
        const [facturesRes, achatsRes] = await Promise.all([
          supabase
            .from('factures_pennylane')
            .select('*')
            .order('date_facture', { ascending: false }),
          supabase
            .from('achats_hors_commande')
            .select('*')
            .order('date_achat', { ascending: false }),
        ])
        if (facturesRes.error) throw facturesRes.error
        if (achatsRes.error) throw achatsRes.error

        factures.value = facturesRes.data as FacturePennylane[]
        achatsHorsCommande.value = achatsRes.data as AchatHorsCommande[]

        // Cache in IndexedDB
        await db.facturesPennylane.clear()
        await db.facturesPennylane.bulkPut(facturesRes.data as FacturePennylane[])
        await db.achatsHorsCommande.clear()
        await db.achatsHorsCommande.bulkPut(achatsRes.data as AchatHorsCommande[])
      } else {
        factures.value = await db.facturesPennylane.reverse().sortBy('date_facture')
        achatsHorsCommande.value = await db.achatsHorsCommande.reverse().sortBy('date_achat')
      }
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement factures'
      // Fallback to IndexedDB
      factures.value = await db.facturesPennylane.reverse().sortBy('date_facture')
      achatsHorsCommande.value = await db.achatsHorsCommande.reverse().sortBy('date_achat')
    } finally {
      loading.value = false
    }
  }

  // --- Rapprochement: link invoice to a reception/BL ---
  async function rapprocher(factureId: string, receptionId: string) {
    // Fetch the linked commande to compare amounts
    const { data: reception, error: recErr } = await supabase
      .from('receptions')
      .select('commande_id')
      .eq('id', receptionId)
      .single()
    if (recErr) throw recErr

    const { data: commande, error: cmdErr } = await supabase
      .from('commandes')
      .select('montant_total_ht')
      .eq('id', reception.commande_id)
      .single()
    if (cmdErr) throw cmdErr

    const facture = factures.value.find(f => f.id === factureId)
    if (!facture) throw new Error('Facture introuvable')

    // Detect ecart: >2% difference between invoice and commande HT
    const ecartPct = Math.abs(facture.montant_ht - commande.montant_total_ht) / commande.montant_total_ht * 100
    const statut: StatutRapprochement = ecartPct > 2 ? 'ecart_detecte' : 'rapprochee'

    const { error: updateErr } = await supabase
      .from('factures_pennylane')
      .update({
        reception_id: receptionId,
        statut_rapprochement: statut,
      })
      .eq('id', factureId)
    if (updateErr) throw updateErr

    await fetchAll()
    return { statut, ecartPct }
  }

  // --- Detect depannage: invoices with "matieres premieres" category and no matching BC ---
  async function detecterDepannage() {
    // Find non-reconciled invoices that have no reception_id (meaning no BC)
    const candidats = factures.value.filter(
      f => f.statut_rapprochement === 'non_rapprochee' && !f.reception_id
    )

    if (candidats.length === 0) return 0

    let count = 0
    for (const facture of candidats) {
      // Check if there's a matching commande for this fournisseur around the same date
      const { data: matchingCommandes } = await supabase
        .from('commandes')
        .select('id')
        .eq('fournisseur_id', facture.fournisseur_id || '')
        .in('statut', ['envoyee', 'receptionnee', 'controlee', 'validee', 'cloturee'])
        .limit(1)

      // If no matching commande found, it's a depannage
      if (!matchingCommandes || matchingCommandes.length === 0) {
        const { error: updateErr } = await supabase
          .from('factures_pennylane')
          .update({ statut_rapprochement: 'depannage' })
          .eq('id', facture.id)
        if (!updateErr) {
          count++

          // Auto-create achat hors commande entry
          const fournisseurNom = facture.fournisseur_id || 'Inconnu'
          await supabase
            .from('achats_hors_commande')
            .insert({
              facture_pennylane_id: facture.id,
              fournisseur_nom: fournisseurNom,
              montant_ht: facture.montant_ht,
              date_achat: facture.date_facture || new Date().toISOString().split('T')[0],
              description: `Achat dépannage détecté automatiquement (facture ${facture.numero || facture.pennylane_id})`,
            })
        }
      }
    }

    await fetchAll()
    return count
  }

  // --- Get ecarts: compare invoice amounts vs commande amounts ---
  async function getEcarts(): Promise<EcartFacture[]> {
    const results: EcartFacture[] = []

    // Get all factures that have a reception_id linked
    const facturesAvecReception = factures.value.filter(f => f.reception_id)

    for (const facture of facturesAvecReception) {
      // Fetch reception -> commande to get the commande montant
      const { data: reception } = await supabase
        .from('receptions')
        .select('commande_id')
        .eq('id', facture.reception_id!)
        .single()

      if (!reception) continue

      const { data: commande } = await supabase
        .from('commandes')
        .select('montant_total_ht')
        .eq('id', reception.commande_id)
        .single()

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
