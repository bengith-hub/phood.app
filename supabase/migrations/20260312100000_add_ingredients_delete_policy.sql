-- Add missing DELETE policy on ingredients_restaurant table.
-- Without this, RLS silently blocks all DELETE operations (returns 0 rows, no error).
DO $$ BEGIN
  CREATE POLICY "Admin deletes ingredients"
    ON ingredients_restaurant
    FOR DELETE
    USING (get_my_role() = 'admin');
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
