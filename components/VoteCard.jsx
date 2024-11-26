import React from "react";
import { Text, View, TouchableOpacity, StyleSheet } from "react-native";
import useUserVoteOnMarker from "../hooks/useUserVoteOnMarker";
import { MaterialIcons } from "@expo/vector-icons";

export default function VoteCard({
  user,
  avgVote,
  userVoteCount,
  marker_id,
  disabled = false,
}) {
  const { addVote, canVote, vote, removeVote, updateVote, error, isPending } =
    useUserVoteOnMarker(marker_id);

  const stars = [1, 2, 3, 4, 5];

  const handleVote = (value) => {
    if (vote === value) return removeVote();
    if (vote) return updateVote(value);
    addVote(value);
  };

  const renderAverageStars = (currentRating) => {
    return stars.map((star) => (
      <MaterialIcons
        key={star}
        name={currentRating >= star ? "star" : "star-border"}
        size={32}
        style={
          currentRating >= star ? styles.starSelected : styles.starUnselected
        }
      />
    ));
  };

  const renderUserStars = () => {
    return stars.map((star) => (
      <TouchableOpacity
        key={star}
        disabled={disabled}
        onPress={() => handleVote(star)}
        accessibilityLabel={`Rate ${star} stars`}
      >
        <MaterialIcons
          name={vote >= star ? "star" : "star-border"}
          size={32}
          style={vote >= star ? styles.starSelected : styles.starUnselected}
        />
      </TouchableOpacity>
    ));
  };

  return (
    <View className="m-4 p-4 min-h-[100] flex justify-center content-center rounded-xl bg-white">
      <Text className="text-center text-lg font-bold text-gray-800 pt-4">
        Average Star Rating
      </Text>
      <View className="flex justify-center" style={styles.starsContainer}>
        {renderAverageStars(avgVote)}
        <Text className="text-sm text-center">({userVoteCount})</Text>
      </View>

      {user && (
        <>
          <Text className="text-center text-lg font-bold text-gray-800 pt-6">
            Your Star Rating
          </Text>
          <View className="flex justify-center" style={styles.starsContainer}>
            {renderUserStars()}
          </View>
          <Text className="text-m text-center pb-4 align-center">
            Click the stars to add your rating!
          </Text>
        </>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  starsContainer: {
    flexDirection: "row",
    justifyContent: "center",
    padding: 8,
  },
  starUnselected: {
    color: "#aaa",
  },
  starSelected: {
    color: "#ffb300",
  },
});
