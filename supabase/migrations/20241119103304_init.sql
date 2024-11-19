-- CLEANUP ----------------------------------------------------------
do $$ declare
    r record;
begin
    for r in (select tablename from pg_tables where schemaname = 'public') loop
        execute 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
    end loop;
end $$;

-- POSTGIS: INIT ----------------------------------------------------
DROP SCHEMA IF EXISTS gis CASCADE;
CREATE SCHEMA gis;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA gis;
GRANT USAGE ON SCHEMA gis to anon;