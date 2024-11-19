import React, { useState } from "react";
import { TextInput } from "react-native";

export default function CustomInput({ onSubmit }) {
  const [value, setValue] = useState("100");
  return (
    <TextInput
      className="border p-2 rounded mb-4"
      value={value}
      onChangeText={setValue}
      onSubmitEditing={() => onSubmit(value)}
    />
  );
}
