-- Add conversion fields to mercuriale for cross-unit costing
-- Stores the equivalence: coefficient_conversion unite_facturation = conversion_quantite conversion_unite
-- Example: 5 kg = 1000 unite (sucre dose: 5kg colis contains 1000 dosettes)
ALTER TABLE mercuriale ADD COLUMN IF NOT EXISTS conversion_quantite NUMERIC;
ALTER TABLE mercuriale ADD COLUMN IF NOT EXISTS conversion_unite TEXT;
