import React from "react";
import { Text } from "react-native";
import MarkerList from "../components/MarkerList";

function index() {
  return (
    <>
      <Text className="text-xl font-bold pb-4">
        Example: Tanstack Query + Supabase
      </Text>
      <MarkerList />
    </>
  );
}

export default index;
