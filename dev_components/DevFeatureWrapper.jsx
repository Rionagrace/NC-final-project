import { useState } from "react";
import { Button, View } from "react-native";

export default function DevFeatureWrapper({ title, children }) {
  const [isHidden, setIsHidden] = useState(true);
  return (
    <View>
      <Button title={title} onPress={() => setIsHidden(!isHidden)} />
      {!isHidden && children}
    </View>
  );
}
