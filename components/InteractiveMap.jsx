import Mapbox, {
  Camera,
  LocationPuck,
  MapView,
  MarkerView,
  ShapeSource,
  SymbolLayer,
  LineLayer,
} from "@rnmapbox/maps";
import { useState, useRef } from "react";
import { Button, StyleSheet, Text, View } from "react-native";
import useNearbyMarkers from "../hooks/useNearbyMarkers";
import { Link } from "expo-router";

Mapbox.setAccessToken(process.env.EXPO_PUBLIC_MAPBOX_PK);

const styles = StyleSheet.create({
  container: {
    height: "100%",
    width: "100%",
  },
  map: {
    flex: 1,
  },
  icon: {
    iconImage: "rocket",
    iconSize: 1.5,
  },
  iconSelected: {
    iconImage: "marker",
    iconSize: 3,
  },
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

export default function InteractiveMap({
  coords,
  distance,
  onSelectPlace = () => null,
  isInSelectMode = false,
  routeCoords,
}) {
  const { data, isPending, error } = useNearbyMarkers({ coords, distance });
  const [selectedFeature, setSelectedFeature] = useState(null);
  const [selectedCoordinates, setSelectedCoordinates] = useState(null);
  const mapRef = useRef(null);
  const [routeGeoJSON, setRouteGeoJSON] = useState(null);

  if (isPending) return <Text>Pending...</Text>;

  const geojson = {
    type: "FeatureCollection",
    features: data?.map((point) => ({
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [point.longitude, point.latitude],
      },
      properties: {
        title: point.title,
        marker_id: point.marker_id,
      },
    })),
  };

  const geojsonLongPress = selectedCoordinates && {
    type: "FeatureCollection",
    features: [
      {
        type: "Feature",
        geometry: {
          type: "Point",
          coordinates: [selectedCoordinates[0], selectedCoordinates[1]],
        },
        properties: {
          title: "selected",
        },
      },
    ],
  };

  function onPinPress(event) {
    const feature = event?.features[0];
    setSelectedFeature((prevSelectedFeature) =>
      prevSelectedFeature && prevSelectedFeature.id === feature.id
        ? null
        : feature
    );
  }

  function handleLongPress(event) {
    if (!isInSelectMode) return;
    onSelectPlace(event.geometry.coordinates);
    setSelectedCoordinates(event.geometry.coordinates);
  }
  //route mapping

  async function getMatchedRoute(coords) {
    const profile = "walking"; // Options: driving, walking, cycling
    const accessToken = process.env.EXPO_PUBLIC_MAPBOX_PK;

    const coordinates = coords.map((c) => c.join(",")).join(";");
    const radius = coords.map(() => 25).join(";");

    const query = `https://api.mapbox.com/matching/v5/mapbox/${profile}/${coordinates}?geometries=geojson&radiuses=${radius}&access_token=${accessToken}`;

    try {
      const response = await fetch(query);
      const json = await response.json();

      if (json.code !== "Ok") {
        throw new Error(`${json.code}: ${json.message}`);
      }
      return json.matchings[0].geometry;
    } catch (error) {
      console.error("Error fetching matched route:", error);
      return null;
    }
  }

  async function fetchAndDrawRoute() {
    const matchedRoute = await getMatchedRoute(routeCoords);
    if (matchedRoute) {
      const route = {
        type: "Feature",
        geometry: matchedRoute,
        properties: {},
      };

      setRouteGeoJSON(route);

      if (mapRef.current) {
        const map = mapRef.current;
        addRouteToMap(map, route);
      }
    }
  }

  function addRouteToMap(map, routeGeoJSON) {
    if (map.getSource("route")) {
      map.getSource("route").setData(routeGeoJSON);
    } else {
      map.addSource("route", {
        type: "geojson",
        data: routeGeoJSON,
      });

      map.addLayer({
        id: "route",
        type: "line",
        source: "route",
        layout: {
          "line-join": "round",
          "line-cap": "round",
        },
        paint: {
          "line-color": "#03AA46",
          "line-width": 5,
          "line-opacity": 0.8,
        },
      });
    }
  }

  return (
    <View style={styles.container}>
      <MapView style={styles.map} onLongPress={handleLongPress} ref={mapRef}>
        <Camera zoomLevel={15} centerCoordinate={coords} animationMode="none" />
        <LocationPuck puckBearing="heading" puckBearingEnabled />
        {/* location markers */}
        {!isInSelectMode && (
          <ShapeSource id="points" shape={geojson} onPress={onPinPress}>
            <SymbolLayer id="point-layer" source="points" style={styles.icon} />
          </ShapeSource>
        )}
        {/*long press icon */}
        {geojsonLongPress && (
          <ShapeSource id="selectedCoords" shape={geojsonLongPress}>
            <SymbolLayer
              id="selected-layer"
              source="selectedCoords"
              style={styles.iconSelected}
            />
          </ShapeSource>
        )}
        {/*selected feature pop up */}
        {selectedFeature && (
          <MarkerView coordinate={selectedFeature.geometry.coordinates}>
            <MarkerPopUp item={selectedFeature?.properties} />
          </MarkerView>
        )}
        {/* route line layer */}
        {routeGeoJSON && (
          <ShapeSource id="route" shape={routeGeoJSON}>
            <LineLayer
              id="route-layer"
              style={{
                lineColor: "#03AA46",
                lineWidth: 5,
                lineOpacity: 0.8,
              }}
            />
          </ShapeSource>
        )}
      </MapView>
      <Button onPress={fetchAndDrawRoute} title="Draw Route" />
    </View>
  );
}

function MarkerPopUp({ item: { title, marker_id } }) {
  return (
    <View style={styles.calloutContainerStyle}>
      <Text style={styles.customCalloutText}>{title}</Text>
      <Link href={`(tabs)/explore/${marker_id}`}>take me here</Link>
    </View>
  );
}
