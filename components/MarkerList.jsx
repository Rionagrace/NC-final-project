import React, { useEffect } from "react";
import { FlatList, Text } from "react-native";
import useMarkersRead from "../hooks/useMarkersRead";

export default function MarkerList() {
  const { data, isPending, error } = useMarkersRead();

  if (isPending) return <Text>Pending...</Text>;
  if (error) return <Text>{JSON.stringify(error)}</Text>;

  return (
    <FlatList
      data={data}
      renderItem={(item) => <Text>{JSON.stringify(item)}</Text>}
    />
  );
}
