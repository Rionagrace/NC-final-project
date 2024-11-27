DROP FUNCTION IF EXISTS public.update_planner_sequence CASCADE;
CREATE FUNCTION public.update_planner_sequence (body jsonb) RETURNS VOID AS $$
DECLARE
    plannerId int;
    marker jsonb;
    markerId int;
    seq int;
BEGIN
    plannerId := (body->'planner_id')::int;

    FOR marker IN
        SELECT * FROM jsonb_array_elements(body->'items')
    LOOP
        markerId := (marker->'marker_id')::int;
        seq := (marker->'sequence')::int;

        UPDATE public.planners_markers
            SET "sequence" = seq
            WHERE planner_id = plannerId AND marker_id = markerId;
    END LOOP;
END;
$$ LANGUAGE plpgsql;