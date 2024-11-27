import { useMutation, useQueryClient } from "@tanstack/react-query";
import { useContext, useEffect, useState } from "react";
import { AuthContext } from "../components/Auth/AuthContext";
import { supabase } from "../utils/supabaseClient";
import useUserVotes from "./useUserVotes";

export default function useUserVoteOnMarker(marker_id) {
  const queryClient = useQueryClient();

  // AUTH CHECK
  const { userId } = useContext(AuthContext);
  const canVote = Boolean(userId);

  // GET INITIAL STATE
  const {
    data: queryData,
    isPending: isQuerying,
    error: queryError,
  } = useUserVotes(marker_id);

  const [vote, setVote] = useState(null);

  useEffect(() => {
    setVote(queryData?.[0]?.value || 0);
  }, [queryData]);

  // REQUEST HELPER
  const request = ({ perform, data }) => {
    let query = supabase.from("votes");

    if (perform === "insert") query = query.insert(data);
    else if (perform === "select") query = query.select(data);
    else if (perform === "update") query = query.update(data);
    else if (perform === "delete") query = query.delete(data);

    if (perform !== "insert")
      query = query.eq("user_id", userId).eq("marker_id", marker_id);

    if (perform != "select") query = query.select();

    return query.then((res) => res.data);
  };

  // MUTATION
  const userVoteKeys = ["user", "votes", marker_id];
  const {
    isPending: isMutating,
    error: mutateError,
    mutate,
  } = useMutation({
    mutationKey: ["vote"],
    mutationFn: ({ perform, data }) => request({ perform, data }),
    onMutate: (vars) => {
      const { perform, data } = vars;
      const prevData = queryClient.getQueryData(userVoteKeys);

      queryClient.setQueryData(userVoteKeys, () => {
        return perform === "delete" ? null : [{ value: data.value }];
      });

      return { prevData };
    },
    onSuccess: () => {
      queryClient.invalidateQueries(["marker", marker_id]);
    },
    onError: (err, vars, ctx) => {
      queryClient.setQueryData(userVoteKeys, ctx.prevData);
      queryClient.invalidateQueries(["marker", marker_id]);
    },
    enabled: canVote,
  });

  // ADD VOTE
  const addVote = (value) =>
    mutate({
      perform: "insert",
      data: {
        user_id: userId,
        marker_id,
        value,
      },
    });

  // REMOVE VOTE
  const removeVote = () =>
    mutate({
      perform: "delete",
    });

  // UPDATE VOTE
  const updateVote = (value) =>
    mutate({
      perform: "update",
      data: { value },
    });

  return {
    canVote,
    vote,
    addVote,
    removeVote,
    updateVote,
    isPending: isQuerying || isMutating,
    error: { queryError, mutateError },
  };
}
