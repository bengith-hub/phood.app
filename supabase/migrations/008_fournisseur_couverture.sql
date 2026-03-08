-- Add default coverage duration per supplier (in days)
ALTER TABLE fournisseurs ADD COLUMN IF NOT EXISTS duree_couverture_defaut integer DEFAULT 5;

COMMENT ON COLUMN fournisseurs.duree_couverture_defaut IS 'Durée de couverture par défaut en jours pour les commandes';
