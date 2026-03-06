-- ============================================================
-- 005_places_api_horaires.sql
-- Switch horaires_ouverture source from GBP API to Google Places API
-- GBP API requires special access approval (denied) — Places API is open
-- ============================================================

-- Update CHECK constraint to accept 'places' as a source
ALTER TABLE horaires_ouverture DROP CONSTRAINT IF EXISTS horaires_ouverture_source_check;
ALTER TABLE horaires_ouverture ADD CONSTRAINT horaires_ouverture_source_check
  CHECK (source IN ('gbp', 'places', 'manuel'));
