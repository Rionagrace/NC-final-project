CREATE OR REPLACE FUNCTION public.recalc_votes()
  RETURNS TRIGGER
  AS $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      UPDATE public.markers
        SET votes = votes + NEW.value
        WHERE marker_id = NEW.marker_id;
    ELSEIF (TG_OP = 'UPDATE') THEN
      UPDATE public.markers
        SET votes = votes - OLD.value + NEW.value
        WHERE marker_id = NEW.marker_id;
    ELSEIF (TG_OP = 'DELETE') THEN
      UPDATE public.markers
        SET votes = votes - OLD.value
        WHERE marker_id = OLD.marker_id;
    END IF;

    RETURN NULL;
  END $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_votes
  AFTER INSERT OR UPDATE OR DELETE ON votes
    FOR EACH ROW
      EXECUTE PROCEDURE public.recalc_votes();