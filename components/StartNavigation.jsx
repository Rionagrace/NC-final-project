import { router } from "expo-router";
import { TouchableOpacity } from "react-native";

export default function StartNavigation({ children, href = null, onPress }) {
  const handlePress = () => {
    if (href) {
      router.navigate(href);
      return;
    }

    onPress();
  };

  return (
    <TouchableOpacity
      className="absolute size-[48] bg-slate-500 rounded-full flex justify-center items-center m-4 bottom-0 right-0"
      onPress={handlePress}
    >
      {children}
    </TouchableOpacity>
  );
}
