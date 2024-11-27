DROP FUNCTION IF EXISTS nearby_markers_with_filter;
CREATE FUNCTION nearby_markers_with_filter(long float, lat float, distance int, cats jsonb)
    RETURNS TABLE (
        marker_id markers.marker_id%TYPE,
        title markers.title%TYPE,
        latitude float,
        longitude float,
        distance_meters float,
        image varchar
    )
    LANGUAGE PLPGSQL
    AS $$
        DECLARE
            qSelect varchar;
            qFilter varchar;
            qNearby varchar;
            qChain varchar;
        BEGIN
            RAISE LOG 'DEBUG: %, %, %, %', long, lat, distance, cats;
            qselect := 'SELECT  markers.marker_id,
                                markers.title,
                                gis.st_y(markers.location::gis.geometry) as latitude,
                                gis.st_x(markers.location::gis.geometry) as longitude,
                                gis.st_distance(markers.location, gis.st_point($1, $2)::gis.geography) as distance_meters,
                                markers.image
                        FROM markers';
            qFilter := '
                        INNER JOIN markers_categories as m2m ON markers.marker_id = m2m.marker_id
                        CROSS JOIN LATERAL jsonb_array_elements($4) AS cat_id
                        WHERE m2m.category_id = cat_id::int';

            qNearby := '
                        gis.st_dwithin(location, gis.st_point($1, $2)::gis.geography, $3)
                        ORDER BY distance_meters ASC;';

            IF cats IS NULL THEN
                qChain := qSelect || ' WHERE ' || qNearby;
            ELSE
                qChain := qSelect || ' ' || qFilter || ' AND ' || qNearby;
            END IF;

            RETURN QUERY EXECUTE qChain USING long, lat, distance, cats;
        END
    $$;