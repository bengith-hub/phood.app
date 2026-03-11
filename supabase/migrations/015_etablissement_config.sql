-- Add etablissement (restaurant identity) columns to config table
-- Replaces hardcoded RESTAURANT constant in pdf-commande.ts
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_nom TEXT DEFAULT 'Phood Restaurant';
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_slogan TEXT DEFAULT 'Manger Viet & Bien';
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_adresse TEXT DEFAULT 'Galerie CC Rives d''Arcins';
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_code_postal TEXT DEFAULT '33130';
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_ville TEXT DEFAULT 'Bègles';
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_telephone TEXT DEFAULT '07 60 49 43 11';
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_email TEXT DEFAULT 'team.begles@phood-restaurant.fr';
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_contact TEXT;
ALTER TABLE config ADD COLUMN IF NOT EXISTS etablissement_creneaux_livraison TEXT;
