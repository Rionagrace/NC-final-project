import { useQuery } from "@tanstack/react-query";
import { supabase } from "../utils/supabaseClient";
import { useContext } from "react";
import { AuthContext } from "../components/Auth/AuthContext";

export default function useUserPlanner() {
  const { userId } = useContext(AuthContext);

  return useQuery({
    queryKey: ["user", "planner"],
    queryFn: () =>
      supabase
        .from("planners")
        .select(
          "planner_id, title, items:planners_markers(marker:markers(marker_id, title,longitude, latitude), sequence)"
        )
        .eq("user_id", userId)
        .order("sequence", {
          referencedTable: "planners_markers",
          nullFirst: true,
        })
        .then((res) => res.data),
    enable: Boolean(userId),
  });
}
