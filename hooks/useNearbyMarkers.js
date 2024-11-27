import { useQuery } from "@tanstack/react-query";
import { supabase } from "../utils/supabaseClient";

export default function useNearbyMarkers({ coords, distance, cats }) {
  return useQuery({
    queryKey: ["nearby-markers", coords[0], coords[1], distance, cats],
    queryFn: () =>
      supabase
        .rpc("nearby_markers_with_filter", {
          long: coords[0],
          lat: coords[1],
          distance,
          cats: cats.length ? cats : null,
        })
        .then((res) => res.data),
  });
}
