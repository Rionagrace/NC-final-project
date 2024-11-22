import { View } from "react-native";
import HeadingTop from "../../components/HeadingTop";
import DevAuthenticatedUser from "../../dev_components/DevAuthenticatedUser";

export default function Page() {
  return (
    <View className="p-4">
      <HeadingTop>Dev Page</HeadingTop>
      <DevAuthenticatedUser />
    </View>
  );
}
