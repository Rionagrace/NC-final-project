import { createContext } from "react";

export const AuthContext = createContext({
  user: null,
  error: null,
  isPending: true,
  signUp: () => null,
  signIn: () => null,
  signOut: () => null,
});
