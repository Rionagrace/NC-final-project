CREATE TABLE "tours" (
  "tour_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "description" varchar(255)
);

-- JOINING TABLE ----------------------------------------------------
CREATE TABLE "tours_markers" (
  "tour_id" serial,
  "marker_id" serial,
  "sequence" int
);
ALTER TABLE "tours_markers" ADD FOREIGN KEY ("tour_id") REFERENCES "tours" ("tour_id");
ALTER TABLE "tours_markers" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");
