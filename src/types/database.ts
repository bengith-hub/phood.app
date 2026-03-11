// Types mirroring the Supabase PostgreSQL schema (001_initial_schema.sql)
// Source of truth: supabase/migrations/001_initial_schema.sql

export type UserRole = 'admin' | 'manager' | 'operator'

export interface Profile {
  id: string
  email: string
  nom: string
  role: UserRole
  created_at: string
}

export interface Config {
  id: string
  seuil_ecart_prix_pct: number
  delai_alerte_avoir_heures: number
  delai_expiration_avoir_heures: number
  destinataires_email_avoir: string[]
  destinataires_email_alertes: string[]
  google_calendar_id: string | null
  updated_at: string
}

export interface ZoneStockage {
  id: string
  nom: string
  description: string | null
  ordre: number
  created_at: string
}

export interface Fournisseur {
  id: string
  nom: string
  contact_nom: string | null
  email_commande: string | null
  email_commande_bcc: string | null
  telephone: string | null
  jours_commande: number[] // 0=dim, 1=lun, ..., 6=sam
  heure_limite_commande: string | null // "14:00"
  jours_livraison: number[]
  delai_commande_livraison: Record<string, number> | null // {"1": 3, "3": 5}
  creneau_livraison: { debut: string; fin: string } | null
  franco_minimum: number
  duree_couverture_defaut: number | null // jours de couverture par défaut pour les commandes
  conditions_paiement: string | null
  mode_envoi: string // default 'email'
  adresse: string | null
  siret: string | null
  site_web: string | null
  pennylane_supplier_id: string | null
  notes: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export interface Categorie {
  id: string
  nom: string
  type: 'ingredient' | 'recette' | 'mercuriale'
  ordre: number
  created_at: string
}

export type UniteStock = 'kg' | 'L' | 'unite' | 'botte' | 'piece'

export type Allergene =
  | 'gluten' | 'crustaces' | 'oeufs' | 'poissons' | 'arachides'
  | 'soja' | 'lait' | 'fruits_a_coque' | 'celeri' | 'moutarde'
  | 'sesame' | 'sulfites' | 'lupin' | 'mollusques'

export interface IngredientRestaurant {
  id: string
  nom: string
  unite_stock: string
  categorie: string | null
  allergenes: Allergene[]
  contient: string | null
  fournisseur_prefere_id: string | null // FK mercuriale
  cout_unitaire: number
  cout_source: string | null // 'mercuriale' default
  cout_maj_date: string | null
  rendement: number | null // yield coefficient, default 1.0
  stock_tampon: number
  stock_tampon_weekend: number | null
  stock_tampon_vacances: number | null
  zone_stockage_id: string | null
  photo_url: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export interface Conditionnement {
  nom: string
  quantite: number
  unite: string
  utilise_commande?: boolean
}

export interface Mercuriale {
  id: string
  fournisseur_id: string
  ingredient_restaurant_id: string | null
  designation: string
  ref_fournisseur: string | null
  categorie: string | null
  unite_commande: string // default 'kg'
  conditionnements: Conditionnement[]
  prix_unitaire_ht: number
  prix_futur: { prix: number; date_effet: string } | null
  type_prix: 'standard' | 'trimestriel' | 'annuel' | null
  date_fin_prix: string | null
  tva: number // ex: 5.5, 10, 20
  prix_modifiable_reception: boolean
  dlc_ddm_jours: number | null
  pertes_pct: number | null
  unite_stock: string
  coefficient_conversion: number
  nombre_portions: number | null
  stock_tampon: { semaine: number; weekend: number; vacances: number } | null
  photo_url: string | null
  notes: string | null
  notes_internes: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export interface HistoriquePrix {
  id: string
  mercuriale_id: string
  prix_ancien: number | null
  prix_nouveau: number
  date_constatation: string
  source: 'bl' | 'manuel' | 'pennylane'
  valide_par: string | null
  created_at: string
}

export type RecetteType = 'recette' | 'sous_recette'
export type CanalVente = 'sur_place' | 'emporter' | 'livraison'

export interface PrixVenteCanal {
  ttc: number
  tva: number
}

export interface RecetteVariante {
  nom: string
  zelty_option_value_id?: number  // Zelty option value ID (e.g., 1215713=Normal, 1215714=Grand)
  coefficient: number             // Multiplier for all ingredients (e.g., 1.0, 1.5)
}

export interface RecetteModificateur {
  nom: string
  zelty_option_value_id?: number  // Zelty option value ID for matching
  type: 'extra' | 'sans'
  impact_stock: Array<{
    ingredient_restaurant_id: string
    quantite: number
    unite: string
  }>
  prix_supplement: number
}

export interface Recette {
  id: string
  nom: string
  type: RecetteType
  categorie: string | null
  description: string | null
  nb_portions: number
  cout_matiere: number
  cout_emballage: number | null
  prix_vente: {
    sur_place?: PrixVenteCanal
    emporter?: PrixVenteCanal
    livraison?: PrixVenteCanal
  } | null
  zelty_product_id: string | null
  variantes: RecetteVariante[] | null
  modificateurs: RecetteModificateur[] | null
  photo_url: string | null
  instructions: string | null
  actif: boolean
  created_at: string
  updated_at: string
}

export interface RecetteIngredient {
  id: string
  recette_id: string
  ingredient_id: string | null
  sous_recette_id: string | null
  quantite: number
  unite: string
  sur_place: boolean
  emporter: boolean
  created_at: string
}

export type StatutCommande =
  | 'brouillon' | 'envoyee' | 'receptionnee'
  | 'controlee' | 'validee' | 'avoir_en_cours' | 'cloturee'

export interface Commande {
  id: string
  numero: string
  fournisseur_id: string
  statut: StatutCommande
  date_commande: string | null
  date_livraison_prevue: string | null
  montant_total_ht: number
  montant_total_ttc: number
  notes: string | null
  pdf_url: string | null
  created_by: string
  locked_by: string | null
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
  prix_unitaire_ht: number
  montant_ht: number
  montant_ttc: number
  created_at: string
}

export interface Reception {
  id: string
  commande_id: string
  date_reception: string
  photo_bl_url: string | null
  ia_extraction: Record<string, unknown> | null
  notes: string | null
  validee: boolean
  created_by: string
  created_at: string
}

export type AnomalieType =
  | 'manquant' | 'quantite' | 'casse' | 'substitue'
  | 'qualite' | 'prix' | 'non_commande'

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
  dlc_date: string | null
  created_at: string
}

export type StatutAvoir = 'en_attente' | 'envoyee' | 'relancee' | 'acceptee' | 'refusee' | 'expiree'

export interface AvoirLigne {
  designation: string
  sku: string | null
  quantite_commandee: number
  quantite_recue: number
  prix_unitaire_bc: number | null
  prix_unitaire_bl: number | null
  anomalie_type: AnomalieType
  anomalie_detail: string
  balance: number
}

export interface Avoir {
  id: string
  reception_id: string
  fournisseur_id: string
  commande_id: string | null
  montant_estime: number
  statut: StatutAvoir
  date_envoi: string | null
  date_relance: string | null
  date_reponse: string | null
  notes: string | null
  commentaire: string | null
  email_envoye: boolean
  lignes_avoir: AvoirLigne[]
  photos_anomalies: string[]
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

export interface ModeleInventaire {
  id: string
  nom: string
  type: 'complet' | 'partiel'
  zones: string[]
  ingredients: string[]
  created_at: string
}

export interface Inventaire {
  id: string
  nom: string
  date: string
  type: 'complet' | 'partiel'
  zones: string[]
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
  temperature_max: number | null
  temperature_min: number | null
  precipitation_mm: number | null
  ensoleillement_secondes: number | null
  couverture_nuageuse_pct: number | null
  code_meteo: number | null
  created_at: string
}

export interface Evenement {
  id: string
  nom: string
  type: 'ferie' | 'vacances' | 'soldes' | 'custom'
  date_debut: string
  date_fin: string
  coefficient: number
  recurrent: boolean
  notes: string | null
  created_at: string
}

export interface FacturePennylane {
  id: string
  pennylane_id: string
  fournisseur_id: string | null
  numero: string | null
  date_facture: string | null
  montant_ht: number
  montant_ttc: number
  statut_rapprochement: 'non_rapprochee' | 'rapprochee' | 'ecart_detecte' | 'depannage'
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
  jour_semaine: number
  heure_ouverture: string
  heure_fermeture: string
  est_ferme: boolean
  source: 'gbp' | 'manuel'
  updated_at: string
}

export interface RepartitionHoraire {
  id: string
  jour_semaine: number
  creneau_heure: number
  pourcentage: number
  contexte: 'standard' | 'vacances' | 'samedi' | 'dimanche'
  updated_at: string
}

export interface CronLog {
  id: string
  job_name: string
  started_at: string
  finished_at: string | null
  status: 'running' | 'success' | 'error'
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
  reference_id: string | null
  reference_type: string | null
  created_at: string
}
