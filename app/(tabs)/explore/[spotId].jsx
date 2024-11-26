import { Stack, useLocalSearchParams } from "expo-router";
import { Button, Text, View } from "react-native";
import SingleMarkerCard from "../../../components/SingleMarkerCard";
import useMarkerInfo from "../../../hooks/useMarkerInfo";
import { supabase } from "../../../utils/supabaseClient";
import { TouchableOpacity } from "react-native";
import { useContext } from "react";
import { AuthContext } from "../../../components/Auth/AuthContext";
import useUserAddToPlanner from "../../../hooks/useUserAddToPlanner";
import VoteCard from "../../../components/VoteCard";
import CustomButton from "../../../components/CustomButton";

export default function SpotDetails() {
  const { user } = useContext(AuthContext);
  const { spotId } = useLocalSearchParams();
  const marker_id = Number(spotId);
  const { data, isPending, error } = useMarkerInfo(marker_id);
  const {
    canAddToPlanner,
    isPending: isMutating,
    error: mutationError,
    mutate: addToPlanner,
  } = useUserAddToPlanner(marker_id);

  if (isPending) {
    return (
      <View>
        <Text>Loading...</Text>
      </View>
    );
  }

  if (error) {
    return (
      <View>
        <Text>Error: {error.message}</Text>
      </View>
    );
  }

  if (!data) {
    return (
      <View>
        <Text>No data available.</Text>
      </View>
    );
  }
  return (
    <View className="p-4">
      <Stack.Screen options={{ title: data.title }} />
      <SingleMarkerCard markerData={data} />
      <CustomButton
        title={"Add to Planner"}
        color={"primary"}
        onPress={addToPlanner}
        // disabled={true}
      />
      <VoteCard
        marker_id={spotId}
        avgVote={data.avg_vote}
        user={user}
        userVoteCount={data.user_vote_count}
      />
    </View>
  );
}
