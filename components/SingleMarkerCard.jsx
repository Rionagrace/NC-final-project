import { Text, View, Image } from "react-native";

export default function SingleMarkerCard({ markerData }) {
  return (
    <>
      <View>
        <View className="m-4 mb-0 last-child:mb-4 p-4 min-h-[100] flex justify-center content-center rounded-xl bg-white">
          <Text>{markerData.photo}</Text>
          <Image
            source={{
              uri: "https://www.dfc.co.uk/wp-content/uploads/2018/09/MTC-Oxford-House_taken-by-NS_0869.png",
            }}
            className="m-4 h-40 rounded-xl"
          />
          <Text className="text-gray-600 text-base font-medium mb-2">
            {markerData.address || "No address."}
          </Text>
          <Text className="text-gray-700 text-medium">
            {markerData.description || "No Description."}
          </Text>
        </View>
      </View>
    </>
  );
}
