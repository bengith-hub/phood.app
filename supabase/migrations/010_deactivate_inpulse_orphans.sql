-- =============================================================================
-- Migration 010: Deactivate imported Inpulse recipes that are no longer used
-- =============================================================================
-- This migration marks as inactive:
--   1. "Test" category recipes (29) — test data from Inpulse
--   2. NULL category recipes (1) — "Bière pression (pinte) KGB"
--   3. EMP/LIV variant recipes (77) — delivery/takeaway duplicates of base recipes
--   4. Exact name duplicates (2) — BBT FRUITY PASSION, SUPP "POULET"
-- Total: ~109 recipes deactivated
-- =============================================================================

-- 1. Deactivate all "Test" category recipes
UPDATE recettes SET actif = false, updated_at = now()
WHERE categorie = 'Test' AND actif = true;

-- 2. Deactivate EMP/LIV variants (delivery/takeaway duplicates)
--    These are duplicates of base recipes with different pricing for emporter/livraison
UPDATE recettes SET actif = false, updated_at = now()
WHERE actif = true
  AND (nom LIKE '%EMP/LIV%' OR nom LIKE '%EMP/%' OR nom LIKE '% LIV');

-- 3. Deactivate recipes with no category (orphan imports)
UPDATE recettes SET actif = false, updated_at = now()
WHERE categorie IS NULL AND actif = true;

-- 4. Deactivate known exact duplicates from import
--    BBT FRUITY PASSION (duplicate of existing)
--    SUPP "POULET" (duplicate of existing)
UPDATE recettes SET actif = false, updated_at = now()
WHERE id IN (
  'd6d629c0-3084-11ee-af48-fb839ee61b42',  -- BBT FRUITY PASSION (duplicate)
  'f1ee92d0-3082-11ee-af48-fb839ee61b42'   -- SUPP "POULET" (duplicate)
) AND actif = true;

-- Log the results
DO $$
DECLARE
  cnt integer;
BEGIN
  SELECT count(*) INTO cnt FROM recettes WHERE actif = false;
  RAISE NOTICE 'Total inactive recipes after cleanup: %', cnt;
END $$;
