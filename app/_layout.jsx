import { useReactQueryDevTools } from "@dev-plugins/react-query/build/useReactQueryDevTools";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { Link, Stack } from "expo-router";
import { Screen } from "expo-router/build/views/Screen";
import React from "react";
import "../global.css";
import AuthProvider from "../components/Auth/AuthProvider";

const queryClient = new QueryClient();

function _layout() {
  useReactQueryDevTools(queryClient);

  return (
    <QueryClientProvider client={queryClient}>
      <AuthProvider>
        <Stack>
          <Screen
            name="(tabs)"
            options={{
              headerTitle: "Columbus",
              headerLeft: () => <Link href={"/dev"}>DEV</Link>,
              headerRight: () => <Link href={"/planner"}>PLANNER</Link>,
            }}
          />
          <Screen
            name="login"
            options={{
              presentation: "modal",
            }}
          />
          <Screen
            name="planner"
            options={{
              presentation: "modal",
            }}
          />
        </Stack>
      </AuthProvider>
    </QueryClientProvider>
  );
}

export default _layout;
