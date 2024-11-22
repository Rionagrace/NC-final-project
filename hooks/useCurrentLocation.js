import { useEffect, useState } from "react";
import * as Location from "expo-location";

export default function useCurrentLocation(follow = false) {
  const [location, setLocation] = useState(null);
  const [isPending, setIsPending] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    setIsPending(true);

    Location.requestForegroundPermissionsAsync()
      .then((res) => {
        console.log({"requestForegroundPermissionsAsync": res})
        if (res.status !== "granted") return Promise.reject("NO_PERMISSION");

        return Location.getLastKnownPositionAsync().then((res) => {
          console.log({"getLastKnownPositionAsync": res})
          if (res) return res;

          return getCurrentPositionAsync({ accuracy: 6 });
        });
      })
      .then((res) => {
        console.log({"getCurrentPositionAsync": res})
        setLocation(res.coords);

        if (follow) {
          return Location.watchPositionAsync(
            { accuracy: 6, timeInterval: 60000 },
            ({ coords }) => {
              console.log({ watchPositionAsync: coords });

              setLocation(coords);
            }
          );
        }
      })
      .catch((e) => setError(e))
      .finally(() => setIsPending(false));
  }, []);

  return { location, isPending, error };
}
