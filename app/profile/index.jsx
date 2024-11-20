import React, { useState } from "react";
import { Text, View, TextInput, TouchableOpacity, Alert, StyleSheet } from "react-native";
import { supabase } from "./supabaseClient";
import { Input, Button } from "@rneui/themed";

const index = () => {
  const [state, setState] = useState({
    username: "",
    email: "",
    password: "",
  });

  const users = [
    { username: "David", password: "David" },
    { username: "Georgia", password: "Georgia" },
    { username: "Hannah", password: "Hannah" },
    { username: "Riona", password: "Riona" },
    { username: "Viktoriia", password: "Viktoriia" },
  ];

  const onPressLogin = () => {
    const user = users.find((user) => user.username === state.username);

    if (user) {
      if (user.password === state.password) {
        Alert.alert("Success", `Welcome back, ${state.username}!`);
      } else {
        Alert.alert("Error", "Incorrect password. Please try again.");
      }
    } else {
      Alert.alert("Error", "Username not found. Please sign up.");
    }
  };

  async function signInWithEmail() {
    const { error } = await supabase.auth.signInWithPassword({
      email: state.email,
      password: state.password,
    });

    if (error) {
      Alert.alert("Error", error.message);
    } else {
      Alert.alert("Success", "Signed in successfully!");
    }
  }

  async function signUpWithEmail() {
    const { error } = await supabase.auth.signUp({
      email: state.email,
      password: state.password,
    });

    if (error) {
      Alert.alert("Error", error.message);
    } else {
      Alert.alert(
        "Success",
        "Account created! Please check your inbox for email verification."
      );
    }
  }

  return (
    <View style={styles.container}>
      {/* юзернейм логин */}
      <Text style={styles.title}>Log In with Username</Text>
      <TextInput
        placeholder="Enter username"
        placeholderTextColor="#003f5c"
        onChangeText={(text) => setState((prevState) => ({ ...prevState, username: text }))}
        value={state.username}
        style={styles.input}
      />
      <TextInput
        placeholder="Enter password"
        placeholderTextColor="#003f5c"
        secureTextEntry
        onChangeText={(text) => setState((prevState) => ({ ...prevState, password: text }))}
        value={state.password}
        style={styles.input}
      />
      <TouchableOpacity onPress={onPressLogin} style={styles.button}>
        <Text style={styles.buttonText}>Log In</Text>
      </TouchableOpacity>

      {/* имейл и пассворд авторизация */}
      <Text style={styles.title}>Log In / Sign Up with Email</Text>
      <Input
        label="Email"
        leftIcon={{ type: "font-awesome", name: "envelope" }}
        placeholder="email@address.com"
        onChangeText={(text) => setState((prevState) => ({ ...prevState, email: text }))}
        value={state.email}
        autoCapitalize="none"
        containerStyle={styles.verticallySpaced}
      />
      <Input
        label="Password"
        leftIcon={{ type: "font-awesome", name: "lock" }}
        placeholder="Password"
        secureTextEntry={true}
        onChangeText={(text) => setState((prevState) => ({ ...prevState, password: text }))}
        value={state.password}
        autoCapitalize="none"
        containerStyle={styles.verticallySpaced}
      />
      <Button
        title="Sign In"
        onPress={signInWithEmail}
        containerStyle={styles.verticallySpaced}
      />
      <Button
        title="Create an Account"
        onPress={signUpWithEmail}
        containerStyle={styles.verticallySpaced}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginTop: 40,
    padding: 12,
  },
  title: {
    fontSize: 18,
    fontWeight: "bold",
    marginBottom: 10,
  },
  input: {
    marginVertical: 8,
    borderBottomWidth: 1,
    padding: 8,
  },
  button: {
    backgroundColor: "#6200EE",
    padding: 10,
    marginVertical: 10,
    borderRadius: 5,
    alignItems: "center",
  },
  buttonText: {
    color: "#FFFFFF",
    fontWeight: "bold",
  },
  verticallySpaced: {
    marginVertical: 10,
  },
});

export default index;