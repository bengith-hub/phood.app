// Types mirroring the Supabase PostgreSQL schema
// See CAHIER_DES_CHARGES.md section 14.2

export type UserRole = 'admin' | 'manager' | 'operator'

export interface Profile {
  id: string
  email: string
  nom: string
  role: UserRole
  created_at: string
}

export interface Fournisseur {
  id: string
  nom: string
  contact_nom: string | null
  contact_email: string | null
  contact_telephone: string | null
  jours_commande: number[] // [1,3,5] = lun, mer, ven
  jours_livraison: number[] // jours de la semaine
  delai_livraison_jours: number
  delai_commande_livraison: Record<string, string> | null // mapping jour commande → jour livraison
  creneau_livraison: { debut: string; fin: string } | null // ex: {debut: "07:00", fin: "09:00"}
  heure_limite_commande: string | null // ex: "14:00"
  franco_minimum: number // en euros, BLOQUANT
  notes: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export type UniteStock = 'kg' | 'L' | 'unite' | 'botte' | 'piece'

export interface Conditionnement {
  nom: string // ex: "Carton 5kg", "Bidon 5L"
  quantite: number // ex: 5
  unite: UniteStock // ex: "kg"
}

export interface Mercuriale {
  id: string
  fournisseur_id: string
  ingredient_restaurant_id: string | null
  designation: string
  ref_fournisseur: string | null
  categorie: string | null
  conditionnements: Conditionnement[]
  conditionnement_commande_idx: number // index du conditionnement par défaut pour commander
  prix_unitaire: number // prix par unité de stock (€/kg, €/L, etc.)
  unite_stock: UniteStock
  tva_taux: number // ex: 5.5, 10, 20
  dlc_ddm_jours: number | null
  photo_url: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export interface HistoriquePrix {
  id: string
  mercuriale_id: string
  prix_unitaire: number
  date_constatation: string
  source: 'bl' | 'manuel' | 'pennylane'
  created_at: string
}

export type Allergene =
  | 'gluten' | 'crustaces' | 'oeufs' | 'poissons' | 'arachides'
  | 'soja' | 'lait' | 'fruits_a_coque' | 'celeri' | 'moutarde'
  | 'sesame' | 'sulfites' | 'lupin' | 'mollusques'

export interface IngredientRestaurant {
  id: string
  nom: string
  unite_stock: UniteStock
  categorie: string | null
  allergenes: Allergene[]
  contient: string | null // free text: sub-ingredients for pre-made items
  fournisseur_prefere_id: string | null // FK mercuriale
  cout_unitaire: number // auto-calculated from preferred supplier
  stock_tampon: number
  stock_tampon_weekend: number | null
  stock_tampon_vacances: number | null
  zone_stockage_id: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export type RecetteType = 'recette' | 'sous_recette'
export type CanalVente = 'sur_place' | 'emporter' | 'livraison'

export interface Recette {
  id: string
  nom: string
  type: RecetteType
  categorie: string | null
  description: string | null
  nb_portions: number
  cout_matiere: number // auto-calculated recursively
  prix_vente_sp: number | null // sur place
  prix_vente_emp: number | null // emporter
  prix_vente_liv: number | null // livraison
  zelty_product_id: string | null
  photo_url: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export interface RecetteIngredient {
  id: string
  recette_id: string
  ingredient_id: string | null // FK ingredients_restaurant
  sous_recette_id: string | null // FK recettes (for sub-recipes)
  quantite: number
  unite: UniteStock
  created_at: string
}

export type StatutCommande =
  | 'brouillon' | 'envoyee' | 'receptionnee'
  | 'controlee' | 'validee' | 'avoir_en_cours' | 'cloturee'

export interface Commande {
  id: string
  numero: string // BC{YYYYMMDD}-{NNN}
  fournisseur_id: string
  statut: StatutCommande
  date_commande: string | null
  date_livraison_prevue: string | null
  montant_total_ht: number
  montant_total_ttc: number
  notes: string | null
  pdf_url: string | null
  created_by: string // FK profiles
  locked_by: string | null // FK profiles (realtime locking)
  locked_at: string | null
  created_at: string
  updated_at: string
}

export interface CommandeLigne {
  id: string
  commande_id: string
  mercuriale_id: string
  quantite: number
  conditionnement_idx: number
  prix_unitaire: number
  montant_ht: number
  montant_ttc: number
  created_at: string
}

export type AnomalieType =
  | 'manquant' | 'quantite' | 'casse' | 'substitue'
  | 'qualite' | 'prix' | 'non_commande'

export interface Reception {
  id: string
  commande_id: string
  date_reception: string
  photo_bl_url: string | null
  ia_extraction: Record<string, unknown> | null // JSON from OpenAI
  notes: string | null
  validee: boolean
  created_by: string
  created_at: string
}

export interface ReceptionLigne {
  id: string
  reception_id: string
  commande_ligne_id: string | null
  mercuriale_id: string
  quantite_attendue: number
  quantite_recue: number
  quantite_acceptee: number
  anomalie_type: AnomalieType | null
  anomalie_detail: string | null
  anomalie_photo_url: string | null
  prix_bl: number | null
  ecart_prix_pct: number | null
  created_at: string
}

export type StatutAvoir = 'en_attente' | 'relancee' | 'acceptee' | 'refusee' | 'expiree'

export interface Avoir {
  id: string
  reception_id: string
  fournisseur_id: string
  montant_estime: number
  statut: StatutAvoir
  date_envoi: string | null
  date_relance: string | null
  date_reponse: string | null
  notes: string | null
  created_at: string
}

export interface ZoneStockage {
  id: string
  nom: string // ex: "Froid positif", "Froid négatif", "Sec", "Bar"
  description: string | null
  ordre: number
  created_at: string
}

export interface Stock {
  id: string
  ingredient_id: string
  quantite: number
  zone_stockage_id: string | null
  derniere_maj: string
  source_maj: 'reception' | 'inventaire' | 'vente' | 'manuel'
}

export interface Inventaire {
  id: string
  nom: string
  date: string
  type: 'complet' | 'partiel'
  zones: string[] // zone_stockage_ids
  statut: 'en_cours' | 'valide'
  created_by: string
  created_at: string
}

export interface InventaireLigne {
  id: string
  inventaire_id: string
  ingredient_id: string
  quantite_theorique: number
  quantite_comptee: number
  ecart: number
  conditionnement_saisie: string | null
  notes: string | null
  created_at: string
}

export interface VenteHistorique {
  id: string
  date: string
  ca_ttc: number
  nb_tickets: number
  nb_couverts: number | null
  cloture_validee: boolean
  zelty_closure_id: string | null
  created_at: string
}

export interface MeteoDaily {
  id: string
  date: string
  temperature_max: number
  temperature_min: number
  precipitation_mm: number
  ensoleillement_heures: number
  couverture_nuageuse_pct: number
  code_meteo: number // WMO weather code
  created_at: string
}

export interface Evenement {
  id: string
  nom: string
  type: 'ferie' | 'vacances' | 'soldes' | 'custom'
  date_debut: string
  date_fin: string
  coefficient: number // multiplicateur CA
  recurrent: boolean
  notes: string | null
  created_at: string
}

export interface FacturePennylane {
  id: string
  pennylane_id: string
  fournisseur_id: string | null
  numero: string
  date_facture: string
  montant_ht: number
  montant_ttc: number
  statut_rapprochement: 'non_rapprochee' | 'rapprochee' | 'depannage'
  reception_id: string | null
  created_at: string
}

export interface AchatHorsCommande {
  id: string
  facture_pennylane_id: string | null
  fournisseur_nom: string
  montant_ht: number
  date_achat: string
  description: string | null
  created_at: string
}

export interface HoraireOuverture {
  id: string
  jour_semaine: number // 0=dimanche, 1=lundi, ..., 6=samedi
  heure_ouverture: string // "10:00"
  heure_fermeture: string // "22:00"
  est_ferme: boolean
  source: 'gbp' | 'manuel'
  updated_at: string
}

export interface RepartitionHoraire {
  id: string
  jour_semaine: number
  creneau_heure: number // 10, 11, ..., 21
  pourcentage: number // ex: 0.28 for 28%
  contexte: 'standard' | 'vacances' | 'samedi' | 'dimanche'
  updated_at: string
}

export interface CronLog {
  id: string
  job_name: string
  started_at: string
  finished_at: string | null
  status: 'success' | 'error'
  duration_ms: number | null
  error_message: string | null
}

export type NotificationType =
  | 'prix_ecart' | 'avoir_sans_reponse' | 'stock_bas'
  | 'zelty_non_associe' | 'composition_manquante' | 'commande_rappel'

export interface Notification {
  id: string
  type: NotificationType
  titre: string
  message: string
  lue: boolean
  destinataire_id: string | null
  reference_id: string | null // generic FK
  reference_type: string | null // table name
  created_at: string
}

export interface Config {
  id: string
  seuil_ecart_prix_pct: number // default 10
  delai_alerte_avoir_heures: number // default 48
  delai_expiration_avoir_heures: number // default 72
  destinataires_email_avoir: string[]
  destinataires_email_alertes: string[]
  updated_at: string
}
