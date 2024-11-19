do $$ declare
    r record;
begin
    for r in (select tablename from pg_tables where schemaname = 'public') loop
        execute 'drop table if exists ' || quote_ident(r.tablename) || ' cascade';
    end loop;
end $$;

-- TABLE: USERS -----------------------------------------------------
CREATE TABLE "users" (
  "user_id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "username" varchar UNIQUE NOT NULL
);

-- TABLE: CATEGORIES ------------------------------------------------
CREATE TABLE "categories" (
  "category_id" serial PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);

-- TABLE: MARKERS ---------------------------------------------------
CREATE TABLE "markers" (
  "marker_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "description" varchar(255),
  "address" varchar,
  "location" varchar,
  "longitude" float,
  "latitude" float,
  "user_id" uuid
);
ALTER TABLE "markers" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

-- TABLE: MARKERS CATEGORIES ----------------------------------------
CREATE TABLE "markers_categories" (
  "category_id" serial,
  "marker_id" serial,
  "order" int
);
ALTER TABLE "markers_categories" ADD FOREIGN KEY ("category_id") REFERENCES "categories" ("category_id");
ALTER TABLE "markers_categories" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");

-- TABLE: VOTES -----------------------------------------------------
CREATE TABLE "votes" (
  "user_id" uuid,
  "marker_id" serial,
  "value" int
);
CREATE UNIQUE INDEX ON "votes" ("user_id", "marker_id");
ALTER TABLE "votes" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");
ALTER TABLE "votes" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");

-- TABLE: TOURS -----------------------------------------------------
CREATE TABLE "tours" (
  "tour_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "description" varchar(255)
);

-- TABLE: TOURS MARKERS ---------------------------------------------
CREATE TABLE "tours_markers" (
  "tour_id" serial,
  "marker_id" serial,
  "sequence" int
);
ALTER TABLE "tours_markers" ADD FOREIGN KEY ("tour_id") REFERENCES "tours" ("tour_id");
ALTER TABLE "tours_markers" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");

-- TABLE: PLANNERS --------------------------------------------------
CREATE TABLE "planners" (
  "planner_id" serial PRIMARY KEY,
  "title" varchar NOT NULL,
  "user_id" uuid
);
ALTER TABLE "planners" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

-- TABLE: PLANNERS MARKERS ------------------------------------------
CREATE TABLE "planners_markers" (
  "planner_id" serial,
  "marker_id" serial,
  "sequence" int
);
ALTER TABLE "planners_markers" ADD FOREIGN KEY ("planner_id") REFERENCES "planners" ("planner_id");
ALTER TABLE "planners_markers" ADD FOREIGN KEY ("marker_id") REFERENCES "markers" ("marker_id");


-- SEEDING: USERS ---------------------------------------------------
INSERT INTO users (username)
  VALUES ('hannah'), ('vikki'), ('georgia'), ('riona'), ('david');

INSERT INTO markers (title, latitude, longitude)
  VALUES  ('Manchester Museum', 53.4664686, -2.2368268 ),
          ('Emmeline Pankhurst Statue', 53.477778, -2.243056 ),
          ('Mamucium Roman Fort Reconstruction', 53.4754896, -2.2588591 ),
          ('Manchester Cathedral', 53.4851459, -2.2490792 ),
          ('Alan Turing Memorial', 53.4767288, -2.2407774 );