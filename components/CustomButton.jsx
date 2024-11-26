import { TouchableOpacity, Text } from "react-native";

export default function CustomButton({ title, onPress, color, disabled }) {
  let setColor;
  let disabledColor;

  if (color === "primary") {
    setColor = "bg-blue-500";
    disabledColor = "bg-blue-200";
  }

  if (color === "secondary") {
    setColor = "bg-green-500";
    disabledColor = "bg-green-200";
  }

  if (color === "tertiary") {
    setColor = "bg-red-500";
    disabledColor = "bg-red-200";
  }

  return (
    <TouchableOpacity
      className={`${setColor} py-3 px-5 rounded-lg mt-4`}
      disabled={disabled}
      onPress={onPress}
      style={{ opacity: disabled ? 0.4 : 1 }}
    >
      <Text className="text-white text-center font-semibold text-lg">
        {title}
      </Text>
    </TouchableOpacity>
  );
}
