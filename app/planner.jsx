import React, { useContext } from "react";
import { Animated, Button, PanResponder, StyleSheet } from "react-native";
import { FlatList, Text, View } from "react-native";
import useUserPlanner from "../hooks/useUserPlanner";
import { Link } from "expo-router";
import useDeleteMarkerPlanner from "../hooks/useDeleteMarkerPlanner";
import useDeleteAllPlanner from "../hooks/useDeleteAllPlanner";

export default function planner() {
	const { data, isPending, error } = useUserPlanner();
  const {mutate} = useDeleteMarkerPlanner()
  const {mutate: deleteAll} = useDeleteAllPlanner()


	if (isPending || error || !data) return null;

	return (
		<View style={styles.container}>
			{data[0].items.map((item) => {
        console.log(item)
				return (
          <View key={item.marker.marker_id} style={styles.item}>
					<Text style={styles.text}>
						{item.marker.title}
					</Text>
          <Button onPress={()=> mutate(item.marker.marker_id)} title="X"/>
          </View>
				);
			})}
      <Button onPress={deleteAll} title="Empty my planner"/>
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
