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

-- TABLE: USERS -----------------------------------------------------
CREATE TABLE "users" (
  "user_id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "username" varchar UNIQUE NOT NULL
);

-- TABLE: CATEGORIES ------------------------------------------------
CREATE TABLE "categories" (
  "category_id" serial PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);

-- TABLE: MARKERS ---------------------------------------------------
CREATE TABLE "markers" (
  "marker_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "description" varchar(255),
  "address" varchar,
  "lon" float,
  "lat" float,
  "location" gis.geography(POINT) NOT NULL,
  "user_id" uuid
);
ALTER TABLE "markers" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");
CREATE INDEX geo_markers ON markers USING GIST (location);

-- FUNCTION: NEARBY_MARKERS -----------------------------------------
DROP FUNCTION IF EXISTS nearby_markers;
CREATE FUNCTION nearby_markers(lat float, lon float, distance int)
    RETURNS TABLE (
        marker_id markers.marker_id%TYPE,
        title markers.title%TYPE,
        lat float,
        lon float,
        distance_meters float
        )
    LANGUAGE SQL
    as $$
        SELECT  marker_id,
                title,
                gis.st_y(location::gis.geometry) as lat,
                gis.st_x(location::gis.geometry) as lon,
                gis.st_distance(location, gis.st_point(lon, lat)::gis.geography) as distance_meters
        FROM markers
        WHERE gis.st_dwithin(location, gis.st_point(lon, lat)::gis.geography, distance)
        ORDER BY distance_meters ASC
    $$;

-- TABLE: MARKERS CATEGORIES ----------------------------------------
CREATE TABLE "markers_categories" (
  "category_id" serial,
  "marker_id" serial,
  "order" int
);
ALTER TABLE "markers_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id");
ALTER TABLE "markers_categories" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");

-- TABLE: VOTES -----------------------------------------------------
CREATE TABLE "votes" (
  "user_id" uuid,
  "marker_id" serial,
  "value" int
);
CREATE UNIQUE INDEX ON "votes" ("user_id", "marker_id");
ALTER TABLE "votes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");
ALTER TABLE "votes" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");

-- TABLE: TOURS -----------------------------------------------------
CREATE TABLE "tours" (
  "tour_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "description" varchar(255)
);

-- TABLE: TOURS MARKERS ---------------------------------------------
CREATE TABLE "tours_markers" (
  "tour_id" serial,
  "marker_id" serial,
  "sequence" int
);
ALTER TABLE "tours_markers" ADD FOREIGN KEY ("tour_id") REFERENCES "tours" ("tour_id");
ALTER TABLE "tours_markers" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");

-- TABLE: PLANNERS --------------------------------------------------
CREATE TABLE "planners" (
  "planner_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "user_id" uuid
);
ALTER TABLE "planners" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

-- TABLE: PLANNERS MARKERS ------------------------------------------
CREATE TABLE "planners_markers" (
  "planner_id" serial,
  "marker_id" serial,
  "sequence" int
);
ALTER TABLE "planners_markers" ADD FOREIGN KEY ("planner_id") REFERENCES "planners" ("planner_id");
ALTER TABLE "planners_markers" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");


-- SEEDING: USERS ---------------------------------------------------
INSERT INTO users (username)
  VALUES ('hannah'), ('vikki'), ('georgia'), ('riona'), ('david');

INSERT INTO markers (title, location)
  VALUES  ('Manchester Museum', gis.st_point(-2.2368268, 53.4664686) ),
          ('Emmeline Pankhurst Statue',gis.st_point(-2.243056 , 53.477778)),
          ('Mamucium Roman Fort Reconstruction', gis.st_point(-2.2588591, 53.4754896) ),
          ('Manchester Cathedral', gis.st_point(-2.2490792, 53.4851459) ),
          ('Alan Turing Memorial', gis.st_point(-2.2407774, 53.4767288) );