import React, { useState } from "react";
import { Text, View, TextInput, TouchableOpacity, Alert } from "react-native";
import { Link } from "expo-router";

const users = [
  { username: "David" },
  { username: "Georgia" },
  { username: "Hannah" },
  { username: "Riona" },
  { username: "Viktoriia" },
];

const index = () => {
  const [state, setState] = useState({
    username: "",
  });

  const onPressLogin = () => {
    const userExists = users.some((user) => user.username === state.username);
    if (userExists) {
      Alert.alert("Success", `Welcome back, ${state.username}!`);
    } else {
      Alert.alert("Error", "Username not found. Please sign up.");
    }
  };

  const onPressSignUp = () => {
    // Add a new user if the username doesn't already exist
    // const userExists = users.some(user => user.username === state.username);
    // if (userExists) {
    //   Alert.alert("Error", "Username already exists. Please log in.");
    // } else if (state.username.trim() === "") {
    //   Alert.alert("Error", "Please enter a valid username.");
    // } else {
    //   users.push({ username: state.username });
    //   Alert.alert("Success", `Welcome, ${state.username}! You have signed up.`);
    // }
  };

  const onPressLoginViaGmail = () => {};

  return (
    <View>
      <Text>Please log in</Text>
      <TextInput
        placeholder="Enter username"
        placeholderTextColor="#003f5c"
        onChangeText={(text) => setState({ username: text })}
        value={state.username}
      />
      <TouchableOpacity onPress={onPressLogin}>
        <Text>Login</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={onPressLoginViaGmail}>
        <Text>Log in via gmail</Text>
      </TouchableOpacity>
      <TouchableOpacity onPress={onPressSignUp}>
        <Link href="/signin">
          <Text>Create an account</Text>
        </Link>
      </TouchableOpacity>

      <Link href="/">Go home</Link>
    </View>
  );
};

export default index;
