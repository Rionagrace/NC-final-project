DROP FUNCTION IF EXISTS nearby_markers;
CREATE FUNCTION nearby_markers(long float, lat float, distance int)
    RETURNS TABLE (
        marker_id markers.marker_id%TYPE,
        title markers.title%TYPE,
        latitude float,
        longitude float,
        distance_meters float
    )
    LANGUAGE SQL
    AS $$
        SELECT  marker_id,
                title,
                gis.st_y(location::gis.geometry) as latitude,
                gis.st_x(location::gis.geometry) as longitude,
                gis.st_distance(location, gis.st_point(long, lat)::gis.geography) as distance_meters
        FROM markers
        WHERE gis.st_dwithin(location, gis.st_point(long, lat)::gis.geography, distance)
        ORDER BY distance_meters ASC;
    $$;