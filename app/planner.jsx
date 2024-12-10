import { FontAwesome6 } from "@expo/vector-icons";
import { useRouter } from "expo-router";
import React, { useEffect, useState } from "react";
import { FlatList, Text, TouchableOpacity, View } from "react-native";
import CustomButton from "../components/CustomButton";
import useDeleteAllPlanner from "../hooks/useDeleteAllPlanner";
import useDeleteMarkerPlanner from "../hooks/useDeleteMarkerPlanner";
import useUserPlanner from "../hooks/useUserPlanner";
import useUserPlannerUpdate from "../hooks/useUserPlannerUpdate";

export default function planner() {
  const { data, isPending, error } = useUserPlanner();
  const [plannerData, setPlannerData] = useState([]);
  const { mutate } = useDeleteMarkerPlanner();
  const { mutate: deleteAll } = useDeleteAllPlanner();
  const { mutate: plannerUpdate, error: plannerUpdateError } =
    useUserPlannerUpdate();
  const [routeModified, setRouteModified] = useState(false);
  const router = useRouter();

  
  useEffect(() => {
    if (data && data[0]?.items) {
      setPlannerData(data[0].items);
      setRouteModified(false);
    }
  }, [data]);

  if (isPending || error || !data)
    return (
      <View className="p-4 h-full flex flex-col items-center justify-center">
        <CustomButton
          title="Login to Add to Planner"
          color="primary"
          onPress={() => router.replace("/login")}
        />
      </View>
    );

  const swapItems = (index1, index2) => {
    if (
      index1 < 0 ||
      index2 < 0 ||
      index1 >= plannerData.length ||
      index2 >= plannerData.length
    )
      return;

    setPlannerData((prevList) => {
      const newList = [...prevList];
      [newList[index1], newList[index2]] = [newList[index2], newList[index1]];
      return newList;
    });

    setRouteModified(true);
  };

  return (
    <View className="flex-1 px-4 py-6 bg-gray-100 dark:bg-gray-800">
      <FlatList
        data={plannerData}
        keyExtractor={(item, index) => index.toString()}
        renderItem={({ item, index }) => (
          <View className="flex-row bg-white dark:bg-gray-700 rounded-lg p-4 mb-4 shadow-sm items-center">
            <TouchableOpacity
              className="pe-2"
              onPress={() => mutate(item.marker.marker_id)}
            >
              <FontAwesome6 size={26} name="xmark" color="#ef4444" />
            </TouchableOpacity>
            <Text>{item.marker.title}</Text>
            <View
              className="flex flex-row"
              style={{
                marginLeft: "auto",
              }}
            >
              <TouchableOpacity
                className="pe-2 me-2"
                onPress={() => {
                  swapItems(index, index - 1);
                }}
              >
                <FontAwesome6 size={20} name="arrow-up" color="seagreen" />
              </TouchableOpacity>
              <TouchableOpacity
                className="pe-2"
                onPress={() => {
                  swapItems(index, index + 1);
                }}
              >
                <FontAwesome6 size={20} name="arrow-down" color="seagreen" />
              </TouchableOpacity>
            </View>
          </View>
        )}
      />
      <View>
        <CustomButton
          color="primary"
          onPress={() => {
            plannerUpdate(plannerData);
          }}
          title="Save order"
        />
        <CustomButton
          disabled={routeModified}
          color="secondary"
          onPress={() => router.push("/explore?route=show")}
          title="View route"
        />
        <CustomButton
          color="tertiary"
          onPress={deleteAll}
          title="Empty planner"
        />
      </View>
    </View>
  );
}
