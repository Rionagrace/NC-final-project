-- Initialize postgis
-- DROP SCHEMA IF EXISTS gis CASCADE;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA gis;
GRANT USAGE ON SCHEMA gis to anon;

-- Recreate table
DROP TABLE IF EXISTS gis_markers;
CREATE TABLE gis_markers (
    marker_id uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
    name varchar NOT NULL,
    location gis.geography(POINT) NOT NULL
);

CREATE INDEX gis_markers_index ON gis_markers USING GIST (location);

-- Seed with data
INSERT INTO gis_markers (name, location)
    VALUES  ('Manchester Museum', gis.st_point(-2.2368268, 53.4664686) ),
            ('Emmeline Pankhurst Statue',gis.st_point(-2.243056 , 53.477778)),
            ('Mamucium Roman Fort Reconstruction', gis.st_point(-2.2588591, 53.4754896) ),
            ('Manchester Cathedral', gis.st_point(-2.2490792, 53.4851459) ),
            ('Alan Turing Memorial', gis.st_point(-2.2407774, 53.4767288) );

-- Create nearby function
CREATE OR REPLACE FUNCTION nearby_markers(latitude float, longitude float, distance int)
    RETURNS TABLE (
        marker_id gis_markers.marker_id%TYPE,
        name gis_markers.name%TYPE,
        latitude float,
        longitude float,
        distance_meters float
        )
    LANGUAGE SQL
    as $$
        SELECT  marker_id,
                name,
                gis.st_y(location::gis.geometry) as latitude,
                gis.st_x(location::gis.geometry) as longitude,
                gis.st_distance(location, gis.st_point(longitude, latitude)::gis.geography) as distance_meters
        FROM gis_markers
        WHERE gis.st_dwithin(location, gis.st_point(longitude, latitude)::gis.geography, distance)
        ORDER BY distance_meters ASC
    $$;