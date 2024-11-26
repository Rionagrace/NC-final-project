import Mapbox, {
  Camera,
  LocationPuck,
  MapView,
  MarkerView,
  ShapeSource,
  SymbolLayer,
	Images
} from "@rnmapbox/maps";
import { Link } from "expo-router";
import { useRef, useState } from "react";
import { Button, StyleSheet, Text, View } from "react-native";
import useNearbyMarkers from "../hooks/useNearbyMarkers";


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
    iconImage: "green_marker",
    iconSize: .1,
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
  routeComponent,
}) {
  const { data, isPending, error } = useNearbyMarkers({ coords, distance });
  const [selectedFeature, setSelectedFeature] = useState(null);
  const [selectedCoordinates, setSelectedCoordinates] = useState(null);
  const mapRef = useRef(null);

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

	function closePopUp (){
		setSelectedFeature(null)
	}

	function MarkerPopUp({ item: { title, marker_id } }) {
		return (
			<View style={styles.calloutContainerStyle}>
				<Button
					onPress={() => {
						closePopUp();
					}}
					title="x"
				/>
				<Text style={styles.customCalloutText}>{title}</Text>
				<Link className="bg-blue-500 py-3 rounded-lg text-center " href={`(tabs)/explore/${marker_id}`}>take me here</Link>
			</View>
		);
	}


  return (
		
    <View style={styles.container}>
      <MapView style={styles.map} onLongPress={handleLongPress} ref={mapRef}>
        {!routeComponent && <Camera zoomLevel={15} centerCoordinate={coords} />}
        <LocationPuck puckBearing="heading" puckBearingEnabled />
				<Images
          images={{
            green_marker: require('../assets/green-marker.png'), 
          }}
        />
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
        {routeComponent}
      </MapView>
    </View>
  );
}

