-- Storage RLS policies for taches-photos bucket
-- Allows all authenticated users to upload and read task photos

CREATE POLICY "Auth users can upload taches-photos"
ON storage.objects FOR INSERT
WITH CHECK (bucket_id = 'taches-photos' AND auth.role() = 'authenticated');

CREATE POLICY "Auth users can read taches-photos"
ON storage.objects FOR SELECT
USING (bucket_id = 'taches-photos' AND auth.role() = 'authenticated');
