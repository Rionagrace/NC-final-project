DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
  category_id SERIAL PRIMARY KEY,
  name VARCHAR UNIQUE NOT NULL,
  grouping VARCHAR,
  positioning INT
);

