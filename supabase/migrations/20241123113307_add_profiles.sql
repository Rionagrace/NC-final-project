-- CREATE TABLE
DROP TABLE IF EXISTS profiles CASCADE;
CREATE TABLE profiles (
  user_id UUID NOT NULL REFERENCES auth.users ON DELETE CASCADE,
  username VARCHAR UNIQUE,
  PRIMARY KEY (user_id)
);

-- HANDLE NEW USER
CREATE OR REPLACE FUNCTION public.handle_new_user()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  SECURITY DEFINER SET search_path = ''
  AS $$
  BEGIN
    INSERT INTO public.profiles (user_id)
      VALUES (new.id);
    RETURN new;
  END;
  $$;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
    FOR EACH ROW
      EXECUTE PROCEDURE public.handle_new_user();