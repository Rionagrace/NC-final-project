import React, { useState } from "react";
import { Button, FlatList, Text, TextInput } from "react-native";
import MapboxExample from "./MapboxExample";
import { supabase } from "../utils/supabaseClient";

export default function PostgisMutate({ onFocusedCoords = () => null }) {
  const [title, setTitle] = useState("");
  const [long, setLong] = useState("");
  const [lat, setLat] = useState("");

  const [isPending, setIsPending] = useState(false);
  const [res, setRes] = useState(null);

  const handleSubmit = () => {
    setIsPending(true);

    supabase
      .from("markers")
      .insert([
        {
          title,
          location: `POINT(${long} ${lat})`,
        },
      ])
      .select()
      .then((res) => {
        setRes(res.data[0]);

        setTitle("");
        setLong("");
        setLat("");
      })
      .finally(() => setIsPending(false));
  };

  return (
    <>
      <Text className="text-xl font-bold mb-4">Example: Postgis Mutate</Text>
      <MapboxExample
        onLongPress={(coords) => {
          setLong(coords[0].toString());
          setLat(coords[1].toString());
          onFocusedCoords(coords);
        }}
      />
      <TextInput
        className="border p-2 rounded mb-4"
        value={title}
        onChangeText={setTitle}
      />
      <TextInput
        className="border p-2 rounded mb-4"
        value={long}
        onChangeText={setLong}
        editable={false}
      />
      <TextInput
        className="border p-2 rounded mb-4"
        value={lat}
        onChangeText={setLat}
        editable={false}
      />
      <Button
        title="submit"
        onPress={handleSubmit}
        disabled={isPending || !title || !long || !lat}
      />
      {res && (
        <FlatList
          data={Object.entries(res)}
          renderItem={({ item: [key, val] }) => (
            <Text>
              {key}: {val}
            </Text>
          )}
        />
      )}
    </>
  );
}
