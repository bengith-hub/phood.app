-- Migration: Add unified 'options' column (replaces variantes + modificateurs)
-- RecetteOption[] = [{nom, type, zelty_option_value_id?, coefficient?, prix_supplement?, impact_stock?}]
ALTER TABLE recettes ADD COLUMN IF NOT EXISTS options JSONB;

-- Comment for documentation
COMMENT ON COLUMN recettes.options IS 'Unified options array: [{nom, type: taille|extra|sans|choix, zelty_option_value_id?, coefficient?, prix_supplement?, impact_stock?}]';
