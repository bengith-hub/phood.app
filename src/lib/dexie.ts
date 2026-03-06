import Dexie, { type EntityTable } from 'dexie'
import type {
  Fournisseur, Mercuriale, IngredientRestaurant, Recette,
  RecetteIngredient, Commande, CommandeLigne, Stock, Notification
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
  }
}

export const db = new PhoodDB()
