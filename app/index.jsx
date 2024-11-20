import React, { useState } from "react";
import PostgisQuery from "../components/PostgisQuery";
import PostgisMutate from "../components/PostgisMutate";

export default function index() {
  const [newCoords, setNewCoords] = useState([]);
  return (
    <>
      <PostgisQuery coords={newCoords} />
      <PostgisMutate onFocusedCoords={setNewCoords} />
    </>
  );
}
