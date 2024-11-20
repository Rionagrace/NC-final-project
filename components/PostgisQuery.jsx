import React, { useEffect, useState } from "react";
import { FlatList, Text, TextInput } from "react-native";
import { supabase } from "../utils/supabaseClient";

export default function PostgisQuery({ coords }) {
  const [data, setData] = useState(null);
  const [distance, setDistance] = useState("100");
  const [isPending, setIsPending] = useState(true);

  const invoke = () => {
    setIsPending(true);

    console.log(coords[0]);

    supabase
      .rpc("nearby_markers", {
        long: coords[0] || -2.2490792,
        lat: coords[1] || 53.4851459,
        distance: Number(distance) || 100,
      })
      .then((res) => setData(res.data))
      .finally(() => setIsPending(false));
  };

  useEffect(() => {
    invoke();
  }, [coords]);

  return (
    <>
      <Text className="text-xl font-bold mb-4">Example: Postgis Query</Text>
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
            renderItem={({ item: { title, distance_meters } }) => (
              <Text>
                {title}: {distance_meters}m
              </Text>
            )}
          />
        )
      )}
    </>
  );
}
