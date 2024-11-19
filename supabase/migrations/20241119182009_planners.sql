CREATE TABLE "planners" (
  "planner_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "user_id" uuid
);
ALTER TABLE "planners" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

-- JOINING TABLE ----------------------------------------------------
CREATE TABLE "planners_markers" (
  "planner_id" serial,
  "marker_id" serial,
  "sequence" int
);
ALTER TABLE "planners_markers" ADD FOREIGN KEY ("planner_id") REFERENCES "planners" ("planner_id");
ALTER TABLE "planners_markers" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");