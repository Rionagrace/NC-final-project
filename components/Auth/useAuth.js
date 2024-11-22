import { useEffect, useState } from "react";
import { supabase } from "../../utils/supabaseClient";
import { useRouter } from "expo-router";

export default function useAuth() {
  const [user, setUser] = useState(null);
  const [error, setError] = useState(null);
  const [isPending, setIsPending] = useState(true);
  const router = useRouter();

  const fnWrapper = (callback = async () => null, redirectTo = null) => {
    setIsPending(true);
    setError(null);

    return callback()
      .then(({ error }) => {
        if (error) {
          return Promise.reject(error);
        }
        return supabase.auth.getUser();
      })
      .then((res) => setUser(res.data.user))
      .then(() => router.replace(redirectTo))
      .catch((e) => setError(e.__isAuthError ? e.code : e))
      .finally(() => setIsPending(false));
  };

  useEffect(() => {
    fnWrapper();
  }, []);

  const signUp = ({ email, password }) =>
    fnWrapper(
      () =>
        supabase.auth.signUp({
          email,
          password,
        }),
      "/user-profile"
    );

  const signIn = ({ email, password }) =>
    fnWrapper(
      () =>
        supabase.auth.signInWithPassword({
          email,
          password,
        }),
      "/user-profile"
    );

  const signOut = () => fnWrapper(() => supabase.auth.signOut(), "/");

  return {
    user,
    signUp,
    signIn,
    signOut,
    error,
    isPending,
  };
}
