-- CREATE TABLE
DROP TABLE IF EXISTS planners_markers CASCADE;
CREATE TABLE planners_markers (
    planner_id SERIAL NOT NULL REFERENCES planners ON DELETE CASCADE,
    marker_id SERIAL NOT NULL REFERENCES markers ON DELETE CASCADE,
    sequence INT,
    PRIMARY KEY (planner_id, marker_id)
);