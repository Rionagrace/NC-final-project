import { useQuery } from "@tanstack/react-query";
import { supabase } from "../utils/supabaseClient";

export default function useMarkersRead() {
  return useQuery({
    queryKey: ["markers"],
    queryFn: () =>
      supabase
        .from("markers")
        .select()
        .then((res) => {
          console.log(res);
          return res.data;
        }),
  });
}
