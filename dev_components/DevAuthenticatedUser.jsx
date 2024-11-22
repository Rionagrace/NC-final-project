import { useContext } from "react";
import { FlatList, Text } from "react-native";
import { AuthContext } from "../components/Auth/AuthContext";
import DevFeatureWrapper from "./DevFeatureWrapper";

export default function DevAuthenticatedUser() {
  const { user, error, isPending } = useContext(AuthContext);

  return (
    <DevFeatureWrapper title="Authenticated User">
      {isPending && <Text>Pending...</Text>}
      {error && <Text>{JSON.stringify(error)}</Text>}
      {user ? (
        <FlatList
          data={Object.entries(user)}
          renderItem={({ item: [key, val] }) => (
            <Text>
              {key}: {JSON.stringify(val)}
            </Text>
          )}
        />
      ) : (
        <Text>UNAUTHENICATED</Text>
      )}
    </DevFeatureWrapper>
  );
}
