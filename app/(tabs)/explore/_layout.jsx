import { Stack } from "expo-router";
import { Screen } from "expo-router/build/views/Screen";
import React from "react";

export default function _layout() {
  return (
    <Stack
      screenOptions={{
        headerBackTitleVisible: false,
      }}
    >
      <Stack.Screen name="index" options={{ headerShown: false, title: "" }} />
      <Stack.Screen name="add-spot" options={{ title: "Add Spot" }} />
      <Screen
        name="[spotId]"
        options={{
          presentation: "modal",
        }}
      />
    </Stack>
  );
}
