BEGIN;
SELECT plan(4);

-- TEST 001
INSERT INTO markers (marker_id, title, longitude, latitude)
    VALUES  (101, 'MOCK1', -2.2368268, 53.4664686),
            (102, 'MOCK2', -2.2490792, 53.4851459)
;

INSERT INTO tours (tour_id, title)
    VALUES (201, 'LOREM'), (202, 'IPSUM')
;

INSERT INTO tours_markers (tour_id, marker_id)
    VALUES  (201, 101),
            (202, 101),
            (201, 102),
            (202, 102)
;

SELECT is(
    (SELECT count(*) FROM tours_markers),
    4::bigint,
    'should have 4 records'
);

-- TEST 002
PREPARE status_insert AS INSERT INTO tours_markers (tour_id, marker_id) VALUES (201, 101);
SELECT throws_ok('status_insert', '23505');

-- TEST 003
DELETE FROM tours WHERE tour_id = 201;

SELECT is(
    (SELECT count(*) FROM tours_markers WHERE tour_id = 201),
    0::bigint,
    'should cascade on tour deletion'
);

-- TEST 004
DELETE FROM markers WHERE marker_id = 101;

SELECT is(
    (SELECT count(*) FROM tours_markers WHERE marker_id = 101),
    0::bigint,
    'should cascade on markers deletion'
);

SELECT * FROM finish();
ROLLBACK;
