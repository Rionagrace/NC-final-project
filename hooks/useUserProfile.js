import { useQueries } from "@tanstack/react-query";
import { useContext } from "react";
import { AuthContext } from "../components/Auth/AuthContext";
import { supabase } from "../utils/supabaseClient";

export default function useUserProfile() {
  const { userId } = useContext(AuthContext);

  const queries = ["profiles", "planners", "votes"].map((table) => ({
    queryKey: [table, "user", userId],
    queryFn: () =>
      supabase
        .from(table)
        .select()
        .eq("user_id", userId)
        .then((res) => res.data),
    enabled: Boolean(userId),
  }));
  return useQueries({
    queries,
  });
}
