-- Add lignes_avoir JSONB to store anomaly line details for credit note emails
-- Format: [{designation, sku, quantite_commandee, quantite_recue, prix_unitaire_bc, prix_unitaire_bl, anomalie_type, anomalie_detail, balance}]
ALTER TABLE avoirs ADD COLUMN IF NOT EXISTS lignes_avoir JSONB DEFAULT '[]'::jsonb;

-- Add commande_id for direct link to order (useful for email subject line)
ALTER TABLE avoirs ADD COLUMN IF NOT EXISTS commande_id UUID REFERENCES commandes(id);

-- Add email_envoye flag to distinguish "envoyee" (email sent) vs "validee sans envoi"
ALTER TABLE avoirs ADD COLUMN IF NOT EXISTS email_envoye BOOLEAN NOT NULL DEFAULT false;

-- Add commentaire for operator notes on the avoir request
ALTER TABLE avoirs ADD COLUMN IF NOT EXISTS commentaire TEXT;

-- Add photos_anomalies for attached anomaly photos
ALTER TABLE avoirs ADD COLUMN IF NOT EXISTS photos_anomalies TEXT[] DEFAULT '{}';
