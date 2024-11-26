import React, { useContext, useEffect, useState } from "react";
import { Animated, Button, PanResponder, StyleSheet } from "react-native";
import { FlatList, Text, View } from "react-native";
import useUserPlanner from "../hooks/useUserPlanner";
import { Link } from "expo-router";
import useDeleteMarkerPlanner from "../hooks/useDeleteMarkerPlanner";
import useDeleteAllPlanner from "../hooks/useDeleteAllPlanner";

export default function planner() {
	const { data, isPending, error } = useUserPlanner();
	const [plannerData, setPlannerData] = useState([]);
  const {mutate} = useDeleteMarkerPlanner()
  const {mutate: deleteAll} = useDeleteAllPlanner()
  
	useEffect(() => {
		if (data && data[0]?.items) {
			setPlannerData(data[0].items);
		}
	}, [data]);

	if (isPending || error || !data) return null;

  const swapItems = (index1, index2) => {
    if (index1 < 0 || index2 < 0 || index1 >= plannerData.length || index2 >= plannerData.length) return;
    setPlannerData((prevList) => {
      const newList = [...prevList];
      [newList[index1], newList[index2]] = [newList[index2], newList[index1]];
      return newList;
    });
  };

	return (
		<View style={styles.container}>
			<FlatList
				data={plannerData}
				keyExtractor={(item, index) => index.toString()}
				renderItem={({ item, index }) => (
					<View style={styles.item}>
						<Button onPress={() => mutate(item.marker.marker_id)} title="X" />
						<Text style={styles.text}>{item.marker.title}</Text>
						<Button
							onPress={() => {
								swapItems(index, index-1);
							}}
							title="↑"
						/>
						<Button onPress={() => {
								swapItems(index, index+1);
							}} title="↓" />
					</View>
				)}
			/>
			<Button onPress={deleteAll} title="Empty my planner" />
      <Button title="Save my route"/>
			<Link href="/explore?route=show">View my route</Link>
		</View>
	);
}
const styles = StyleSheet.create({
	container: {
		flex: 1,
		justifyContent: "top",
		alignItems: "center",
		padding: 20,
		backgroundColor: "#f5f5f5",
	},
	item: {
		padding: 20,
		marginBottom: 10,
		borderRadius: 8,
		backgroundColor: "#fff",
		borderWidth: 1,
		borderColor: "#ccc",
	},
	text: {
		fontSize: 16,
	},
});

{
	/* {plannerData.map((item) => {
				return (
          <View key={item.marker.marker_id} style={styles.item}>
					<Text style={styles.text}>
						{item.marker.title}
					</Text>
          <Button onPress={() => {swapItems(0,1)}} title="↑"/>
          <Button title="↓"/>
          </View>
				);
       
			})} */
}
