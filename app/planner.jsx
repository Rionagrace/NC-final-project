import React from "react";
import { FlatList, Text, View } from "react-native";
import useUserPlanner from "../hooks/useUserPlanner";

export default function planner() {
  const { data } = useUserPlanner();

  return (
    <View>
      <Text>planner Page</Text>
      {data && (
        <FlatList
          data={data[0]?.items}
          renderItem={({ item: { marker }, index }) => (
            <Text>
              {index}: {JSON.stringify(marker)}
            </Text>
          )}
        />
      )}
    </View>
  );
}
