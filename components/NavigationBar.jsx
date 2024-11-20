import { View, Text, TouchableOpacity } from "react-native";
import { Link } from "expo-router";

export default function NavigationBar() {
  return (
    <View>
      <TouchableOpacity>
        <Link href="/">
          <Text>Map</Text>
        </Link>
      </TouchableOpacity>

      <TouchableOpacity>
        <Link href="/profile">
          <Text>Profile</Text>
        </Link>
      </TouchableOpacity>
      <TouchableOpacity>
        <Link href="/planner">
          <Text>Planner</Text>
        </Link>
      </TouchableOpacity>
    </View>
  );
}
