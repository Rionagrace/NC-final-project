CREATE TABLE "categories" (
  "category_id" serial PRIMARY KEY,
  "name" varchar UNIQUE NOT NULL
);