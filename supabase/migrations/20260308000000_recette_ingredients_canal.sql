-- ============================================================
-- 012_recette_ingredients_canal.sql
-- Add sur_place / emporter booleans on recette_ingredients
-- so each ingredient line can be toggled per sales channel.
-- Example: "Boite Finger Phood" only for emporter/livraison.
-- ============================================================

ALTER TABLE recette_ingredients
  ADD COLUMN IF NOT EXISTS sur_place BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS emporter  BOOLEAN NOT NULL DEFAULT true;

COMMENT ON COLUMN recette_ingredients.sur_place IS 'Ingredient used when order is sur place';
COMMENT ON COLUMN recette_ingredients.emporter  IS 'Ingredient used when order is emporter / livraison';
