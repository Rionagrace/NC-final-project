import { useLocalSearchParams } from "expo-router";
import React, { useContext, useState } from "react";
import { Text, View } from "react-native";
import AddNewMarkerButton from "../../../components/AddNewMarkerButton";
import { AuthContext } from "../../../components/Auth/AuthContext";
import InteractiveMap from "../../../components/InteractiveMap";
import MapLayerPlanner from "../../../components/MapLayerPlanner";
import MultiDropDown from "../../../components/MultiSelect";
import NavigateTo from "../../../components/NavigateTo";
import useCurrentLocation from "../../../hooks/useCurrentLocation";

export default function Explore() {
  const { route, navigate } = useLocalSearchParams();
  const { location, isPending, error } = useCurrentLocation(
    navigate === "true"
  );
  const { user } = useContext(AuthContext);
  const [selectedItems, setSelectedItems] = useState([]);

  if (isPending) return <Text>Pending...</Text>;
  if (error) return <Text>{JSON.stringify(error)}</Text>;
  if (!location) return <Text>No Location</Text>;

  return (
    <>
      <View>
        <MultiDropDown
          onSelectItems={(value) => {
            setSelectedItems(value);
          }}
        />
      </View>
      <View style={{ height: "100%" }}>
        <InteractiveMap
          coords={[location.longitude, location.latitude]}
          distance={3000}
          routeComponent={
            route === "show" && (
              <MapLayerPlanner
                enable={route === "show"}
                navigate={navigate}
                userCoords={navigate === "true" && location}
              />
            )
          }
          filterCategories={selectedItems}
          route={route}
        />
      </View>
      <AddNewMarkerButton href="/explore/add-spot" />
      {user && route && <NavigateTo />}
    </>
  );
}
