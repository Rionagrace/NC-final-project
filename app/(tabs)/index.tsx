import { View, Text, StyleSheet} from "react-native";
import useCurrentLocation from "../../hooks/useCurrentLocation";
import MapboxExample from "../../components/MapboxExample";
import { Link } from "expo-router";

export default function Tab() {
  const { location, error } = useCurrentLocation();

  return (
    <View style={styles.container}>
      <Text>{JSON.stringify(location || error)}</Text>
      <Text>Hello World</Text>
      <MapboxExample />
      <Link href="/modal" style={styles.link}>
        Open modal
      </Link>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  link: {
    fontSize: 18,
    color: "blue",
    textDecorationLine: "underline",
  },
});
