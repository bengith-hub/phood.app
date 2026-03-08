-- ============================================================
-- 006_fix_trigger_and_admin.sql
-- Fix handle_new_user trigger + create admin account
-- ============================================================

-- 1. Fix the trigger function with proper search_path and error handling
-- The original trigger may fail if search_path is not set correctly
-- in newer Supabase versions that enforce restricted search_path
CREATE OR REPLACE FUNCTION handle_new_user() RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, email, nom, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.email, ''),
    COALESCE(
      NEW.raw_user_meta_data->>'full_name',
      NEW.raw_user_meta_data->>'name',
      split_part(COALESCE(NEW.email, 'user'), '@', 1)
    ),
    COALESCE(NEW.raw_user_meta_data->>'role', 'operator')
  );
  RETURN NEW;
EXCEPTION
  WHEN unique_violation THEN
    -- Profile already exists, skip
    RETURN NEW;
  WHEN OTHERS THEN
    -- Log but don't block user creation
    RAISE WARNING 'handle_new_user failed for %: %', NEW.id, SQLERRM;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- 2. Recreate the trigger (DROP + CREATE to ensure it uses new function)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- 3. Grant necessary permissions
GRANT USAGE ON SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON public.profiles TO postgres, service_role;
GRANT SELECT, UPDATE ON public.profiles TO authenticated;

-- 4. Create admin profile for Benjamin (if user already exists in auth.users)
-- This INSERT will be skipped if the profile already exists
-- Run this AFTER creating the user via Supabase Auth admin API or Dashboard
DO $$
BEGIN
  -- Update existing profile to admin if it exists
  UPDATE public.profiles
  SET role = 'admin', nom = 'Benjamin Fetu'
  WHERE email = 'benjamin.fetu@phood-restaurant.fr';

  IF NOT FOUND THEN
    RAISE NOTICE 'No profile found for benjamin.fetu@phood-restaurant.fr. Create the auth user first via Dashboard > Authentication > Add User.';
  END IF;
END $$;

-- 5. Ensure RLS is enabled but allows the trigger to insert
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policy: users can read their own profile
DROP POLICY IF EXISTS "Users can read own profile" ON public.profiles;
CREATE POLICY "Users can read own profile" ON public.profiles
  FOR SELECT USING (auth.uid() = id);

-- Policy: admins can read all profiles
DROP POLICY IF EXISTS "Admins can read all profiles" ON public.profiles;
CREATE POLICY "Admins can read all profiles" ON public.profiles
  FOR SELECT USING (get_my_role() = 'admin');

-- Policy: admins can update profiles
DROP POLICY IF EXISTS "Admins can update profiles" ON public.profiles;
CREATE POLICY "Admins can update profiles" ON public.profiles
  FOR UPDATE USING (get_my_role() = 'admin');

-- Policy: service role can do anything (needed for trigger)
DROP POLICY IF EXISTS "Service role full access" ON public.profiles;
CREATE POLICY "Service role full access" ON public.profiles
  FOR ALL USING (auth.role() = 'service_role');
