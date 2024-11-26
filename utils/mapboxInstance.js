import axios from "axios";

export const mapboxInstance = axios.create({
  baseURL: "https://api.mapbox.com/directions/v5/mapbox",
  params: {
    access_token: process.env.EXPO_PUBLIC_MAPBOX_PK,
  },
});
