import { Alert } from "react-native";
export const handleError = (error) => {
    if (error === "user_already_exists") {
        Alert.alert("Error", "User already exists!");
      }
      if (error === "weak_password") {
        Alert.alert(
          "Incorrect Password",
          "Your password is easily guessed and needs to be changed."
        );
      }
      if (error === "validation_failed") {
        Alert.alert("Incorrect Email", "Please provide a correct email address!");
      }
      if (error === "invalid_credentials") {
        Alert.alert("Error", "Please provide a correct email or password!");
      }
    //   else {
    //     Alert.alert("Error", "An unknown error occurred.")
    //   }
  };