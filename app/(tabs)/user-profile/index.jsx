import { Link } from "expo-router";
import { Text, TouchableOpacity, View } from "react-native";
import { useContext } from "react";
import { AuthContext } from "../../../components/Auth/AuthContext";
import CustomButton from "../../../components/CustomButton";

export default function Tab() {
  const { user, signOut } = useContext(AuthContext);

  return (
    <View className="flex-1 justify-center items-center bg-gray-50 dark:bg-gray-900 p-6 space-y-6">
      <View>
        <Text className="text-center text-xl font-bold text-gray-800 dark:text-gray-100">
          Welcome{" "}
          <Text className="text-gray-800">
            {user?.email.split("@")[0].charAt(0).toUpperCase() +
              user?.email.split("@")[0].slice(1)}
          </Text>
          !
        </Text>
      </View>

      <View className="w-full">
        <View className="mt-4">
          <Link href="/user-profile/my-spots" asChild>
            <TouchableOpacity className="border border-gray-300 bg-gray-100 py-3 rounded-lg shadow-sm">
              <Text className="text-center text-gray-800 dark:text-gray-100 font-medium text-lg">
                My Markers
              </Text>
            </TouchableOpacity>
          </Link>
        </View>

        <View className="mt-4">
          <Link href="/user-profile/my-votes" asChild>
            <TouchableOpacity className="border border-gray-300 bg-gray-100 py-3 rounded-lg shadow-sm">
              <Text className="text-center text-gray-800 dark:text-gray-100 font-medium text-lg">
                My Votes
              </Text>
            </TouchableOpacity>
          </Link>
        </View>
        <View className="mt-4">
          <CustomButton title="Logout" onPress={signOut} color="tertiary" />
        </View>
      </View>
    </View>
  );
}
