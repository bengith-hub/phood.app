-- ============================================================
-- 014_backup_drive_cron.sql
-- Add daily Google Drive backup CRON job at 04:00 Paris (03:00 UTC winter)
-- ============================================================

-- 5. Backup to Google Drive — Daily at 04:00 Paris (03:00 UTC winter / 02:00 UTC summer)
SELECT cron.schedule(
  'backup-drive',
  '0 3 * * *',
  $$
  SELECT net.http_post(
    url := 'https://pfcvtpavwjchwdarhixc.supabase.co/functions/v1/backup-drive',
    headers := jsonb_build_object(
      'Authorization', 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmY3Z0cGF2d2pjaHdkYXJoaXhjIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3Mjc5MDA5MywiZXhwIjoyMDg4MzY2MDkzfQ.4SrufD-jJHa1JrH0Ma20potu7XiOnFWEY7XlFldCEbM',
      'Content-Type', 'application/json'
    ),
    body := '{}'::jsonb
  );
  $$
);
