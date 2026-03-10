-- =============================================================================
-- Migration 011: Fix Préparation type + deactivate packaging & duplicates
-- =============================================================================
-- 1. Convert "Préparation" category recipes to sous_recette (94)
--    These are internal preparations (bases, sauces) mislabeled as recette
-- 2. Deactivate "Kit boitage" category (14) — packaging, not food
-- 3. Deactivate duplicate "Bière Saigon" without Zelty SKU
-- =============================================================================

-- 1. Fix type for Préparation category: these are sous-recettes
--    They were imported with isIngredient=false but are internal preparations
UPDATE recettes SET type = 'sous_recette', updated_at = now()
WHERE categorie = 'Préparation' AND type = 'recette';

-- 2. Deactivate Kit boitage (packaging kits, not food recipes)
UPDATE recettes SET actif = false, updated_at = now()
WHERE categorie = 'Kit boitage' AND actif = true;

-- 3. Deactivate duplicate "Bière Saigon" (the one without zelty_product_id)
--    Keep "BIERE SAIGON" which has sku=D30FB1
UPDATE recettes SET actif = false, updated_at = now()
WHERE nom = 'Bière Saigon'
  AND (zelty_product_id IS NULL OR zelty_product_id = '')
  AND actif = true;

-- Log results
DO $$
DECLARE
  sous_cnt integer;
  inactive_cnt integer;
BEGIN
  SELECT count(*) INTO sous_cnt FROM recettes WHERE categorie = 'Préparation' AND type = 'sous_recette';
  SELECT count(*) INTO inactive_cnt FROM recettes WHERE actif = false;
  RAISE NOTICE 'Préparation recipes converted to sous_recette: %', sous_cnt;
  RAISE NOTICE 'Total inactive recipes: %', inactive_cnt;
END $$;
