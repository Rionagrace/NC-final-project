CREATE TABLE "users" (
  "user_id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "username" varchar UNIQUE NOT NULL
);

-- SEED -------------------------------------------------------------
INSERT INTO users (username)
  VALUES ('hannah'), ('vikki'), ('georgia'), ('riona'), ('david');
