-- Add Google Calendar ID to config for delivery/order event sync
ALTER TABLE config ADD COLUMN IF NOT EXISTS google_calendar_id TEXT;
