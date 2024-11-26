import { useMutation } from "@tanstack/react-query";
import { supabase } from "../utils/supabaseClient";
import useUserPlanner from "./useUserPlanner";

export default function useUserPlannerUpdate() {
  const { data: planners } = useUserPlanner();

  const plannerId = planners?.[0]?.planner_id;

  return useMutation({
    mutationKey: ["user", "planner", "update"],
    mutationFn: (markers) =>
      {const array = markers.map((marker, index) => {
        return {
          markerId: marker.marker_id,
          seq: index
        }
      })
      return supabase.rpc("update_planner_sequence", {
        plannerId,
        markers: JSON.stringify(array),
      })
    }
  });
}
