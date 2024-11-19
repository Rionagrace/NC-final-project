CREATE TABLE "markers" (
  "marker_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "description" varchar(255),
  "address" varchar,
  "longitude" float,
  "latitude" float,
  "location" gis.geography(POINT) NOT NULL,
  "user_id" uuid
);

ALTER TABLE "markers" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");
CREATE INDEX geo_marker ON markers USING GIST (location);

-- FUNCTION ---------------------------------------------------------
DROP FUNCTION IF EXISTS nearby_markers;
CREATE FUNCTION nearby_markers(latitude float, longitude float, distance int)
    RETURNS TABLE (
        marker_id markers.marker_id%TYPE,
        title markers.title%TYPE,
        distance_meters float
        )
    LANGUAGE SQL
    as $$
        SELECT  marker_id,
                title,
                gis.st_distance(location, gis.st_point(longitude, latitude)::gis.geography) as distance_meters
        FROM markers
        WHERE gis.st_dwithin(location, gis.st_point(longitude, latitude)::gis.geography, distance)
        ORDER BY distance_meters ASC
    $$;

-- JOINING TABLE ----------------------------------------------------
CREATE TABLE "markers_categories" (
  "category_id" serial,
  "marker_id" serial,
  "order" int
);
ALTER TABLE "markers_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id");
ALTER TABLE "markers_categories" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");


-- SEED -------------------------------------------------------------
INSERT INTO markers (title, location)
  VALUES  ('Manchester Museum', gis.st_point(-2.2368268, 53.4664686) ),
          ('Emmeline Pankhurst Statue',gis.st_point(-2.243056 , 53.477778)),
          ('Mamucium Roman Fort Reconstruction', gis.st_point(-2.2588591, 53.4754896) ),
          ('Manchester Cathedral', gis.st_point(-2.2490792, 53.4851459) ),
          ('Alan Turing Memorial', gis.st_point(-2.2407774, 53.4767288) );

SELECT nearby_markers(-2.2490792, 53.4851459, 100);