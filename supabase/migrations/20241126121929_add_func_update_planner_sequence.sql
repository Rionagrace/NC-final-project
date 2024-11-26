DROP FUNCTION IF EXISTS update_planner_sequence CASCADE;
CREATE FUNCTION update_planner_sequence (plannerId int, markers jsonb) RETURNS VOID AS $$
DECLARE
    marker jsonb;
    markerId int;
    seq int;
BEGIN
    FOR marker IN
        SELECT * FROM jsonb_array_elements(markers)
    LOOP
        markerId := (marker->>'markerId')::int;
        seq := (marker->>'seq')::int;

        UPDATE planners_markers
            SET sequence = seq
            WHERE planner_id = plannerId AND marker_id = markerId;
    END LOOP;
END;
$$ LANGUAGE plpgsql;