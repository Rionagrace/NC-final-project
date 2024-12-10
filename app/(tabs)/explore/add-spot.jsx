import { useRouter } from "expo-router";
import { useEffect, useState } from "react";
import {
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import CustomButton from "../../../components/CustomButton";
import InteractiveMap from "../../../components/InteractiveMap";
import useUserAddMarker from "../../../hooks/useUserAddMarker";

export default function AddSpot() {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [image, setImage] = useState("");
  const [coordinates, setCoordinates] = useState([]);

  const [toggleMap, setToggleMap] = useState(false);

  const router = useRouter();

  const { data, isPending, error, mutate } = useUserAddMarker();

  useEffect(() => {
    const markerId = data?.marker_id;

    if (error || isPending || !markerId) return;

    router.replace("/explore/" + markerId);
  }, [data]);

  function handleSubmit() {
    mutate({ title, description, coordinates, image });
  }

  return (
    <ScrollView>
      <View className="flex justify-center items-center bg-gray-100 dark:bg-gray-800 p-6">
        <Text className="text-base text-gray-700 dark:text-gray-300 mb-4 text-center">
          Provide details and select a location on the map
        </Text>
        <View className="w-full mb-4">
          <Text className="text-sm font-semibold text-gray-600 dark:text-gray-400 mb-1">
            Title:
          </Text>
          <TextInput
            className="bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-3 w-full focus:ring-blue-500 focus:border-blue-500"
            placeholder=""
            onChangeText={setTitle}
          />
        </View>
        <View className="w-full mb-6">
          <Text className="text-sm font-semibold text-gray-600 dark:text-gray-400 mb-1">
            Description:
          </Text>
          <TextInput
            className="bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-3 w-full focus:ring-blue-500 focus:border-blue-500"
            placeholder=""
            onChangeText={setDescription}
          />
        </View>
        <View className="w-full mb-6">
          <Text className="text-sm font-semibold text-gray-600 dark:text-gray-400 mb-1">
            Image URL:
          </Text>
          <TextInput
            className="bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-3 w-full focus:ring-blue-500 focus:border-blue-500"
            placeholder=""
            onChangeText={setImage}
          />
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
    </ScrollView>
  );
}
