import { useQuery } from "@tanstack/react-query";
import { supabase } from "../utils/supabaseClient";

export default function useNearbyMarkers({
  longitude = -2.2490792,
  latitude = 53.4851459,
  distance = 100,
}) {
  console.log({ longitude, latitude, distance });

  return useQuery({
    queryKey: ["nearby-markers", longitude, latitude],
    queryFn: () =>
      supabase
        .rpc("nearby_markers", {
          longitude,
          latitude,
          distance,
        })
        .then((res) => {
          console.log(res);
          return res.data;
        }),
  });
}
