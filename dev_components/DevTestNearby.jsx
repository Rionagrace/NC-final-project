import React, { useState } from "react";
import { Button, Text } from "react-native";
import { supabase } from "../utils/supabaseClient";
import DevFeatureWrapper from "./DevFeatureWrapper";

export default function DevTestNearby() {
  const [data, setData] = useState({});

  function handleFetch() {
    supabase
      .rpc("nearby_markers", {
        long: -2.238595,
        lat: 53.4721833,
        distance: 1000,
      })
      .then((res) => {
        setData(res);
      });
  }

  return (
    <DevFeatureWrapper title="Test Nearby">
      <Button title="fetch nearby" onPress={handleFetch} />
      <Text>{JSON.stringify(data)}</Text>
    </DevFeatureWrapper>
  );
}
