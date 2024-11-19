import React, { useEffect } from "react";
import { FlatList, Text } from "react-native";
import useNearbyMarkers from "../hooks/useNearbyMarkers";

export default function MarkerList({ queries }) {
  const { data, isPending, error } = useNearbyMarkers(queries);

  if (isPending) return <Text>Pending...</Text>;
  if (error) return <Text>{JSON.stringify(error)}</Text>;

  return (
    data?.length > 0 && (
      <FlatList
        data={data}
        renderItem={({ item: { title, distance_meters } }) => (
          <Text>
            {title}: {distance_meters}m
          </Text>
        )}
      />
    )
  );
  0;
}
