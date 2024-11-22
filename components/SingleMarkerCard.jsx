import { Text, View } from "react-native";

export default function SingleMarkerCard({ markerData }) {
  return (
    <>
    <View className="m-4 p-4 rounded-xl bg-white shadow-sm space-y-4">
      {markerData.title && (
        <Text className="text-center text-3xl font-extrabold text-gray-800">
          {markerData.title}
        </Text>
      )}
    </View>
    <View >
    <Text className="m-4 mb-0 last-child:mb-4 p-4 min-h-[100] flex justify-center content-center rounded-xl bg-white" >{markerData.photo} There will be nice photo from Hannah and Georgia</Text>
          <Text className="text-gray-600 text-base font-medium mb-2" >{markerData.address} Address: should be here</Text>
          <Text className="text-gray-700 text-sm">{markerData.description} Description: should be here</Text>
    </View>
    </>
  );
}

// import { Text, View } from "react-native";

// export default function SingleMarkerCard({ markerData }) {
//   return (
//     <View className="m-4 p-4 rounded-xl bg-white shadow-lg space-y-4">
//       {/* Title */}
//       {markerData.title && (
//         <Text className="text-center text-3xl font-extrabold text-gray-800">
//           {markerData.title}
//         </Text>
//       )}

//       {/* Photo Section */}
//       <View className="rounded-lg bg-gray-100 h-40 justify-center items-center">
//         <Text className="text-gray-500 text-sm italic">
//           {markerData.photo || "A photo from Hannah and Georgia will be here"}
//         </Text>
//       </View>

//       {/* Address */}
//       {markerData.address && (
//         <Text className="text-gray-600 text-base font-medium">
//           Address: {markerData.address}
//         </Text>
//       )}

//       {/* Description */}
//       {markerData.description && (
//         <Text className="text-gray-700 text-sm">
//           Description: {markerData.description}
//         </Text>
//       )}
//     </View>
//   );
// }
