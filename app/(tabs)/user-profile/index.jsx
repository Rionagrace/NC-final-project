import { Link } from "expo-router";
import { Text, TouchableOpacity, View } from "react-native";
import { useContext } from "react";
import { AuthContext } from "../../../components/Auth/AuthContext";
import CustomButton from "../../../components/CustomButton";

export default function Tab() {
  const { user, signOut } = useContext(AuthContext);

  return (
    <View className="flex-1 justify-center items-center bg-gray-100 dark:bg-gray-800 p-6 space-y-6">
      <View className="w-full bg-white dark:bg-gray-700 rounded-lg shadow-md p-4">
        <Text className="text-center text-lg font-bold text-gray-800">
          Welcome{" "}
          {user?.email.split("@")[0].charAt(0).toUpperCase() +
            user?.email.split("@")[0].slice(1) +
            "!"}
        </Text>
      </View>

      <View className="w-full mt-4">
        <Link
          href="/user-profile/my-spots"
          className="bg-green-500 py-3 rounded-lg text-center "
        >
          <Text className="text-white font-semibold text-lg">My Markers</Text>
        </Link>
        <CustomButton title="Logout" onPress={signOut} color="tertiary"/>
      </View>
    </View>
  );
}
