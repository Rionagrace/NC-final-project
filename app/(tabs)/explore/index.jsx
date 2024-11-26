import { useLocalSearchParams } from "expo-router";
import React from "react";
import { Text, View } from "react-native";
import FloatingAction from "../../../components/FloatingAction";
import InteractiveMap from "../../../components/InteractiveMap";
import MapLayerPlanner from "../../../components/MapLayerPlanner";
import useCurrentLocation from "../../../hooks/useCurrentLocation";

export default function Explore() {
  const { route } = useLocalSearchParams();
  const { location, isPending, error } = useCurrentLocation();

  if (isPending) return <Text>Pending...</Text>;
  if (error) return <Text>{JSON.stringify(error)}</Text>;
  if (!location) return <Text>No Location</Text>;

  console.log({ route });

  return (
    <>
      <View style={{ height: "100%" }}>
        <InteractiveMap
          coords={[location.longitude, location.latitude]}
          distance={1000}
          routeComponent={<MapLayerPlanner enable={route === "show"} />}
        />
      </View>
      <FloatingAction href="/explore/add-spot">
        <Text className="text-center text-2xl font-bold text-white">+</Text>
      </FloatingAction>
    </>
  );
}
