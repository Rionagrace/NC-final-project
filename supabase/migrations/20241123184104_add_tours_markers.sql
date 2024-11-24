DROP TABLE IF EXISTS tours_markers CASCADE;
CREATE TABLE tours_markers (
  tour_id SERIAL NOT NULL REFERENCES tours ON DELETE CASCADE,
  marker_id SERIAL NOT NULL REFERENCES markers ON DELETE CASCADE,
  sequence INT,
  PRIMARY KEY (tour_id, marker_id)
);