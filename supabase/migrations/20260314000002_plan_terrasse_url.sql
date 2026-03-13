-- Add plan_terrasse_url to config
ALTER TABLE config ADD COLUMN IF NOT EXISTS plan_terrasse_url TEXT;
