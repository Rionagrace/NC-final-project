CREATE OR REPLACE FUNCTION public.recalc_votes()
  RETURNS TRIGGER
  AS $$
  DECLARE
    mid int;
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      mid := NEW.marker_id;
    ELSE
      mid := OLD.marker_id;
    END IF;
      UPDATE public.markers
        SET   avg_vote = (SELECT coalesce(avg(value)::int, 0) FROM votes WHERE marker_id = mid),
              user_vote_count = (SELECT coalesce(count(*)::int, 0) FROM votes WHERE marker_id = mid)
        WHERE marker_id = mid;

    RETURN NULL;
  END $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_votes
  AFTER INSERT OR UPDATE OR DELETE ON votes
    FOR EACH ROW
      EXECUTE PROCEDURE public.recalc_votes();