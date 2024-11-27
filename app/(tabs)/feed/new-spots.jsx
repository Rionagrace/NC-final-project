import { Link } from "expo-router";
import React from "react";
import { FlatList, Text, TouchableOpacity, View } from "react-native";
import useAllMarkers from "../../../hooks/useAllMarkers";

export default function NewSpots() {
  const { data: markers } = useAllMarkers();

  const latestMarkers = markers
    .sort((a, b) => b.marker_id - a.marker_id)
    .slice(0, 5);

  return (
    <View className="flex-1 px-4 py-6 bg-gray-100 dark:bg-gray-800">
      <Text className="text-lg font-semibold text-gray-900 dark:text-gray-100">
        Look! Here are the last markers
      </Text>
      <FlatList
        data={latestMarkers}
        keyExtractor={(item) => item.marker_id.toString()}
        renderItem={({ item }) => (
          <Link href={`/feed/${item.marker_id}`} asChild>
            <TouchableOpacity>
              <View className="bg-white dark:bg-gray-700 rounded-lg shadow-sm p-4 mb-4">
                <Text className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                  {item.title}
                </Text>
              </View>
            </TouchableOpacity>
          </Link>
        )}
      />
    </View>
  );
}
