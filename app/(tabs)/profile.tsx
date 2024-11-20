import { View, Text, StyleSheet } from "react-native";
import LoginUsers from "../../components/UserLogin";

export default function Tab() {
  return (
    <View style={styles.container}>
      <Text>User Profile</Text>
      <LoginUsers/>
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
