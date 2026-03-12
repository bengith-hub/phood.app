-- Add source side of conversion (left side: e.g. "5 kg" in "5 kg = 1000 unite")
-- Formula: cout = prix_unitaire_ht × conversion_source_quantite / conversion_quantite
ALTER TABLE mercuriale ADD COLUMN IF NOT EXISTS conversion_source_quantite NUMERIC;
ALTER TABLE mercuriale ADD COLUMN IF NOT EXISTS conversion_source_unite TEXT;

-- Migrate existing conversion data: set source from coefficient_conversion + unite_facturation
UPDATE mercuriale
SET conversion_source_quantite = coefficient_conversion,
    conversion_source_unite = COALESCE(unite_facturation, unite_commande)
WHERE conversion_quantite IS NOT NULL;
