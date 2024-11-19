import React, { useEffect, useState } from "react";
import { FlatList, Text } from "react-native";
import { supabase } from "../utils/supabaseClient";

function index() {
  const [data, setData] = useState(null);

  useEffect(() => {
    supabase
      .rpc("nearby_markers", {
        longitude: -2.2490792,
        latitude: 53.4851459,
        distance: 10,
      })
      .then((res) => setData(res.data));
  });

  return (
    <>
      <Text>Hello World</Text>

      <FlatList
        data={data}
        renderItem={(item) => <Text>{JSON.stringify(item)}</Text>}
      />
    </>
  );
}

export default index;
