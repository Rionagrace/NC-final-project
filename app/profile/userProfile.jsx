import { View } from "react-native";
import { useState } from "react";

export default function userProfile () {
    const [state, setState] = useState({
        username: "",
      });
    return (
        <View>
          <Text>`Welcome ${user.username} </Text>
        
          <Text>All your markets:</Text>
          <Text>place for marker 1</Text>
          <Text>place for marker 2</Text>
          <Text>place for marker 3</Text>
        </View>
      );

}