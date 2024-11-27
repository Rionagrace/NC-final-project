import {
  Camera,
  Images,
  LineLayer,
  MarkerView,
  ShapeSource,
  SymbolLayer,
} from "@rnmapbox/maps";
import { useQuery } from "@tanstack/react-query";
import { Link } from "expo-router";
import React, { useState } from "react";
import { Button, StyleSheet, Text, View } from "react-native";
import useUserPlanner from "../hooks/useUserPlanner";
import { mapboxInstance } from "../utils/mapboxInstance";

export default function MapLayerPlanner({ enable, userCoords }) {
  const [selectedFeature, setSelectedFeature] = useState(null);

  const styles = StyleSheet.create({
    calloutContainerStyle: {
      backgroundColor: "white",
      padding: 10,
      borderRadius: 5,
    },
    customCalloutText: {
      color: "black",
      fontSize: 16,
    },
  });

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

  const coordinates = route.routes[0].geometry.coordinates;
  if (!route || !coordinates) {
    return <Text>Loading...</Text>;
  }

  const [minLng, minLat, maxLng, maxLat] = coordinates.reduce(
    ([minLng, minLat, maxLng, maxLat], [lng, lat]) => [
      Math.min(minLng, lng),
      Math.min(minLat, lat),
      Math.max(maxLng, lng),
      Math.max(maxLat, lat),
    ],
    [Infinity, Infinity, -Infinity, -Infinity]
  );

  const geojsonPlanner = {
    type: "FeatureCollection",
    features: planner[0].items?.map((point) => ({
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [point.marker.longitude, point.marker.latitude],
      },
      properties: {
        title: point.marker.title,
        marker_id: point.marker.marker_id,
      },
    })),
  };

  function closePopUp() {
    setSelectedFeature(null);
  }

  function onPinPress(event) {
    const feature = event?.features[0];
    setSelectedFeature((prevSelectedFeature) =>
      prevSelectedFeature && prevSelectedFeature.id === feature.id
        ? null
        : feature
    );
  }

  function MarkerPopUp({ item: { title, marker_id, image } }) {
    return (
      <View style={styles.calloutContainerStyle}>
        <Button
          onPress={() => {
            closePopUp();
          }}
          title="x"
        />
        <Text style={styles.customCalloutText}>{title}</Text>
        {/* <Image source={{url: image}} className="m-4 h-20 rounded-xl"/> */}
        <Link
          className="bg-blue-500 py-3 rounded-lg text-center "
          href={`(tabs)/explore/${marker_id}`}
        >
          take me here
        </Link>
      </View>
    );
  }

  return (
    <>
      <Images
        images={{
          green_triangle: require("../assets/maki--triangle32.png"),
          red_marker: require("../assets/image.png"),
        }}
      />
      {selectedFeature ? (
        <Camera
          zoomLevel={15}
          centerCoordinate={selectedFeature.geometry.coordinates}
        />
      ) : userCoords ? (
        <Camera
          zoomLevel={15}
          centerCoordinate={[userCoords.longitude, userCoords.latitude]}
        />
      ) : (
        <Camera
          bounds={{
            ne: [maxLng, maxLat],
            sw: [minLng, minLat],
          }}
          padding={{
            paddingTop: 50,
            paddingBottom: 50,
            paddingLeft: 50,
            paddingRight: 50,
          }}
          animationDuration={0}
          // centerCoordinate={coordinates[0]}
        />
      )}
      {/* planner markers */}
      <ShapeSource id="points" shape={geojsonPlanner} onPress={onPinPress}>
        <SymbolLayer
          id="point-layer"
          source="points"
          style={{
            iconImage: "red_marker",
            iconSize: 1,
            iconAllowOverlap: true,
          }}
        />
      </ShapeSource>
      {/* route line */}
      <ShapeSource id="route" shape={route.routes[0].geometry}>
        <LineLayer
          id="route-layer"
          style={{
            lineColor: "#03AA46",
            lineWidth: 5,
            lineOpacity: 0.8,
          }}
        />
        {/* route arrows */}
        <SymbolLayer
          id="arrowLayer"
          style={{
            iconImage: "green_triangle",
            iconSize: 0.5,
            iconRotate: 45,
            symbolPlacement: "line",
            iconAllowOverlap: true,
            symbolSpacing: 50,
          }}
        />
      </ShapeSource>
      {selectedFeature && (
        <MarkerView coordinate={selectedFeature.geometry.coordinates}>
          <MarkerPopUp item={selectedFeature?.properties} />
        </MarkerView>
      )}
    </>
  );
}
