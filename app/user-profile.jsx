import { useSearchParams } from "expo-router/build/hooks";
import { View, Text, StyleSheet } from "react-native";

export default function UserProfile() {
  console.log(useSearchParams());
  const { username } = useSearchParams();
  console.log(username);
  return (
    <View style={styles.container}>
      <Text>Welcome, {username || "Guest!"} </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    alignItems: "center",
  },
});
