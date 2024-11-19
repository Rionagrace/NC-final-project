import React, { useState } from "react";
import CustomInput from "../components/CustomInput";
import MarkerList from "../components/MarkerList";
import PageTitle from "../components/PageTitle";

function index() {
  const [queries, setQueries] = useState({});

  return (
    <>
      <PageTitle>Example: Postgis</PageTitle>
      <CustomInput
        onSubmit={(distance) =>
          setQueries({ ...queries, distance: Number(distance) || 0 })
        }
      />
      <MarkerList queries={queries} />
    </>
  );
}

export default index;
