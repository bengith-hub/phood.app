-- Drop obsolete logo_url column (replaced by site_web + Clearbit)
-- IF EXISTS ensures this is safe even if column was never created
ALTER TABLE fournisseurs DROP COLUMN IF EXISTS logo_url;
