const { createClient } = require("@supabase/supabase-js");
const fs = require("node:fs");

const supabaseUrl = "https://xrtmxifobjdetrsscuxx.supabase.co";
const supbaseAnonKey =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhydG14aWZvYmpkZXRyc3NjdXh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyOTA1MTEsImV4cCI6MjA0Nzg2NjUxMX0.06jzlpWv3z2_itCQmMto4wUcTedCVRa3igBrafxzwy0";

const supabase = createClient(supabaseUrl, supbaseAnonKey);

const categories = [
  [1, "Building", "Type", 1],
  [2, "Museum", "Type", 2],
  [3, "Gallery", "Type", 3],
  [4, "Library", "Type", 4],
  [5, "Theatre", "Type", 5],
  [6, "Church", "Type", 6],
  [7, "Station", "Type", 7],
  [8, "Stadium", "Type", 8],
  [9, "Observatory", "Type", 9],
  [10, "Archaeological Site", "Type", 10],
  [11, "Park", "Type", 11],
  [12, "Bridge", "Type", 12],
  [13, "Memorial", "Type", 13],
  [14, "Statue", "Type", 14],
  [15, "Famous People", "Type", 15],
  [16, "Ice Age", "Era", 1],
  [17, "Iron Age", "Era", 2],
  [18, "Roman", "Era", 3],
  [19, "Anglo Saxon", "Era", 4],
  [20, "Medieval", "Era", 5],
  [21, "Tudor", "Era", 6],
  [22, "Stuart", "Era", 7],
  [23, "Georgian", "Era", 8],
  [24, "Industrial Revolution", "Era", 9],
  [25, "Victorian", "Era", 10],
  [26, "Edwardian", "Era", 11],
  [27, "World Wars", "Era", 12],
  [28, "20th Century", "Era", 13],
  [29, "21st Century", "Era", 14],
];

fs.readFile(
  "/Users/georgiaoneill/northcoders/projects/NC-final-project/dev_components/MCR Historical Data.tsv",
  "utf-8",
  (err, data) => {
    const lines = data.split(/\n/);

    const markersCategoriesJoining = [];

    const destructure = lines
      .map((item, index) => {
        const markerId = index + 1;

        const line = item.split(/\t/);
        let latlong = line[3]?.replace(/\"/g, "").split(/\s|\,\s*/);
        latlong = latlong?.length === 2 ? latlong : undefined;

        if (!latlong?.[0] || !latlong?.[1]) return null;

        line[1].split(",").forEach((item) => {
          const cleanName = item.replace(/["]+/g, "").trim();

          const catId = categories.find((item) => {
            return item[1].toLowerCase() === cleanName.toLowerCase();
          });

          markersCategoriesJoining.push(
            JSON.stringify([markerId, catId?.[0]])
              .replace(/\[/g, "(")
              .replace(/\]/g, ")")
              .replace(/\'/g, "''")
              .replace(/\"/g, "'")
          );
        });

        return JSON.stringify([
          markerId,
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

    fs.writeFile(
      "/Users/georgiaoneill/northcoders/projects/NC-final-project/dev_components/markersValues.txt",
      destructure,
      "utf-8",
      () => {}
    );

    fs.writeFile(
      "/Users/georgiaoneill/northcoders/projects/NC-final-project/dev_components/markersCategoriesValues.txt",
      markersCategoriesJoining.join(",\n"),
      "utf-8",
      () => {}
    );

    fs.writeFile(
      "/Users/georgiaoneill/northcoders/projects/NC-final-project/dev_components/categoriesValues.txt",
      categories
        .map((item) =>
          JSON.stringify(item)
            .replace(/\[/g, "(")
            .replace(/\]/g, ")")
            .replace(/\'/g, "''")
            .replace(/\"/g, "'")
        )
        .join(",\n"),
      "utf-8",
      () => {}
    );

    // supabase
    //   .from("markers")
    //   .insert(destructure)
    //   .then((res) => {
    //     console.log(res);
    //   });
  }
);
