const { createClient } = require("@supabase/supabase-js");
const fs = require("node:fs");

const supabaseUrl = "https://xrtmxifobjdetrsscuxx.supabase.co";
const supbaseAnonKey =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhydG14aWZvYmpkZXRyc3NjdXh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyOTA1MTEsImV4cCI6MjA0Nzg2NjUxMX0.06jzlpWv3z2_itCQmMto4wUcTedCVRa3igBrafxzwy0";

const supabase = createClient(supabaseUrl, supbaseAnonKey);

fs.readFile(
  "/Users/georgiaoneill/northcoders/projects/NC-final-project/dev_components/MCR Historical Data.tsv",
  "utf-8",
  (err, data) => {
    const lines = data.split(/\n/);

    const destructure = lines
      .map((item) => {
        const line = item.split(/\t/);
        let latlong = line[3]?.replace(/\"/g, "").split(/\s|\,\s*/);
        latlong = latlong?.length === 2 ? latlong : undefined;

        if (!latlong?.[0] || !latlong?.[1]) return null;

        return JSON.stringify([
          line[0],
          line[2].replace(/["]+/g, ""),
          line[4].replace(/["]+/g, ""),
          Number(latlong[1]),
          Number(latlong[0]),
          line[7].replace(/["]+/g, ""),
        ])
          .replace(/\[/g, "(")
          .replace(/\]/g, ")")
          .replace(/\'/g, "''")
          .replace(/\"/g, "'");
      })
      .filter((item) => item)
      .join(",\n");

    console.log(destructure);

    // return fs.writeFile(
    //   "/Users/georgiaoneill/northcoders/projects/NC-final-project/dev_components/markers_values.txt",
    //   destructure,
    //   "utf-8"
    // );

    // supabase
    //   .from("markers")
    //   .insert(destructure)
    //   .then((res) => {
    //     console.log(res);
    //   });
  }
);
