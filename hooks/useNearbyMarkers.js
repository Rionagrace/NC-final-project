import { useQuery } from "@tanstack/react-query";
import { supabase } from "../utils/supabaseClient";

export default function useNearbyMarkers({
  long = -2.2384542,
  lat = 53.4722013,
  distance = 1000,
}) {
  return useQuery({
    queryKey: ["nearby-markers", long, lat, distance],
    queryFn: () =>
      supabase
        .rpc("nearby_markers", {
          long,
          lat,
          distance,
        })
        .then((res) => {
          console.log(res);
          return res.data;
        }),
  });
}
