-- Add missing DELETE policies on stocks and inventaire_lignes tables.
-- Needed for cascading ingredient deletion from the frontend.
DO $$ BEGIN
  CREATE POLICY "Admin deletes stocks"
    ON stocks
    FOR DELETE
    USING (get_my_role() = 'admin');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$ BEGIN
  CREATE POLICY "Admin deletes inventaire_lignes"
    ON inventaire_lignes
    FOR DELETE
    USING (get_my_role() = 'admin');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
