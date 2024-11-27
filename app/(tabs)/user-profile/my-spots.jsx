import React from "react";
import { View, Text, FlatList, TouchableOpacity } from "react-native";
import { Link } from "expo-router";
import useUserMarkers from "../../../hooks/useUsersMarkers";

export default function MySpots() {
  const { data: markers } = useUserMarkers();

  return (
    <View className="flex-1 px-4 py-6 bg-gray-100 dark:bg-gray-800">
      <FlatList
        data={markers}
        keyExtractor={(item) => item.marker_id.toString()}
        renderItem={({ item }) => (
          <Link href={`/user-profile/${item.marker_id}`} asChild>
            <TouchableOpacity>
              <View className="bg-white dark:bg-gray-700 rounded-lg shadow-sm p-4 mb-4">
                <Text className="text-lg font-semibold text-gray-900 dark:text-gray-100">
                  {item.title}
                </Text>
                <Text className="text-sm text-gray-700 dark:text-gray-300 mt-1">
                  {item.description
                    ? `${item.description.slice(0, 50)}...`
                    : "No description provided."}
                </Text>
              </View>
            </TouchableOpacity>
          </Link>
        )}
      />
    </View>
  );
}
