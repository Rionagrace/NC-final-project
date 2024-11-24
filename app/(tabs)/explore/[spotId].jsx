import { Stack, useLocalSearchParams } from "expo-router";
import { Button, Text, View } from "react-native";
import SingleMarkerCard from "../../../components/SingleMarkerCard";
import useMarkerInfo from "../../../hooks/useMarkerInfo";
import useUserAddToPlanner from "../../../hooks/useUserAddToPlanner";
import useUserVoteOnMarker from "../../../hooks/useUserVoteOnMarker";

export default function SpotDetails() {
  const { spotId } = useLocalSearchParams();

  const marker_id = Number(spotId);

  const { data, isPending, error } = useMarkerInfo(marker_id);
  const { canAddToPlanner, mutate: addToPlanner } =
    useUserAddToPlanner(marker_id);

  const { vote, canVote, addVote, removeVote, updateVote } =
    useUserVoteOnMarker(marker_id);

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
    <View>
      <Stack.Screen options={{ title: data.title }} />
      <SingleMarkerCard markerData={data} />
      <Button
        title="Add to planner"
        onPress={addToPlanner}
        disabled={!canAddToPlanner}
      />
      <View>
        <Text>Last vote: {vote}</Text>
        <Button title="add" onPress={() => addVote(3)} disabled={!canVote} />
        <Button title="remove" onPress={removeVote} disabled={!canVote} />
        <Button
          title="update"
          onPress={() => updateVote(5)}
          disabled={!canVote}
        />
      </View>
    </View>
  );
}
