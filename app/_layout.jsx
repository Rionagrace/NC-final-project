import { useReactQueryDevTools } from "@dev-plugins/react-query/build/useReactQueryDevTools";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Stack } from "expo-router";
import React from "react";
import "../global.css";

const queryClient = new QueryClient();

function _layout() {
  useReactQueryDevTools(queryClient);
  return (
    <QueryClientProvider client={queryClient}>
      <Stack>
        <Stack.Screen name="(tabs)" options={{ headerShown: false }} />
        <Stack.Screen
        name="modal"
        options={{
          presentation: 'modal',
        }}
      />
      </Stack>
    </QueryClientProvider>
  );
}

export default _layout;
