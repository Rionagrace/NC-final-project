import React from "react";
import { Text, View } from "react-native";
import useCurrentLocation from "../../../hooks/useCurrentLocation";
import InteractiveMap from "../../../components/InteractiveMap";
import FloatingAction from "../../../components/FloatingAction";

export default function Explore() {
  const { location, isPending, error } = useCurrentLocation();

  if (isPending) return <Text>Pending...</Text>;
  if (error) return <Text>{JSON.stringify(error)}</Text>;
  if (!location) return <Text>No Location</Text>;

  const longLat = [location.longitude, location.latitude];

  const routeCoords = [
		[-2.24531978438671, 53.4771245864725],
		[-2.24465105455576, 53.4781646404297],
		[-2.23988384178912, 53.4783760685976],
    [-2.24394875223936, 53.4846719494712]
	];

  return (
    <>
      <View style={{ height: "100%" }}>
        <InteractiveMap coords={longLat} distance={1000} routeCoords={routeCoords} />
      </View>
      <FloatingAction href="/explore/add-spot">
        <Text className="text-center text-2xl font-bold text-white">+</Text>
      </FloatingAction>
    </>
  );
}
