import { useReactQueryDevTools } from "@dev-plugins/react-query/build/useReactQueryDevTools";
import { QueryClient } from "@tanstack/react-query";
import { Slot } from "expo-router";
import React from "react";
import "../global.css";
import { SafeAreaView } from "react-native-safe-area-context";

const queryClient = new QueryClient();

function _layout() {
	useReactQueryDevTools(queryClient);
	return (
		<SafeAreaView className="p-4">
			<Slot />
		</SafeAreaView>
	);
}

export default _layout;
