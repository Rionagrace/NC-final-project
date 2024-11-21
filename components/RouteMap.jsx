import { useState, useRef } from "react";
import Mapbox, {
	Camera,
	LineLayer,
	LocationPuck,
	MapView,
	MarkerView,
	ShapeSource,
	SymbolLayer,
} from "@rnmapbox/maps";
import { Button, View } from "react-native";

Mapbox.setAccessToken(process.env.EXPO_PUBLIC_MAPBOX_PK);

export default function RouteMap({ coords, distance, onSelectPlace = () => null, isInSelectMode = false }) {
	const mapRef = useRef(null); // Use a ref for the map instance
	const [routeGeoJSON, setRouteGeoJSON] = useState(null);

	// Dummy route coordinates
	const routeCoords = [
		[-2.24531978438671, 53.4771245864725],
		[-2.24465105455576, 53.4781646404297],
		[-2.23988384178912, 53.4783760685976],
    [-2.24394875223936, 53.4846719494712]
 
	];

	async function getMatchedRoute(coords) {
		const profile = "walking"; // Options: driving, walking, cycling
		const accessToken = process.env.EXPO_PUBLIC_MAPBOX_PK;

		// Convert coordinates array to the API's required string format
		const coordinates = coords.map((c) => c.join(",")).join(";");
		const radius = coords.map(() => 25).join(";"); // Optional, radius in meters around the points

		const query = `https://api.mapbox.com/matching/v5/mapbox/${profile}/${coordinates}?geometries=geojson&radiuses=${radius}&access_token=${accessToken}`;

		try {
			const response = await fetch(query);
			const json = await response.json();

			if (json.code !== "Ok") {
				throw new Error(`${json.code}: ${json.message}`);
			}

			// Matched route GeoJSON
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

			// Add route directly to the map if needed
			if (mapRef.current) {
				const map = mapRef.current; // Access the map instance
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
		<View style={{ flex: 1 }}>
			<MapView
				style={{ flex: 1 }}
				ref={mapRef} // Attach the ref to the MapView
			>
				<Camera zoomLevel={15} centerCoordinate={coords} />
				<LocationPuck puckBearing="heading" puckBearingEnabled />

				{/* Display the matched route */}
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