-- Add default extra quantity per ingredient
-- Used when linking an ingredient to an "Extra" option on any recipe
-- e.g., Extra Ciboulette = always 10g, Extra Poulet = always 60g
ALTER TABLE ingredients_restaurant
  ADD COLUMN IF NOT EXISTS quantite_extra NUMERIC,
  ADD COLUMN IF NOT EXISTS unite_extra TEXT;

COMMENT ON COLUMN ingredients_restaurant.quantite_extra IS 'Default quantity for Extra options (e.g., 10 for 10g of ciboulette)';
COMMENT ON COLUMN ingredients_restaurant.unite_extra IS 'Unit for quantite_extra (defaults to unite_stock if null)';
