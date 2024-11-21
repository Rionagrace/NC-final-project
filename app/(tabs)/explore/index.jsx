import React from "react";
import { Text, View } from "react-native";
import useCurrentLocation from "../../../hooks/useCurrentLocation";
import InteractiveMap from "../../../components/InteractiveMap";
import FloatingAction from "../../../components/FloatingAction";
import RouteMap from "../../../components/RouteMap";


export default function Explore() {
  const { location, isPending, error } = useCurrentLocation();

  if (isPending) return <Text>Pending...</Text>;
  if (error) return <Text>{JSON.stringify(error)}</Text>;
  if (!location) return <Text>No Location</Text>;

  const longLat = [location.longitude, location.latitude];

  return (
    <>
      <View style={{ height: "100%" }}>
        <RouteMap coords={longLat} distance={1000} />
      </View>
      <FloatingAction href="/explore/add-spot">
        <Text className="text-center text-2xl font-bold text-white">+</Text>
      </FloatingAction>
    </>
  );
}
