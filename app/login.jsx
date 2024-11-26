import React, { useContext, useState, useEffect } from "react";
import { Text, TextInput, View} from "react-native";
import { AuthContext } from "../components/Auth/AuthContext";
import CustomButton from "../components/CustomButton";
import { handleError } from "../utils/handleError";

export default function Login() {
  const [form, setForm] = useState({
    email: "",
    password: "",
  });

  const { signIn, signUp, error } = useContext(AuthContext);

  useEffect(() => {
    if (error) {
      handleError(error);
    }
  }, [error]);

  return (
    <View className="flex-1 justify-center items-center bg-gray-100 dark:bg-gray-800 p-6">
      <Text className="text-2xl font-extrabold text-gray-900 dark:text-white mb-6">
        Welcome Back!
      </Text>
      <Text className="text-base text-gray-700 dark:text-gray-300 mb-8 text-center">
        Sign in or create an account to continue.
      </Text>
      <View className="w-full mb-4">
        <Text className="text-sm font-semibold text-gray-600 dark:text-gray-400 mb-1">
          Email Address
        </Text>
        <TextInput
          className="bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-3 w-full focus:ring-blue-500 focus:border-blue-500"
          placeholder="email@address.com"
          onChangeText={(text) =>
            setForm((prevState) => ({ ...prevState, email: text }))
          }
          value={form.email}
          autoCapitalize="none"
          keyboardType="email-address"
        />
      </View>
      <View className="w-full mb-6">
        <Text className="text-sm font-semibold text-gray-600 dark:text-gray-400 mb-1">
          Password
        </Text>
        <TextInput
          className="bg-white dark:bg-gray-700 border border-gray-300 dark:border-gray-600 text-gray-900 dark:text-white rounded-lg p-3 w-full focus:ring-blue-500 focus:border-blue-500"
          placeholder="Password"
          secureTextEntry={true}
          onChangeText={(text) =>
            setForm((prevState) => ({ ...prevState, password: text }))
          }
          value={form.password}
          autoCapitalize="none"
        />
      </View>
      <View className="w-full">
        <CustomButton
          title="Sign In"
          onPress={() => signIn(form)}
          color="primary"
          disabled={!form.email || !form.password}
        />
        <CustomButton
          title="Sign Up"
          onPress={() => signUp(form)}
          color="secondary"
          disabled={!form.email || !form.password}
        />
      </View>
    </View>
  );
}
