-- SEED USERS --- START
CREATE OR REPLACE FUNCTION create_user(email text) RETURNS UUID
AS $$
DECLARE
user_id uuid;
BEGIN
user_id := gen_random_uuid();

INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  recovery_sent_at,
  last_sign_in_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
)
VALUES
  (
  '00000000-0000-0000-0000-000000000000',
  user_id,
  'authenticated',
  'authenticated',
  email,
  extensions.crypt('123456', extensions.gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
  );

INSERT INTO
    auth.identities (
    id,
    user_id,
    identity_data,
    provider_id,
    provider,
    last_sign_in_at,
    created_at,
    updated_at
    )
VALUES
    (
    gen_random_uuid(),
    user_id,
    format('{"sub":"%s","email":"%s"}', user_id::text, email)::jsonb,
    gen_random_uuid(),
    'email',
    NOW(),
    NOW(),
    NOW()
    );

    RETURN user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- pl/pgsql wrapper is required in order to execute function when seeding
DO $$
DECLARE
    unames TEXT[] := ARRAY['vikki', 'hannah', 'georgia', 'riona', 'david'];
    uname TEXT;
BEGIN    
    -- delete existing users
    DELETE FROM auth.users;

    FOREACH uname IN ARRAY unames LOOP
        PERFORM create_user(uname || '@nc.dev');
    END LOOP;
END $$;

DROP FUNCTION create_user;
-- SEED USERS --- END

-- SEED MARKERS -- START
CREATE TYPE temp_marker_type AS (
    title TEXT,
    long FLOAT,
    lat FLOAT
);

DO $$
DECLARE
    arr temp_marker_type[];
    m temp_marker_type;
BEGIN
    arr := ARRAY [
        ('Emmeline Pankhurst Statue', -2.243056, 53.477778),
        ('Mamucium Roman Fort Reconstruction', -2.2588591, 53.4754896),
        ('Manchester Cathedral', -2.2490792, 53.4851459),
        ('Alan Turing Memorial', -2.2407774, 53.4767288),
        ('Manchester Library', -2.24465105455576, 53.4781646404297),
        ('Manchester Central Station', -2.24755952549251, 53.4763296030546),
        ('NC Office', -2.23810383341322, 53.4721719765798),
        ('Roman Gardens', -2.25364964134124, 53.4757504929768),
        ('Town Hall', -2.24427094085326, 53.4791958537723),
        ('Midland hotel', -2.24531978438671, 53.4771245864725),
        ('Manchester Art Gallery', -2.23988384178912, 53.4783760685976),
        ('Old Wellington Pub', -2.24394875223936, 53.4846719494712),
        ('Manchester Opera House', -2.25143518962375, 53.478906018399),
        ('Victoria Station', -2.24237366247465, 53.4878963937225),
        ('Manchester Museum', -2.2368268, 53.4664686)
    ];

    FOREACH m IN ARRAY arr LOOP
        INSERT INTO markers (title, longitude, latitude, user_id)
            VALUES 
                (m.title, m.long, m.lat, (CASE WHEN RANDOM() < 0.3 THEN NULL ELSE (SELECT user_id FROM profiles ORDER BY RANDOM() LIMIT 1) END))
            ;
    END LOOP;
END $$;

DROP TYPE temp_marker_type;
-- SEED MARKERS --- END

-- SEED VOTES --- START
DO $$
DECLARE
  uid UUID;
  mid INT;
  lim INT;
  val INT;
BEGIN
  FOR uid IN (SELECT user_id FROM profiles) LOOP
    lim := (SELECT random() * 10)::int;

    IF lim = 0 THEN
        lim := 1;
    END IF;

    FOR mid IN (SELECT marker_id FROM markers ORDER BY random() LIMIT lim) LOOP
      val := (SELECT random() * 5)::int;

      IF val = 0 THEN
          val := 1;
      END IF;

      INSERT INTO votes (user_id, marker_id, value)
        VALUES (uid, mid, val)
      ;
    END LOOP;
  END LOOP;
END $$;
-- SEED VOTES --- END

-- SEED PLANNERS --- START
DO $$
DECLARE
  pid INT;
  mid INT;
  lim INT;
BEGIN
  FOR pid IN (SELECT planner_id FROM planners) LOOP
    lim := (SELECT random() * 5)::int;

    IF lim = 0 THEN
        lim := 1;
    END IF;

    FOR mid IN (SELECT marker_id FROM markers ORDER BY random() LIMIT lim) LOOP
      INSERT INTO planners_markers (planner_id, marker_id)
        VALUES (pid, mid)
      ;
    END LOOP;
  END LOOP;
END $$;
-- SEED PLANNERS --- END