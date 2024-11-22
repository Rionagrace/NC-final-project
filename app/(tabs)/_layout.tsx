import { FontAwesome6 } from "@expo/vector-icons";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import { Tabs } from "expo-router";
import { Screen } from "expo-router/build/views/Screen";
import { useContext, useEffect } from "react";
import { AuthContext } from "../../components/Auth/AuthContext";

export default function _layout() {
  const { user } = useContext(AuthContext);

  return (
    <Tabs screenOptions={{ tabBarActiveTintColor: "blue", headerShown: false }}>
      <Tabs.Screen
        name="index"
        options={{
          title: "Tab One",
          href: null,
        }}
      />
      <Screen
        name="feed"
        options={{
          title: "Feed",
          tabBarIcon: ({ color }) => (
            <FontAwesome6 size={28} name={"bars-staggered"} color={color} />
          ),
        }}
      />
      <Screen
        name="explore"
        options={{
          title: "Explore",
          tabBarIcon: ({ color }) => (
            <FontAwesome size={28} name={"map"} color={color} />
          ),
        }}
      />
      {user ? (
        <Screen
          name="user-profile"
          options={{
            title: "User",
            tabBarIcon: ({ color }) => (
              <FontAwesome size={28} name={"user"} color={color} />
            ),
          }}
        />
      ) : (
        <Screen
          name="user-profile"
          options={{
            title: "Login",
            tabBarIcon: ({ color }) => (
              <FontAwesome size={28} name={"user"} color={color} />
            ),
            href: "/login",
          }}
        />
      )}
    </Tabs>
  );
}
