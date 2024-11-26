import { LineLayer, ShapeSource } from "@rnmapbox/maps";
import { useQuery } from "@tanstack/react-query";
import React from "react";
import { Text } from "react-native";
import useUserPlanner from "../hooks/useUserPlanner";
import { mapboxInstance } from "../utils/mapboxInstance";

export default function MapLayerPlanner({ enable }) {
  console.log({ enable });

  const {
    data: planner,
    isPending: gettingPlanner,
    error: errorPlanner,
  } = useUserPlanner();

  const {
    data: route,
    isPending: gettingRoute,
    error: errorRoute,
  } = useQuery({
    queryKey: ["user", "planner", "map"],
    queryFn: () => {
      console.log("fetching");
      const profile = "walking";
      const coords = planner[0].items
        .map(
          ({ marker: { longitude, latitude } }) => longitude + "," + latitude
        )
        .join(";");

      return mapboxInstance
        .get(`/${profile}/${coords}`, {
          params: {
            alternatives: true,
            continue_straight: true,
            geometries: "geojson",
            language: "en",
            overview: "full",
            steps: true,
          },
        })
        .then((res) => res.data)
        .catch((e) => console.error(e));
    },
    enabled: Boolean(planner?.[0]) && enable,
  });

  if (gettingPlanner) return <Text>Getting Planner...</Text>;
  if (gettingRoute) return <Text>Getting Route...</Text>;
  if (errorPlanner || errorRoute)
    return <Text>ERROR: {JSON.stringify(errorPlanner || errorRoute)}</Text>;

  return (
    <ShapeSource id="route" shape={route.routes[0].geometry}>
      <LineLayer
        id="route-layer"
        style={{
          lineColor: "#03AA46",
          lineWidth: 5,
          lineOpacity: 0.8,
        }}
      />
    </ShapeSource>
  );
}
