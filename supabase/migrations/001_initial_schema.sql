-- PhoodApp — Initial Schema Migration
-- Based on CAHIER_DES_CHARGES.md section 14.2

-- ============================================================
-- EXTENSIONS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- HELPER FUNCTION: get_my_role()
-- Used by all RLS policies to determine the current user's role
-- ============================================================
CREATE OR REPLACE FUNCTION get_my_role() RETURNS text AS $$
  SELECT role FROM profiles WHERE id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ============================================================
-- TRIGGER FUNCTION: auto-create profile on user signup
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user() RETURNS trigger AS $$
BEGIN
  INSERT INTO profiles (id, email, nom, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    'operator'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- TABLES
-- ============================================================

-- 1. Profiles (linked to auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  nom TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'operator' CHECK (role IN ('admin', 'manager', 'operator')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Trigger: auto-create profile
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- 2. Config (single row)
CREATE TABLE config (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  seuil_ecart_prix_pct NUMERIC NOT NULL DEFAULT 10,
  delai_alerte_avoir_heures INTEGER NOT NULL DEFAULT 48,
  delai_expiration_avoir_heures INTEGER NOT NULL DEFAULT 72,
  destinataires_email_avoir TEXT[] NOT NULL DEFAULT '{}',
  destinataires_email_alertes TEXT[] NOT NULL DEFAULT '{}',
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. Zones de stockage
CREATE TABLE zones_stockage (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL,
  description TEXT,
  ordre INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. Fournisseurs
CREATE TABLE fournisseurs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL,
  contact_nom TEXT,
  email_commande TEXT,
  telephone TEXT,
  jours_commande INTEGER[] NOT NULL DEFAULT '{}', -- 0=dim, 1=lun, ..., 6=sam
  heure_limite_commande TEXT, -- "14:00"
  jours_livraison INTEGER[] NOT NULL DEFAULT '{}',
  delai_commande_livraison JSONB, -- {"1": 3, "3": 5} jour commande → jour livraison
  franco_minimum NUMERIC NOT NULL DEFAULT 0,
  conditions_paiement TEXT,
  mode_envoi TEXT NOT NULL DEFAULT 'email',
  adresse TEXT,
  notes TEXT,
  actif BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. Categories
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL UNIQUE,
  type TEXT NOT NULL DEFAULT 'ingredient' CHECK (type IN ('ingredient', 'recette', 'mercuriale')),
  ordre INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. Ingredients Restaurant
CREATE TABLE ingredients_restaurant (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL,
  unite_stock TEXT NOT NULL DEFAULT 'kg',
  categorie TEXT,
  allergenes TEXT[] NOT NULL DEFAULT '{}',
  contient TEXT, -- free text: sub-ingredients for ready-made products
  fournisseur_prefere_id UUID, -- FK to mercuriale (set after mercuriale creation)
  cout_unitaire NUMERIC NOT NULL DEFAULT 0,
  cout_source TEXT DEFAULT 'mercuriale',
  cout_maj_date DATE,
  rendement NUMERIC DEFAULT 1.0, -- yield coefficient
  stock_tampon NUMERIC NOT NULL DEFAULT 0,
  stock_tampon_weekend NUMERIC,
  stock_tampon_vacances NUMERIC,
  zone_stockage_id UUID REFERENCES zones_stockage(id),
  photo_url TEXT,
  actif BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 7. Mercuriale (supplier product catalog)
CREATE TABLE mercuriale (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  fournisseur_id UUID NOT NULL REFERENCES fournisseurs(id),
  ingredient_restaurant_id UUID REFERENCES ingredients_restaurant(id),
  designation TEXT NOT NULL,
  ref_fournisseur TEXT, -- SKU
  categorie TEXT,
  unite_commande TEXT NOT NULL DEFAULT 'kg',
  conditionnements JSONB NOT NULL DEFAULT '[]', -- [{nom, quantite, unite, utilise_commande}]
  prix_unitaire_ht NUMERIC NOT NULL DEFAULT 0,
  prix_futur JSONB, -- {prix, date_effet}
  type_prix TEXT DEFAULT 'standard' CHECK (type_prix IN ('standard', 'trimestriel', 'annuel')),
  date_fin_prix DATE,
  tva NUMERIC NOT NULL DEFAULT 5.5,
  prix_modifiable_reception BOOLEAN NOT NULL DEFAULT false,
  dlc_ddm_jours INTEGER,
  pertes_pct NUMERIC DEFAULT 0,
  unite_stock TEXT NOT NULL DEFAULT 'kg',
  coefficient_conversion NUMERIC NOT NULL DEFAULT 1,
  nombre_portions INTEGER,
  stock_tampon JSONB, -- {semaine, weekend, vacances}
  photo_url TEXT,
  notes TEXT,
  notes_internes TEXT,
  actif BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Add FK from ingredients_restaurant to mercuriale (preferred supplier)
ALTER TABLE ingredients_restaurant
  ADD CONSTRAINT fk_fournisseur_prefere
  FOREIGN KEY (fournisseur_prefere_id) REFERENCES mercuriale(id);

-- 8. Historique des prix
CREATE TABLE historique_prix (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  mercuriale_id UUID NOT NULL REFERENCES mercuriale(id) ON DELETE CASCADE,
  prix_ancien NUMERIC,
  prix_nouveau NUMERIC NOT NULL,
  date_constatation DATE NOT NULL DEFAULT CURRENT_DATE,
  source TEXT NOT NULL DEFAULT 'manuel' CHECK (source IN ('bl', 'manuel', 'pennylane')),
  valide_par UUID REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 9. Recettes (recipes + sub-recipes)
CREATE TABLE recettes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'recette' CHECK (type IN ('recette', 'sous_recette')),
  categorie TEXT,
  description TEXT,
  nb_portions NUMERIC NOT NULL DEFAULT 1,
  cout_matiere NUMERIC NOT NULL DEFAULT 0, -- auto-calculated
  cout_emballage NUMERIC DEFAULT 0,
  prix_vente JSONB, -- {sur_place: {ttc, tva}, emporter: {ttc, tva}, livraison: {ttc, tva}}
  zelty_product_id TEXT,
  variantes JSONB, -- [{nom, coefficient}]
  modificateurs JSONB, -- [{nom, type, ingredients, prix_supplement}]
  photo_url TEXT,
  instructions TEXT,
  actif BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 10. Recette ingredients (junction table)
CREATE TABLE recette_ingredients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recette_id UUID NOT NULL REFERENCES recettes(id) ON DELETE CASCADE,
  ingredient_id UUID REFERENCES ingredients_restaurant(id),
  sous_recette_id UUID REFERENCES recettes(id),
  quantite NUMERIC NOT NULL,
  unite TEXT NOT NULL DEFAULT 'kg',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT chk_ingredient_or_sous_recette CHECK (
    (ingredient_id IS NOT NULL AND sous_recette_id IS NULL)
    OR (ingredient_id IS NULL AND sous_recette_id IS NOT NULL)
  )
);

-- 11. Commandes (purchase orders)
CREATE TABLE commandes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  numero TEXT NOT NULL UNIQUE, -- BC{YYYYMMDD}-{NNN}
  fournisseur_id UUID NOT NULL REFERENCES fournisseurs(id),
  statut TEXT NOT NULL DEFAULT 'brouillon' CHECK (statut IN (
    'brouillon', 'envoyee', 'receptionnee', 'controlee', 'validee', 'avoir_en_cours', 'cloturee'
  )),
  date_commande DATE,
  date_livraison_prevue DATE,
  montant_total_ht NUMERIC NOT NULL DEFAULT 0,
  montant_total_ttc NUMERIC NOT NULL DEFAULT 0,
  notes TEXT,
  pdf_url TEXT,
  created_by UUID NOT NULL REFERENCES profiles(id),
  locked_by UUID REFERENCES profiles(id),
  locked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 12. Commande lignes (order lines)
CREATE TABLE commande_lignes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  commande_id UUID NOT NULL REFERENCES commandes(id) ON DELETE CASCADE,
  mercuriale_id UUID NOT NULL REFERENCES mercuriale(id),
  quantite NUMERIC NOT NULL,
  conditionnement_idx INTEGER NOT NULL DEFAULT 0,
  prix_unitaire_ht NUMERIC NOT NULL,
  montant_ht NUMERIC NOT NULL DEFAULT 0,
  montant_ttc NUMERIC NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 13. Receptions
CREATE TABLE receptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  commande_id UUID NOT NULL REFERENCES commandes(id),
  date_reception DATE NOT NULL DEFAULT CURRENT_DATE,
  photo_bl_url TEXT,
  ia_extraction JSONB,
  notes TEXT,
  validee BOOLEAN NOT NULL DEFAULT false,
  created_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 14. Reception lignes
CREATE TABLE reception_lignes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reception_id UUID NOT NULL REFERENCES receptions(id) ON DELETE CASCADE,
  commande_ligne_id UUID REFERENCES commande_lignes(id),
  mercuriale_id UUID NOT NULL REFERENCES mercuriale(id),
  quantite_attendue NUMERIC NOT NULL DEFAULT 0,
  quantite_recue NUMERIC NOT NULL DEFAULT 0,
  quantite_acceptee NUMERIC NOT NULL DEFAULT 0,
  anomalie_type TEXT CHECK (anomalie_type IN (
    'manquant', 'quantite', 'casse', 'substitue', 'qualite', 'prix', 'non_commande'
  )),
  anomalie_detail TEXT,
  anomalie_photo_url TEXT,
  prix_bl NUMERIC,
  ecart_prix_pct NUMERIC,
  dlc_date DATE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 15. Avoirs (credit note requests)
CREATE TABLE avoirs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reception_id UUID NOT NULL REFERENCES receptions(id),
  fournisseur_id UUID NOT NULL REFERENCES fournisseurs(id),
  montant_estime NUMERIC NOT NULL DEFAULT 0,
  statut TEXT NOT NULL DEFAULT 'en_attente' CHECK (statut IN (
    'en_attente', 'envoyee', 'relancee', 'acceptee', 'refusee', 'expiree'
  )),
  date_envoi TIMESTAMPTZ,
  date_relance TIMESTAMPTZ,
  date_reponse TIMESTAMPTZ,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 16. Stocks
CREATE TABLE stocks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  ingredient_id UUID NOT NULL REFERENCES ingredients_restaurant(id) UNIQUE,
  quantite NUMERIC NOT NULL DEFAULT 0,
  zone_stockage_id UUID REFERENCES zones_stockage(id),
  derniere_maj TIMESTAMPTZ NOT NULL DEFAULT now(),
  source_maj TEXT NOT NULL DEFAULT 'manuel' CHECK (source_maj IN (
    'reception', 'inventaire', 'vente', 'manuel'
  ))
);

-- 17. Modeles inventaires
CREATE TABLE modeles_inventaires (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT 'complet' CHECK (type IN ('complet', 'partiel')),
  zones UUID[] NOT NULL DEFAULT '{}',
  ingredients UUID[] NOT NULL DEFAULT '{}', -- for partial
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 18. Inventaires
CREATE TABLE inventaires (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  type TEXT NOT NULL DEFAULT 'complet' CHECK (type IN ('complet', 'partiel')),
  zones UUID[] NOT NULL DEFAULT '{}',
  statut TEXT NOT NULL DEFAULT 'en_cours' CHECK (statut IN ('en_cours', 'valide')),
  created_by UUID NOT NULL REFERENCES profiles(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 19. Inventaire lignes
CREATE TABLE inventaire_lignes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  inventaire_id UUID NOT NULL REFERENCES inventaires(id) ON DELETE CASCADE,
  ingredient_id UUID NOT NULL REFERENCES ingredients_restaurant(id),
  quantite_theorique NUMERIC NOT NULL DEFAULT 0,
  quantite_comptee NUMERIC NOT NULL DEFAULT 0,
  ecart NUMERIC NOT NULL DEFAULT 0,
  conditionnement_saisie TEXT,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 20. Ventes historique (Zelty daily CA)
CREATE TABLE ventes_historique (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  date DATE NOT NULL UNIQUE,
  ca_ttc NUMERIC NOT NULL DEFAULT 0,
  nb_tickets INTEGER NOT NULL DEFAULT 0,
  nb_couverts INTEGER,
  cloture_validee BOOLEAN NOT NULL DEFAULT false,
  zelty_closure_id TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 21. Meteo daily
CREATE TABLE meteo_daily (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  date DATE NOT NULL UNIQUE,
  temperature_max NUMERIC,
  temperature_min NUMERIC,
  precipitation_mm NUMERIC,
  ensoleillement_secondes NUMERIC,
  couverture_nuageuse_pct NUMERIC,
  code_meteo INTEGER, -- WMO weather code
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 22. Evenements
CREATE TABLE evenements (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  nom TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('ferie', 'vacances', 'soldes', 'custom')),
  date_debut DATE NOT NULL,
  date_fin DATE NOT NULL,
  coefficient NUMERIC NOT NULL DEFAULT 1.0,
  recurrent BOOLEAN NOT NULL DEFAULT false,
  notes TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 23. Factures PennyLane
CREATE TABLE factures_pennylane (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pennylane_id TEXT NOT NULL UNIQUE,
  fournisseur_id UUID REFERENCES fournisseurs(id),
  numero TEXT,
  date_facture DATE,
  montant_ht NUMERIC NOT NULL DEFAULT 0,
  montant_ttc NUMERIC NOT NULL DEFAULT 0,
  statut_rapprochement TEXT NOT NULL DEFAULT 'non_rapprochee' CHECK (statut_rapprochement IN (
    'non_rapprochee', 'rapprochee', 'ecart_detecte', 'depannage'
  )),
  reception_id UUID REFERENCES receptions(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 24. Achats hors commande (emergency purchases)
CREATE TABLE achats_hors_commande (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  facture_pennylane_id UUID REFERENCES factures_pennylane(id),
  fournisseur_nom TEXT NOT NULL,
  montant_ht NUMERIC NOT NULL DEFAULT 0,
  date_achat DATE NOT NULL DEFAULT CURRENT_DATE,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 25. Horaires ouverture
CREATE TABLE horaires_ouverture (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  jour_semaine INTEGER NOT NULL CHECK (jour_semaine BETWEEN 0 AND 6),
  heure_ouverture TEXT NOT NULL DEFAULT '10:00',
  heure_fermeture TEXT NOT NULL DEFAULT '22:00',
  est_ferme BOOLEAN NOT NULL DEFAULT false,
  source TEXT NOT NULL DEFAULT 'manuel' CHECK (source IN ('gbp', 'manuel')),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 26. Repartition horaire (hourly CA curves)
CREATE TABLE repartition_horaire (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  jour_semaine INTEGER NOT NULL CHECK (jour_semaine BETWEEN 0 AND 6),
  creneau_heure INTEGER NOT NULL CHECK (creneau_heure BETWEEN 10 AND 21),
  pourcentage NUMERIC NOT NULL DEFAULT 0,
  contexte TEXT NOT NULL DEFAULT 'standard' CHECK (contexte IN ('standard', 'vacances', 'samedi', 'dimanche')),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (jour_semaine, creneau_heure, contexte)
);

-- 27. Cron logs
CREATE TABLE cron_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  job_name TEXT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  finished_at TIMESTAMPTZ,
  status TEXT NOT NULL DEFAULT 'running' CHECK (status IN ('running', 'success', 'error')),
  duration_ms INTEGER,
  error_message TEXT
);

-- 28. Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  type TEXT NOT NULL,
  titre TEXT NOT NULL,
  message TEXT NOT NULL,
  lue BOOLEAN NOT NULL DEFAULT false,
  destinataire_id UUID REFERENCES profiles(id),
  reference_id UUID,
  reference_type TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX idx_mercuriale_fournisseur ON mercuriale(fournisseur_id);
CREATE INDEX idx_mercuriale_ingredient ON mercuriale(ingredient_restaurant_id);
CREATE INDEX idx_ingredients_categorie ON ingredients_restaurant(categorie);
CREATE INDEX idx_recette_ingredients_recette ON recette_ingredients(recette_id);
CREATE INDEX idx_recette_ingredients_ingredient ON recette_ingredients(ingredient_id);
CREATE INDEX idx_commandes_fournisseur ON commandes(fournisseur_id);
CREATE INDEX idx_commandes_statut ON commandes(statut);
CREATE INDEX idx_commandes_date ON commandes(date_commande);
CREATE INDEX idx_commande_lignes_commande ON commande_lignes(commande_id);
CREATE INDEX idx_receptions_commande ON receptions(commande_id);
CREATE INDEX idx_reception_lignes_reception ON reception_lignes(reception_id);
CREATE INDEX idx_historique_prix_mercuriale ON historique_prix(mercuriale_id);
CREATE INDEX idx_stocks_ingredient ON stocks(ingredient_id);
CREATE INDEX idx_ventes_date ON ventes_historique(date);
CREATE INDEX idx_meteo_date ON meteo_daily(date);
CREATE INDEX idx_notifications_destinataire ON notifications(destinataire_id, lue);
CREATE INDEX idx_cron_logs_job ON cron_logs(job_name, started_at);

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE config ENABLE ROW LEVEL SECURITY;
ALTER TABLE fournisseurs ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE ingredients_restaurant ENABLE ROW LEVEL SECURITY;
ALTER TABLE mercuriale ENABLE ROW LEVEL SECURITY;
ALTER TABLE historique_prix ENABLE ROW LEVEL SECURITY;
ALTER TABLE recettes ENABLE ROW LEVEL SECURITY;
ALTER TABLE recette_ingredients ENABLE ROW LEVEL SECURITY;
ALTER TABLE commandes ENABLE ROW LEVEL SECURITY;
ALTER TABLE commande_lignes ENABLE ROW LEVEL SECURITY;
ALTER TABLE receptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reception_lignes ENABLE ROW LEVEL SECURITY;
ALTER TABLE avoirs ENABLE ROW LEVEL SECURITY;
ALTER TABLE stocks ENABLE ROW LEVEL SECURITY;
ALTER TABLE zones_stockage ENABLE ROW LEVEL SECURITY;
ALTER TABLE modeles_inventaires ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventaires ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventaire_lignes ENABLE ROW LEVEL SECURITY;
ALTER TABLE ventes_historique ENABLE ROW LEVEL SECURITY;
ALTER TABLE meteo_daily ENABLE ROW LEVEL SECURITY;
ALTER TABLE evenements ENABLE ROW LEVEL SECURITY;
ALTER TABLE factures_pennylane ENABLE ROW LEVEL SECURITY;
ALTER TABLE achats_hors_commande ENABLE ROW LEVEL SECURITY;
ALTER TABLE horaires_ouverture ENABLE ROW LEVEL SECURITY;
ALTER TABLE repartition_horaire ENABLE ROW LEVEL SECURITY;
ALTER TABLE cron_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- RLS POLICIES
-- ============================================================

-- Profiles: users can read their own, admin can read all
CREATE POLICY "Users read own profile" ON profiles FOR SELECT USING (
  id = auth.uid() OR get_my_role() = 'admin'
);
CREATE POLICY "Admin manages profiles" ON profiles FOR ALL USING (
  get_my_role() = 'admin'
);

-- Config: admin only
CREATE POLICY "Admin manages config" ON config FOR ALL USING (
  get_my_role() = 'admin'
);
CREATE POLICY "All read config" ON config FOR SELECT USING (true);

-- Fournisseurs: all read, admin writes
CREATE POLICY "All read fournisseurs" ON fournisseurs FOR SELECT USING (true);
CREATE POLICY "Admin manages fournisseurs" ON fournisseurs FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates fournisseurs" ON fournisseurs FOR UPDATE USING (get_my_role() = 'admin');
CREATE POLICY "Admin deletes fournisseurs" ON fournisseurs FOR DELETE USING (get_my_role() = 'admin');

-- Categories: all read, admin writes
CREATE POLICY "All read categories" ON categories FOR SELECT USING (true);
CREATE POLICY "Admin manages categories" ON categories FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates categories" ON categories FOR UPDATE USING (get_my_role() = 'admin');

-- Mercuriale: all read, admin writes
CREATE POLICY "All read mercuriale" ON mercuriale FOR SELECT USING (true);
CREATE POLICY "Admin manages mercuriale" ON mercuriale FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates mercuriale" ON mercuriale FOR UPDATE USING (get_my_role() = 'admin');
CREATE POLICY "Admin deletes mercuriale" ON mercuriale FOR DELETE USING (get_my_role() = 'admin');

-- Historique prix: all read, admin + system writes
CREATE POLICY "All read historique_prix" ON historique_prix FOR SELECT USING (true);
CREATE POLICY "Admin manages historique_prix" ON historique_prix FOR INSERT USING (get_my_role() = 'admin');

-- Ingredients: all read, admin writes
CREATE POLICY "All read ingredients" ON ingredients_restaurant FOR SELECT USING (true);
CREATE POLICY "Admin manages ingredients" ON ingredients_restaurant FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates ingredients" ON ingredients_restaurant FOR UPDATE USING (get_my_role() = 'admin');

-- Recettes: all read, admin writes
CREATE POLICY "All read recettes" ON recettes FOR SELECT USING (true);
CREATE POLICY "Admin manages recettes" ON recettes FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates recettes" ON recettes FOR UPDATE USING (get_my_role() = 'admin');

-- Recette ingredients: all read, admin writes
CREATE POLICY "All read recette_ingredients" ON recette_ingredients FOR SELECT USING (true);
CREATE POLICY "Admin manages recette_ingredients" ON recette_ingredients FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates recette_ingredients" ON recette_ingredients FOR UPDATE USING (get_my_role() = 'admin');
CREATE POLICY "Admin deletes recette_ingredients" ON recette_ingredients FOR DELETE USING (get_my_role() = 'admin');

-- Commandes: all read, all create drafts, admin/manager validate
CREATE POLICY "All read commandes" ON commandes FOR SELECT USING (true);
CREATE POLICY "All create commandes" ON commandes FOR INSERT WITH CHECK (true);
CREATE POLICY "Update commandes by role" ON commandes FOR UPDATE USING (
  get_my_role() IN ('admin', 'manager')
  OR (get_my_role() = 'operator' AND statut = 'brouillon')
);

-- Commande lignes: follow commande access
CREATE POLICY "All read commande_lignes" ON commande_lignes FOR SELECT USING (true);
CREATE POLICY "All manage commande_lignes" ON commande_lignes FOR INSERT WITH CHECK (true);
CREATE POLICY "All update commande_lignes" ON commande_lignes FOR UPDATE USING (true);
CREATE POLICY "All delete commande_lignes" ON commande_lignes FOR DELETE USING (true);

-- Receptions: all read, all create, admin/manager validate
CREATE POLICY "All read receptions" ON receptions FOR SELECT USING (true);
CREATE POLICY "All create receptions" ON receptions FOR INSERT WITH CHECK (true);
CREATE POLICY "Admin/Manager validate receptions" ON receptions FOR UPDATE USING (
  get_my_role() IN ('admin', 'manager')
);

-- Reception lignes
CREATE POLICY "All read reception_lignes" ON reception_lignes FOR SELECT USING (true);
CREATE POLICY "All manage reception_lignes" ON reception_lignes FOR INSERT WITH CHECK (true);
CREATE POLICY "All update reception_lignes" ON reception_lignes FOR UPDATE USING (true);

-- Avoirs: admin/manager only
CREATE POLICY "All read avoirs" ON avoirs FOR SELECT USING (true);
CREATE POLICY "Admin/Manager manage avoirs" ON avoirs FOR INSERT WITH CHECK (
  get_my_role() IN ('admin', 'manager')
);
CREATE POLICY "Admin/Manager update avoirs" ON avoirs FOR UPDATE USING (
  get_my_role() IN ('admin', 'manager')
);

-- Stocks: all read, admin manages
CREATE POLICY "All read stocks" ON stocks FOR SELECT USING (true);
CREATE POLICY "Admin manages stocks" ON stocks FOR ALL USING (get_my_role() = 'admin');

-- Zones stockage: all read, admin writes
CREATE POLICY "All read zones" ON zones_stockage FOR SELECT USING (true);
CREATE POLICY "Admin manages zones" ON zones_stockage FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates zones" ON zones_stockage FOR UPDATE USING (get_my_role() = 'admin');

-- Inventaires: all read/create, admin validates
CREATE POLICY "All read inventaires" ON inventaires FOR SELECT USING (true);
CREATE POLICY "All create inventaires" ON inventaires FOR INSERT WITH CHECK (true);
CREATE POLICY "Admin validates inventaires" ON inventaires FOR UPDATE USING (
  get_my_role() = 'admin' OR statut = 'en_cours'
);

CREATE POLICY "All read inventaire_lignes" ON inventaire_lignes FOR SELECT USING (true);
CREATE POLICY "All manage inventaire_lignes" ON inventaire_lignes FOR INSERT WITH CHECK (true);
CREATE POLICY "All update inventaire_lignes" ON inventaire_lignes FOR UPDATE USING (true);

-- Read-only data tables: all read
CREATE POLICY "All read ventes" ON ventes_historique FOR SELECT USING (true);
CREATE POLICY "All read meteo" ON meteo_daily FOR SELECT USING (true);
CREATE POLICY "All read evenements" ON evenements FOR SELECT USING (true);
CREATE POLICY "Admin manages evenements" ON evenements FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates evenements" ON evenements FOR UPDATE USING (get_my_role() = 'admin');

CREATE POLICY "All read factures" ON factures_pennylane FOR SELECT USING (true);
CREATE POLICY "All read achats_hors_commande" ON achats_hors_commande FOR SELECT USING (true);
CREATE POLICY "All read horaires" ON horaires_ouverture FOR SELECT USING (true);
CREATE POLICY "All read repartition" ON repartition_horaire FOR SELECT USING (true);
CREATE POLICY "All read cron_logs" ON cron_logs FOR SELECT USING (true);

-- Notifications: user reads their own
CREATE POLICY "Users read own notifications" ON notifications FOR SELECT USING (
  destinataire_id = auth.uid() OR destinataire_id IS NULL
);
CREATE POLICY "Users update own notifications" ON notifications FOR UPDATE USING (
  destinataire_id = auth.uid()
);

-- Modeles inventaires
CREATE POLICY "All read modeles" ON modeles_inventaires FOR SELECT USING (true);
CREATE POLICY "Admin manages modeles" ON modeles_inventaires FOR INSERT USING (get_my_role() = 'admin');
CREATE POLICY "Admin updates modeles" ON modeles_inventaires FOR UPDATE USING (get_my_role() = 'admin');

-- ============================================================
-- SEED DATA: Default zones de stockage
-- ============================================================
INSERT INTO zones_stockage (nom, description, ordre) VALUES
  ('Chambre froide positive', 'Produits frais (2-4°C) : viandes, légumes, produits laitiers', 1),
  ('Chambre froide négative', 'Produits surgelés (-18°C) : nems, produits congelés, glaces', 2),
  ('Réserve sèche', 'Épicerie : sauces, épices, riz, nouilles', 3),
  ('Bar / Boissons', 'Boissons : sodas, bières, café, thé', 4);

-- Default config
INSERT INTO config (seuil_ecart_prix_pct, delai_alerte_avoir_heures, delai_expiration_avoir_heures) VALUES (10, 48, 72);
