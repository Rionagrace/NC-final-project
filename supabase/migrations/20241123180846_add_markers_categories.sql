DROP TABLE IF EXISTS markers_categories;
CREATE TABLE markers_categories (
  category_id SERIAL REFERENCES categories ON DELETE CASCADE,
  marker_id SERIAL REFERENCES markers ON DELETE CASCADE,
  PRIMARY KEY (category_id, marker_id)
);