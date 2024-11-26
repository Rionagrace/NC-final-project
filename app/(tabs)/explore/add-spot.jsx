import { useEffect, useState } from "react";
import { Text, View, TouchableOpacity } from "react-native";
import useUserAddMarker from "../../../hooks/useUserAddMarker";
import CustomInput from "../../../components/CustomInput";
import InteractiveMap from "../../../components/InteractiveMap";
import CustomButton from "../../../components/CustomButton";

export default function AddSpot() {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [coordinates, setCoordinates] = useState([]);

  const [toggleMap, setToggleMap] = useState(false);

  const { data, isPending, error, mutate } = useUserAddMarker();

  useEffect(() => {}, [data, isPending, error]);

  function handleSubmit() {
    mutate({ title, description, coordinates });
  }

  return (
    <View className="flex justify-center items-center bg-gray-100 dark:bg-gray-800 p-6">
      <Text className="text-base text-gray-700 dark:text-gray-300 mb-4 text-center">
        Provide details and select a location on the map
      </Text>
      <View className="w-full mb-4">
        <CustomInput onChange={setTitle} label="Title:" />
      </View>
      <View className="w-full mb-6">
        <CustomInput onChange={setDescription} label="Description:" />
      </View>
      <TouchableOpacity
        className={`${
          toggleMap ? "bg-red-500" : "bg-blue-500"
        } py-3 px-5 rounded-lg w-full mb-4`}
        onPress={() => setToggleMap(!toggleMap)}
      >
        <Text className="text-white text-center font-semibold text-lg">
          {toggleMap ? "Close Map" : "Select from Map"}
        </Text>
      </TouchableOpacity>
      {toggleMap && (
        <View className="h-64 w-full mb-4 border border-gray-300 dark:border-gray-600 rounded-lg overflow-hidden">
          <InteractiveMap
            coords={[-2.243056, 53.477778]}
            distance={1000}
            onSelectPlace={setCoordinates}
            isInSelectMode
          />
        </View>
      )}
      <Text
        className={`text-sm ${
          coordinates.length
            ? "text-gray-700 dark:text-gray-300"
            : "text-gray-400"
        } mb-4`}
      >
        {coordinates.length
          ? `Coordinates: ${coordinates[0]}, ${coordinates[1]}`
          : "No coordinates selected."}
      </Text>
      <CustomButton
        title={isPending ? "Submitting..." : "Submit"}
        onPress={handleSubmit}
        color="secondary"
        disabled={isPending || !title || !description || !coordinates.length}
      />
      {data && (
        <Text className="text-green-600 dark:text-green-400 text-center mt-4">
          Spot added successfully!
        </Text>
      )}
    </View>
  );
}
