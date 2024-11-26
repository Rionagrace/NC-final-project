import {
  Text,
  TextInput,
  View,
  Button,
  TouchableOpacity,
  StyleSheet,
} from "react-native";
import useUserVoteOnMarker from "../hooks/useUserVoteOnMarker";
import { MaterialIcons } from "@expo/vector-icons";

export default function VoteCard({ user, votes, marker_id, disabled = false }) {
  const { addVote, canVote, vote, removeVote, updateVote, error, isPending } =
    useUserVoteOnMarker(marker_id);
  // console.log(vote, votes);

  let name = "";
  if (user) {
    name =
      user?.email.split("@")[0].charAt(0).toUpperCase() +
      user?.email.split("@")[0].slice(1) +
      "'s";
  }

  return (
    <View className="m-4 mb-0 last-child:mb-4 p-4 min-h-[100] flex justify-center content-center rounded-xl bg-white">
      <Text className="text-center text-lg font-bold text-gray-800">
        {name} Star Rating
      </Text>
      <View className="flex justify-center" style={styles.stars}>
        <TouchableOpacity
          onPress={() => {
            vote ? updateVote(1) : addVote(1);
          }}
          disabled={!canVote}
        >
          <MaterialIcons
            name={vote >= 1 ? "star" : "star-border"}
            size={32}
            style={vote >= 1 ? styles.starSelected : styles.starUnselected}
          />
        </TouchableOpacity>
        <TouchableOpacity
          onPress={() => {
            vote ? updateVote(2) : addVote(2);
          }}
          disabled={!canVote}
        >
          <MaterialIcons
            name={vote >= 2 ? "star" : "star-border"}
            size={32}
            style={vote >= 2 ? styles.starSelected : styles.starUnselected}
          />
        </TouchableOpacity>
        <TouchableOpacity
          onPress={() => {
            vote ? updateVote(3) : addVote(3);
          }}
          disabled={!canVote}
        >
          <MaterialIcons
            name={vote >= 3 ? "star" : "star-border"}
            size={32}
            style={vote >= 3 ? styles.starSelected : styles.starUnselected}
          />
        </TouchableOpacity>
        <TouchableOpacity
          onPress={() => {
            vote ? updateVote(4) : addVote(4);
          }}
          disabled={!canVote}
        >
          <MaterialIcons
            name={vote >= 4 ? "star" : "star-border"}
            size={32}
            style={vote >= 4 ? styles.starSelected : styles.starUnselected}
          />
        </TouchableOpacity>
        <TouchableOpacity
          onPress={() => {
            vote ? updateVote(5) : addVote(5);
          }}
          disabled={!canVote}
        >
          <MaterialIcons
            name={vote >= 5 ? "star" : "star-border"}
            size={32}
            style={vote >= 5 ? styles.starSelected : styles.starUnselected}
          />
        </TouchableOpacity>
      </View>
      <View>
        <Text className="text-xl text-center p-5">Total Stars: {votes}</Text>
        <TouchableOpacity
          onPress={() => {
            removeVote();
          }}
          title="Remove vote"
          disabled={disabled}
          className="bg-orange-500 rounded-xl m-1 p-1"
        >
          <Text className="text-white text-center text-xl font-bold">
            Reset Vote
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  stars: {
    display: "flex",
    flexDirection: "row",
  },
  starUnselected: {
    color: "#aaa",
  },
  starSelected: {
    color: "#ffb300",
  },
});

{
  /* // <TouchableOpacity */
}
{
  /* // onPress={() => (vote ? updateVote(1) : addVote(1))}
// title="Add 1 Vote"
// disabled={vote > 0}
// className="bg-orange-500 rounded-xl m-1 p-1 disabled:bg-orange-200"
// >
// <Text className="text-white text-center text-xl font-bold">
//   Add 1 Vote
// </Text>
// </TouchableOpacity> */
}
