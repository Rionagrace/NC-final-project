import React, { useContext, useState } from "react";
import { Button, Text, TextInput, View } from "react-native";
import { AuthContext } from "../components/Auth/AuthContext";

export default function Login() {
  const [form, setForm] = useState({
    email: "",
    password: "",
  });

  const { user, error, signUp, signIn, signOut } = useContext(AuthContext);

  return (
    <View>
      <Text>{JSON.stringify(user)}</Text>
      <Text>{JSON.stringify(error)}</Text>
      <Text>Log In / Sign Up with Email</Text>
      <TextInput
        label="Email"
        leftIcon={{ type: "font-awesome", name: "envelope" }}
        placeholder="email@address.com"
        onChangeText={(text) =>
          setForm((prevState) => ({ ...prevState, email: text }))
        }
        value={form.email}
        autoCapitalize="none"
      />
      <TextInput
        label="Password"
        leftIcon={{ type: "font-awesome", name: "lock" }}
        placeholder="Password"
        secureTextEntry={true}
        onChangeText={(text) =>
          setForm((prevState) => ({ ...prevState, password: text }))
        }
        value={form.password}
        autoCapitalize="none"
      />
      <Button title="Sign In" onPress={() => signIn(form)} />
      <Button title="Sign Up" onPress={() => signUp(form)} />
      <Button title="Sign Out" onPress={signOut} />
    </View>
  );
}
