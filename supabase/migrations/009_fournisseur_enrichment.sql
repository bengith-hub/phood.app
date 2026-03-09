-- Add new columns for supplier enrichment (PennyLane, site web, BCC emails)

ALTER TABLE fournisseurs ADD COLUMN IF NOT EXISTS email_commande_bcc TEXT;
ALTER TABLE fournisseurs ADD COLUMN IF NOT EXISTS site_web TEXT;
ALTER TABLE fournisseurs ADD COLUMN IF NOT EXISTS siret TEXT;
ALTER TABLE fournisseurs ADD COLUMN IF NOT EXISTS pennylane_supplier_id TEXT;

COMMENT ON COLUMN fournisseurs.email_commande_bcc IS 'Adresses email en copie cachée pour les commandes (séparées par ;)';
COMMENT ON COLUMN fournisseurs.site_web IS 'URL du site web fournisseur (utilisé pour afficher le logo via Clearbit)';
COMMENT ON COLUMN fournisseurs.siret IS 'Numéro SIRET/SIREN du fournisseur';
COMMENT ON COLUMN fournisseurs.pennylane_supplier_id IS 'ID du fournisseur dans PennyLane (pour enrichissement et rapprochement)';
