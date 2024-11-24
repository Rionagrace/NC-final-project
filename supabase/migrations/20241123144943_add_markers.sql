-- CREATE TABLE
DROP TABLE IF EXISTS markers CASCADE;
CREATE TABLE markers (
    marker_id SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL,
    description TEXT,
    address VARCHAR,
    image VARCHAR,
    location gis.geography(POINT) NOT NULL,
    longitude FLOAT NOT NULL,
    latitude FLOAT NOT NULL,
    user_id UUID REFERENCES profiles ON DELETE SET NULL,
    votes INT NOT NULL DEFAULT 0
);

CREATE INDEX geo_marker ON markers USING GIST (location);

-- CREATE set_location FUNCTION AND TRIGGER
CREATE OR REPLACE FUNCTION set_location()
    RETURNS TRIGGER AS $$
        BEGIN
            NEW.location := gis.st_point(NEW.longitude, NEW.latitude);
            RETURN NEW;
        END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER on_insertion_to_markers
    BEFORE INSERT ON markers
        FOR EACH ROW
            EXECUTE FUNCTION set_location();