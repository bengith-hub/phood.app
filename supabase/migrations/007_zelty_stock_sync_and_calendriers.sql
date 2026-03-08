-- ============================================================
-- 007_zelty_stock_sync_and_calendriers.sql
-- Add stock sync CRON job + unique constraint for evenements upsert
-- ============================================================

-- 1. Add unique constraint on evenements for calendar upsert
-- This allows the calendriers module to upsert jours fériés, vacances, soldes
ALTER TABLE evenements ADD CONSTRAINT evenements_nom_date_debut_key
  UNIQUE (nom, date_debut);

-- 2. Add pg_cron job for stock decrement (runs after sync-zelty-ca at 06:15)
SELECT cron.schedule(
  'sync-zelty-stock',
  '15 5 * * *',
  $$
  SELECT net.http_post(
    url := 'https://pfcvtpavwjchwdarhixc.supabase.co/functions/v1/sync-zelty-stock',
    headers := jsonb_build_object(
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- 3. Create Supabase Storage buckets (if they don't exist)
-- Must be run via Supabase Dashboard or supabase CLI:
-- supabase storage create bl-photos --public false
-- supabase storage create anomalies --public false
-- supabase storage create pdfs --public false
-- supabase storage create packaging --public false

-- 4. Add recette_ingredients table (if not already in initial schema)
-- This table links recettes to their ingredients/sub-recipes
CREATE TABLE IF NOT EXISTS recette_ingredients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  recette_id UUID NOT NULL REFERENCES recettes(id) ON DELETE CASCADE,
  ingredient_id UUID REFERENCES ingredients_restaurant(id),
  sous_recette_id UUID REFERENCES recettes(id),
  quantite NUMERIC NOT NULL DEFAULT 0,
  unite TEXT NOT NULL DEFAULT 'kg',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CHECK (
    (ingredient_id IS NOT NULL AND sous_recette_id IS NULL) OR
    (ingredient_id IS NULL AND sous_recette_id IS NOT NULL)
  )
);

CREATE INDEX IF NOT EXISTS idx_recette_ingredients_recette ON recette_ingredients(recette_id);
CREATE INDEX IF NOT EXISTS idx_recette_ingredients_ingredient ON recette_ingredients(ingredient_id);
CREATE INDEX IF NOT EXISTS idx_recette_ingredients_sous_recette ON recette_ingredients(sous_recette_id);
