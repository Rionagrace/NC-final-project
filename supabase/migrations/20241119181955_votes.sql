CREATE TABLE "votes" (
  "user_id" uuid,
  "marker_id" serial,
  "value" int
);
CREATE UNIQUE INDEX ON "votes" ("user_id", "marker_id");
ALTER TABLE "votes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");
ALTER TABLE "votes" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");
