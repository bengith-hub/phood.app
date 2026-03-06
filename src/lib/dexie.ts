import Dexie, { type EntityTable } from 'dexie'
import type {
  Fournisseur, Mercuriale, IngredientRestaurant, Recette,
  RecetteIngredient, Commande, CommandeLigne, Stock, Notification,
  Inventaire, InventaireLigne, ZoneStockage,
  VenteHistorique, MeteoDaily, Evenement, HoraireOuverture, RepartitionHoraire,
  FacturePennylane, AchatHorsCommande, HistoriquePrix, ModeleInventaire,
} from '@/types/database'

// Offline-first database mirroring key Supabase tables
class PhoodDB extends Dexie {
  fournisseurs!: EntityTable<Fournisseur, 'id'>
  mercuriale!: EntityTable<Mercuriale, 'id'>
  ingredients!: EntityTable<IngredientRestaurant, 'id'>
  recettes!: EntityTable<Recette, 'id'>
  recetteIngredients!: EntityTable<RecetteIngredient, 'id'>
  commandes!: EntityTable<Commande, 'id'>
  commandeLignes!: EntityTable<CommandeLigne, 'id'>
  stocks!: EntityTable<Stock, 'id'>
  notifications!: EntityTable<Notification, 'id'>
  inventaires!: EntityTable<Inventaire, 'id'>
  inventaireLignes!: EntityTable<InventaireLigne, 'id'>
  zonesStockage!: EntityTable<ZoneStockage, 'id'>
  ventesHistorique!: EntityTable<VenteHistorique, 'id'>
  meteoDaily!: EntityTable<MeteoDaily, 'id'>
  evenements!: EntityTable<Evenement, 'id'>
  horairesOuverture!: EntityTable<HoraireOuverture, 'id'>
  repartitionHoraire!: EntityTable<RepartitionHoraire, 'id'>
  facturesPennylane!: EntityTable<FacturePennylane, 'id'>
  achatsHorsCommande!: EntityTable<AchatHorsCommande, 'id'>
  historiquePrix!: EntityTable<HistoriquePrix, 'id'>
  modelesInventaire!: EntityTable<ModeleInventaire, 'id'>

  constructor() {
    super('PhoodDB')
    this.version(1).stores({
      fournisseurs: 'id, nom, actif',
      mercuriale: 'id, fournisseur_id, designation, categorie, actif',
      ingredients: 'id, nom, categorie, fournisseur_prefere_id, actif',
      recettes: 'id, nom, type, categorie, actif',
      recetteIngredients: 'id, recette_id, ingredient_id, sous_recette_id',
      commandes: 'id, numero, fournisseur_id, statut, date_commande',
      commandeLignes: 'id, commande_id, mercuriale_id',
      stocks: 'id, ingredient_id',
      notifications: 'id, type, lue, created_at',
    })
    this.version(2).stores({
      fournisseurs: 'id, nom, actif',
      mercuriale: 'id, fournisseur_id, designation, categorie, actif',
      ingredients: 'id, nom, categorie, fournisseur_prefere_id, actif',
      recettes: 'id, nom, type, categorie, actif',
      recetteIngredients: 'id, recette_id, ingredient_id, sous_recette_id',
      commandes: 'id, numero, fournisseur_id, statut, date_commande',
      commandeLignes: 'id, commande_id, mercuriale_id',
      stocks: 'id, ingredient_id',
      notifications: 'id, type, lue, created_at',
      inventaires: 'id, date, statut, type',
      inventaireLignes: 'id, inventaire_id, ingredient_id',
      zonesStockage: 'id, nom, ordre',
    })
    this.version(3).stores({
      fournisseurs: 'id, nom, actif',
      mercuriale: 'id, fournisseur_id, designation, categorie, actif',
      ingredients: 'id, nom, categorie, fournisseur_prefere_id, actif',
      recettes: 'id, nom, type, categorie, actif',
      recetteIngredients: 'id, recette_id, ingredient_id, sous_recette_id',
      commandes: 'id, numero, fournisseur_id, statut, date_commande',
      commandeLignes: 'id, commande_id, mercuriale_id',
      stocks: 'id, ingredient_id',
      notifications: 'id, type, lue, created_at',
      inventaires: 'id, date, statut, type',
      inventaireLignes: 'id, inventaire_id, ingredient_id',
      zonesStockage: 'id, nom, ordre',
      ventesHistorique: 'id, date',
      meteoDaily: 'id, date',
      evenements: 'id, type, date_debut, date_fin',
      horairesOuverture: 'id, jour_semaine',
      repartitionHoraire: 'id, jour_semaine, contexte',
    })
    this.version(4).stores({
      fournisseurs: 'id, nom, actif',
      mercuriale: 'id, fournisseur_id, designation, categorie, actif',
      ingredients: 'id, nom, categorie, fournisseur_prefere_id, actif',
      recettes: 'id, nom, type, categorie, actif',
      recetteIngredients: 'id, recette_id, ingredient_id, sous_recette_id',
      commandes: 'id, numero, fournisseur_id, statut, date_commande',
      commandeLignes: 'id, commande_id, mercuriale_id',
      stocks: 'id, ingredient_id',
      notifications: 'id, type, lue, created_at',
      inventaires: 'id, date, statut, type',
      inventaireLignes: 'id, inventaire_id, ingredient_id',
      zonesStockage: 'id, nom, ordre',
      ventesHistorique: 'id, date',
      meteoDaily: 'id, date',
      evenements: 'id, type, date_debut, date_fin',
      horairesOuverture: 'id, jour_semaine',
      repartitionHoraire: 'id, jour_semaine, contexte',
      facturesPennylane: 'id, pennylane_id, fournisseur_id, statut_rapprochement, date_facture',
      achatsHorsCommande: 'id, facture_pennylane_id, date_achat',
      historiquePrix: 'id, mercuriale_id, date_constatation',
      modelesInventaire: 'id, nom, type',
    })
  }
}

export const db = new PhoodDB()
