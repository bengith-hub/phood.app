-- ============================================================
-- 004_cron_jobs.sql
-- pg_cron + pg_net scheduling for daily Edge Functions
-- ============================================================
-- Prerequisites:
--   1. Enable pg_cron extension in Supabase Dashboard > Database > Extensions
--   2. Enable pg_net extension in Supabase Dashboard > Database > Extensions
--   3. Deploy Edge Functions: supabase functions deploy
--   4. Replace pfcvtpavwjchwdarhixc with your Supabase project reference
--   5. Replace eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM with your service role key
-- ============================================================

-- Enable extensions (must be done by superuser / via Dashboard first)
-- CREATE EXTENSION IF NOT EXISTS pg_cron;
-- CREATE EXTENSION IF NOT EXISTS pg_net;

-- ============================================================
-- CRON JOBS
-- Architecture: pg_cron → pg_net (HTTP POST) → Edge Function
-- All times in UTC (France = UTC+1 winter / UTC+2 summer)
-- Adjust cron expressions for your timezone offset
-- ============================================================

-- 1. Sync CA Zelty — Daily at 06:00 Paris (05:00 UTC winter / 04:00 UTC summer)
SELECT cron.schedule(
  'sync-zelty-ca',
  '0 5 * * *',
  $$
  SELECT net.http_post(
    url := 'https://pfcvtpavwjchwdarhixc.supabase.co/functions/v1/sync-zelty-ca',
    headers := jsonb_build_object(
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- 2. Sync factures PennyLane — Daily at 06:30 Paris (05:30 UTC winter)
SELECT cron.schedule(
  'sync-pennylane',
  '30 5 * * *',
  $$
  SELECT net.http_post(
    url := 'https://pfcvtpavwjchwdarhixc.supabase.co/functions/v1/sync-pennylane',
    headers := jsonb_build_object(
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- 3. Sync meteo Open-Meteo — Daily at 07:00 Paris (06:00 UTC winter)
SELECT cron.schedule(
  'sync-meteo',
  '0 6 * * *',
  $$
  SELECT net.http_post(
    url := 'https://pfcvtpavwjchwdarhixc.supabase.co/functions/v1/sync-meteo',
    headers := jsonb_build_object(
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- 4. Sync horaires GBP — Daily at 07:30 Paris (06:30 UTC winter)
SELECT cron.schedule(
  'sync-gbp-hours',
  '30 6 * * *',
  $$
  SELECT net.http_post(
    url := 'https://pfcvtpavwjchwdarhixc.supabase.co/functions/v1/sync-gbp-hours',
    headers := jsonb_build_object(
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);

-- ============================================================
-- NOTES
-- ============================================================
-- To list scheduled jobs:
--   SELECT * FROM cron.job;
--
-- To see job execution history:
--   SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 20;
--
-- To unschedule a job:
--   SELECT cron.unschedule('sync-zelty-ca');
--
-- App-level logs are in the cron_logs table (written by Edge Functions)
--
-- For summer time (UTC+2), adjust cron hours -1:
--   06:00 Paris = 04:00 UTC (summer)
--   Consider using a single cron at 03:50 UTC that checks timezone
-- ============================================================
