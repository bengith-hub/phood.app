import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '@/lib/supabase'
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
  return d.toISOString().split('T')[0]!
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
  const cibleCM = ref(30) // Target CM % (configurable)

  // ── Fetch data ────────────────────────────────────────────
  async function fetchVentes(dateDebut: string, dateFin: string) {
    const { data, error: err } = await supabase
      .from('ventes_historique')
      .select('*')
      .gte('date', dateDebut)
      .lte('date', dateFin)
      .order('date')
    if (err) throw err
    return (data || []) as VenteHistorique[]
  }

  async function fetchFactures(dateDebut: string, dateFin: string) {
    const { data, error: err } = await supabase
      .from('factures_pennylane')
      .select('*')
      .gte('date_facture', dateDebut)
      .lte('date_facture', dateFin)
    if (err) throw err
    return (data || []) as FacturePennylane[]
  }

  /**
   * Load all data needed for the reporting module.
   * Fetches the last 8 weeks or 6 months depending on the period.
   */
  async function fetchAll(_recettes: Recette[]) {
    loading.value = true
    error.value = null

    try {
      const now = new Date()
      let dateDebut: string
      let dateFin: string

      if (period.value === 'semaine') {
        // Last 8 weeks
        const start = new Date(now)
        start.setDate(start.getDate() - 8 * 7)
        dateDebut = toDateStr(startOfWeek(start))
        dateFin = toDateStr(endOfWeek(now))
      } else {
        // Last 6 months
        const start = new Date(now.getFullYear(), now.getMonth() - 5, 1)
        dateDebut = toDateStr(start)
        dateFin = toDateStr(endOfMonth(now))
      }

      const [v, f] = await Promise.all([
        fetchVentes(dateDebut, dateFin),
        fetchFactures(dateDebut, dateFin),
      ])

      ventes.value = v
      factures.value = f
    } catch (e: unknown) {
      error.value = e instanceof Error ? e.message : 'Erreur chargement données reporting'
    } finally {
      loading.value = false
    }
  }

  // ── Tab 1: Coût Matière ───────────────────────────────────
  function computeCoutMatiere(
    recettes: Recette[],
    nbVentesParRecette: Map<string, number>,
  ): CoutMatiereRow[] {
    const rows: CoutMatiereRow[] = []
    const now = new Date()

    if (period.value === 'semaine') {
      // Last 8 weeks
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

        // CM theorique: sum of (cout_matiere * nb_ventes) for each recipe
        let cmTheo = 0
        for (const r of recettes) {
          const nv = nbVentesParRecette.get(r.id) || 0
          if (nv > 0) {
            cmTheo += r.cout_matiere * nv
          }
        }
        // Scale by the proportion of this week's CA to total CA
        // (simplified: use factures HT for reel)
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
      // Last 6 months
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

  // ── Tab 2: Top/Flop Produits ──────────────────────────────
  function computeProduitRankings(
    recettes: Recette[],
    nbVentesParRecette: Map<string, number>,
  ): ProduitRanking[] {
    const results: ProduitRanking[] = []

    for (const r of recettes) {
      if (r.type !== 'recette' || !r.actif) continue

      const nbVentes = nbVentesParRecette.get(r.id) || 0
      // Prix moyen across channels
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
  // Data will come from Zelty ticket analysis later
  const associations = ref<AssociationProduit[]>([])

  async function fetchAssociations() {
    // TODO: Will be populated from Zelty ticket line-item analysis
    // For now, return empty — the UI is scaffolded
    associations.value = []
  }

  // ── Tab 4: Précision Prévisions ───────────────────────────
  /**
   * Compare forecast vs actual for previous week (S-1).
   * Forecasts will come from the previsions module when built.
   * For now, we query ventes_historique for S-1 actuals
   * and look for previsions_ca for forecasts.
   */
  async function fetchPrecisionPrevisions(): Promise<PrevisionJour[]> {
    const now = new Date()
    // S-1: the previous full week (Mon to Sun)
    const thisWeekStart = startOfWeek(now)
    const lastWeekStart = new Date(thisWeekStart)
    lastWeekStart.setDate(lastWeekStart.getDate() - 7)
    const lastWeekEnd = new Date(lastWeekStart)
    lastWeekEnd.setDate(lastWeekEnd.getDate() + 6)

    const dateDebut = toDateStr(lastWeekStart)
    const dateFin = toDateStr(lastWeekEnd)

    // Fetch actuals
    const { data: ventesData } = await supabase
      .from('ventes_historique')
      .select('*')
      .gte('date', dateDebut)
      .lte('date', dateFin)
      .order('date')

    const actualVentes = (ventesData || []) as VenteHistorique[]

    // Try to fetch previsions (table may not exist yet)
    let previsionsMap = new Map<string, number>()
    try {
      const { data: prevData } = await supabase
        .from('previsions_ca')
        .select('date, ca_prevu')
        .gte('date', dateDebut)
        .lte('date', dateFin)
      if (prevData) {
        for (const p of prevData as Array<{ date: string; ca_prevu: number }>) {
          previsionsMap.set(p.date, p.ca_prevu)
        }
      }
    } catch {
      // Table doesn't exist yet — previsions will be 0
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
    // State
    ventes,
    factures,
    loading,
    error,
    period,
    cibleCM,
    associations,

    // Computed
    totalCA,
    totalFacturesHT,
    cmReelGlobal,

    // Actions
    fetchAll,
    computeCoutMatiere,
    computeProduitRankings,
    fetchAssociations,
    fetchPrecisionPrevisions,
  }
})
