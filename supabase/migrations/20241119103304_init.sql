-- POSTGIS: INIT ----------------------------------------------------
DROP SCHEMA IF EXISTS "gis" CASCADE;
CREATE SCHEMA "gis";
CREATE EXTENSION IF NOT EXISTS "postgis" WITH SCHEMA "gis";
GRANT USAGE ON SCHEMA "gis" to anon;