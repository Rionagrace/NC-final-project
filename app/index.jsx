import React, { useEffect, useState } from "react";
import { FlatList, Text, TextInput } from "react-native";
import { supabase } from "../utils/supabaseClient";

function index() {
  const [data, setData] = useState(null);
  const [distance, setDistance] = useState("100");
  const [isPending, setIsPending] = useState(true);

  const invoke = () => {
    setIsPending(true);

    supabase
      .rpc("nearby_markers", {
        longitude: -2.2490792,
        latitude: 53.4851459,
        distance: Number(distance) || 100,
      })
      .then((res) => setData(res.data))
      .finally(() => setIsPending(false));
  };

  useEffect(() => {
    invoke();
  }, []);

  return (
    <>
      <Text className="text-xl font-bold mb-4">Example: Postgis</Text>
      <TextInput
        className="border p-2 rounded mb-4"
        value={distance}
        onChangeText={setDistance}
        onSubmitEditing={invoke}
      />
      {isPending ? (
        <Text>Pending...</Text>
      ) : (
        data?.length && (
          <FlatList
            data={data}
            renderItem={({ item: { name, distance_meters } }) => (
              <Text>
                {name}: {distance_meters}m
              </Text>
            )}
          />
        )
      )}
    </>
  );
}

export default index;
