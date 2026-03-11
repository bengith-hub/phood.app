-- Add missing DELETE policy on recettes table.
-- Without this, RLS silently blocks all DELETE operations (returns 0 rows, no error).
DO $$ BEGIN
  CREATE POLICY "Admin deletes recettes"
    ON recettes
    FOR DELETE
    USING (get_my_role() = 'admin');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
