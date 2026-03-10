import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { restCall } from '@/lib/rest-client'
import type { VenteHistorique, FacturePennylane, Recette } from '@/types/database'

// ── Reporting-specific types ──────────────────────────────────
export type PeriodType = 'semaine' | 'mois'

export interface CoutMatiereRow {
  label: string         // "Sem. 10" or "Mars"
  dateDebut: string
  dateFin: string
  ca: number
  cmTheorique: number   // sum(cout * nb_ventes)
  cmReel: number        // sum(factures matieres premieres)
  cmTheoriquePct: number
  cmReelPct: number
}

export interface ProduitRanking {
  recetteId: string
  nom: string
  categorie: string | null
  nbVentes: number
  ca: number
  coutMatiere: number
  margeUnitaire: number
  margePct: number
}

export interface AssociationProduit {
  produitA: string
  produitB: string
  coOccurrences: number
  pctTickets: number
}

export interface PrevisionJour {
  date: string
  jourSemaine: string
  prevision: number
  reel: number
  ecartPct: number
  couleur: 'green' | 'orange' | 'red'
}

// ── Helper: date formatting ──────────────────────────────────
function toDateStr(d: Date): string {
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

function startOfWeek(d: Date): Date {
  const day = d.getDay()
  const diff = d.getDate() - day + (day === 0 ? -6 : 1) // Monday
  const start = new Date(d)
  start.setDate(diff)
  start.setHours(0, 0, 0, 0)
  return start
}

function endOfWeek(d: Date): Date {
  const start = startOfWeek(d)
  const end = new Date(start)
  end.setDate(start.getDate() + 6)
  return end
}


function endOfMonth(d: Date): Date {
  return new Date(d.getFullYear(), d.getMonth() + 1, 0)
}

function getWeekNumber(d: Date): number {
  const start = new Date(d.getFullYear(), 0, 1)
  const diff = d.getTime() - start.getTime()
  const oneWeek = 604800000
  return Math.ceil((diff / oneWeek) + start.getDay() / 7)
}

const JOURS_FR = ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi']
const MOIS_FR = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre']

// ── Store ─────────────────────────────────────────────────────
export const useReportingStore = defineStore('reporting', () => {
  // Raw data
  const ventes = ref<VenteHistorique[]>([])
  const factures = ref<FacturePennylane[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  // Settings
  const period = ref<PeriodType>('semaine')
  const cibleCM = ref(30)

  // ── Fetch data ────────────────────────────────────────────
  async function fetchVentesRange(dateDebut: string, dateFin: string) {
    return await restCall<VenteHistorique[]>(
      'GET',
      `ventes_historique?select=*&date=gte.${dateDebut}&date=lte.${dateFin}&order=date`,
    )
  }

  async function fetchFacturesRange(dateDebut: string, dateFin: string) {
    return await restCall<FacturePennylane[]>(
      'GET',
      `factures_pennylane?select=*&date_facture=gte.${dateDebut}&date_facture=lte.${dateFin}`,
    )
  }

  async function fetchAll(_recettes: Recette[]) {
    loading.value = true
    error.value = null

    try {
      const now = new Date()
      let dateDebut: string
      let dateFin: string

      if (period.value === 'semaine') {
        const start = new Date(now)
        start.setDate(start.getDate() - 8 * 7)
        dateDebut = toDateStr(startOfWeek(start))
        dateFin = toDateStr(endOfWeek(now))
      } else {
        const start = new Date(now.getFullYear(), now.getMonth() - 5, 1)
        dateDebut = toDateStr(start)
        dateFin = toDateStr(endOfMonth(now))
      }

      const [v, f] = await Promise.all([
        fetchVentesRange(dateDebut, dateFin),
        fetchFacturesRange(dateDebut, dateFin),
      ])

      ventes.value = v
      factures.value = f
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement données reporting'
    } finally {
      loading.value = false
    }
  }

  // ── Tab 1: Coût Matière (unchanged — pure computation) ──
  function computeCoutMatiere(
    recettes: Recette[],
    nbVentesParRecette: Map<string, number>,
  ): CoutMatiereRow[] {
    const rows: CoutMatiereRow[] = []
    const now = new Date()

    if (period.value === 'semaine') {
      for (let i = 7; i >= 0; i--) {
        const weekStart = new Date(now)
        weekStart.setDate(weekStart.getDate() - i * 7)
        const ws = startOfWeek(weekStart)
        const we = endOfWeek(weekStart)
        const wsStr = toDateStr(ws)
        const weStr = toDateStr(we)

        const weekVentes = ventes.value.filter(v => v.date >= wsStr && v.date <= weStr)
        const weekFactures = factures.value.filter(f =>
          f.date_facture && f.date_facture >= wsStr && f.date_facture <= weStr
        )

        const ca = weekVentes.reduce((sum, v) => sum + v.ca_ttc, 0)

        let cmTheo = 0
        for (const r of recettes) {
          const nv = nbVentesParRecette.get(r.id) || 0
          if (nv > 0) {
            cmTheo += r.cout_matiere * nv
          }
        }
        const cmReel = weekFactures.reduce((sum, f) => sum + f.montant_ht, 0)

        rows.push({
          label: `S${getWeekNumber(ws)}`,
          dateDebut: wsStr,
          dateFin: weStr,
          ca,
          cmTheorique: cmTheo,
          cmReel,
          cmTheoriquePct: ca > 0 ? (cmTheo / ca) * 100 : 0,
          cmReelPct: ca > 0 ? (cmReel / ca) * 100 : 0,
        })
      }
    } else {
      for (let i = 5; i >= 0; i--) {
        const ms = new Date(now.getFullYear(), now.getMonth() - i, 1)
        const me = endOfMonth(ms)
        const msStr = toDateStr(ms)
        const meStr = toDateStr(me)

        const monthVentes = ventes.value.filter(v => v.date >= msStr && v.date <= meStr)
        const monthFactures = factures.value.filter(f =>
          f.date_facture && f.date_facture >= msStr && f.date_facture <= meStr
        )

        const ca = monthVentes.reduce((sum, v) => sum + v.ca_ttc, 0)
        let cmTheo = 0
        for (const r of recettes) {
          const nv = nbVentesParRecette.get(r.id) || 0
          if (nv > 0) {
            cmTheo += r.cout_matiere * nv
          }
        }
        const cmReel = monthFactures.reduce((sum, f) => sum + f.montant_ht, 0)

        rows.push({
          label: MOIS_FR[ms.getMonth()]!.substring(0, 3),
          dateDebut: msStr,
          dateFin: meStr,
          ca,
          cmTheorique: cmTheo,
          cmReel,
          cmTheoriquePct: ca > 0 ? (cmTheo / ca) * 100 : 0,
          cmReelPct: ca > 0 ? (cmReel / ca) * 100 : 0,
        })
      }
    }

    return rows
  }

  // ── Tab 2: Top/Flop Produits (unchanged — pure computation) ──
  function computeProduitRankings(
    recettes: Recette[],
    nbVentesParRecette: Map<string, number>,
  ): ProduitRanking[] {
    const results: ProduitRanking[] = []

    for (const r of recettes) {
      if (r.type !== 'recette' || !r.actif) continue

      const nbVentes = nbVentesParRecette.get(r.id) || 0
      let prixMoyen = 0
      let channels = 0
      if (r.prix_vente) {
        if (r.prix_vente.sur_place) { prixMoyen += r.prix_vente.sur_place.ttc; channels++ }
        if (r.prix_vente.emporter) { prixMoyen += r.prix_vente.emporter.ttc; channels++ }
        if (r.prix_vente.livraison) { prixMoyen += r.prix_vente.livraison.ttc; channels++ }
      }
      if (channels > 0) prixMoyen /= channels

      const ca = nbVentes * prixMoyen
      const coutTotal = nbVentes * r.cout_matiere
      const margeUnitaire = prixMoyen - r.cout_matiere
      const margePct = prixMoyen > 0 ? ((prixMoyen - r.cout_matiere) / prixMoyen) * 100 : 0

      results.push({
        recetteId: r.id,
        nom: r.nom,
        categorie: r.categorie,
        nbVentes,
        ca,
        coutMatiere: coutTotal,
        margeUnitaire,
        margePct,
      })
    }

    return results
  }

  // ── Tab 3: Associations Produits (scaffold) ───────────────
  const associations = ref<AssociationProduit[]>([])

  async function fetchAssociations() {
    associations.value = []
  }

  // ── Tab 4: Précision Prévisions ───────────────────────────
  async function fetchPrecisionPrevisions(): Promise<PrevisionJour[]> {
    const now = new Date()
    const thisWeekStart = startOfWeek(now)
    const lastWeekStart = new Date(thisWeekStart)
    lastWeekStart.setDate(lastWeekStart.getDate() - 7)
    const lastWeekEnd = new Date(lastWeekStart)
    lastWeekEnd.setDate(lastWeekEnd.getDate() + 6)

    const dateDebut = toDateStr(lastWeekStart)
    const dateFin = toDateStr(lastWeekEnd)

    // Fetch actuals
    const actualVentes = await restCall<VenteHistorique[]>(
      'GET',
      `ventes_historique?select=*&date=gte.${dateDebut}&date=lte.${dateFin}&order=date`,
    )

    // Try to fetch previsions (table may not exist yet)
    let previsionsMap = new Map<string, number>()
    try {
      const prevData = await restCall<{ date: string; ca_prevu: number }[]>(
        'GET',
        `previsions_ca?select=date,ca_prevu&date=gte.${dateDebut}&date=lte.${dateFin}`,
      )
      for (const p of prevData) {
        previsionsMap.set(p.date, p.ca_prevu)
      }
    } catch {
      previsionsMap = new Map()
    }

    const jours: PrevisionJour[] = []
    for (let i = 0; i < 7; i++) {
      const day = new Date(lastWeekStart)
      day.setDate(day.getDate() + i)
      const dayStr = toDateStr(day)
      const vente = actualVentes.find(v => v.date === dayStr)
      const reel = vente ? vente.ca_ttc : 0
      const prevision = previsionsMap.get(dayStr) || 0
      const ecartPct = reel > 0 ? Math.abs(prevision - reel) / reel * 100 : 0

      let couleur: 'green' | 'orange' | 'red' = 'green'
      if (ecartPct > 20) couleur = 'red'
      else if (ecartPct > 10) couleur = 'orange'

      jours.push({
        date: dayStr,
        jourSemaine: JOURS_FR[day.getDay()]!,
        prevision,
        reel,
        ecartPct,
        couleur,
      })
    }

    return jours
  }

  // ── Aggregated computed values ────────────────────────────
  const totalCA = computed(() =>
    ventes.value.reduce((sum, v) => sum + v.ca_ttc, 0)
  )

  const totalFacturesHT = computed(() =>
    factures.value.reduce((sum, f) => sum + f.montant_ht, 0)
  )

  const cmReelGlobal = computed(() =>
    totalCA.value > 0 ? (totalFacturesHT.value / totalCA.value) * 100 : 0
  )

  return {
    ventes, factures, loading, error, period, cibleCM, associations,
    totalCA, totalFacturesHT, cmReelGlobal,
    fetchAll, computeCoutMatiere, computeProduitRankings,
    fetchAssociations, fetchPrecisionPrevisions,
  }
})
