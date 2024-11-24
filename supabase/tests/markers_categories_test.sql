BEGIN;
SELECT plan(4);

-- TEST 001
INSERT INTO markers (marker_id, title, longitude, latitude)
    VALUES  (101, 'MOCK1', -2.2368268, 53.4664686),
            (102, 'MOCK2', -2.2490792, 53.4851459)
;

INSERT INTO categories (category_id, name)
    VALUES (201, 'LOREM'), (202, 'IPSUM')
;

INSERT INTO markers_categories (marker_id, category_id)
    VALUES  (101, 201),
            (101, 202),
            (102, 201),
            (102, 202)
;

SELECT is(
    (SELECT count(*) FROM markers_categories),
    4::bigint,
    'should have 4 records'
);

-- TEST 002
PREPARE status_insert AS INSERT INTO markers_categories (marker_id, category_id) VALUES (101, 201);
SELECT throws_ok('status_insert', '23505');

-- TEST 003
DELETE FROM categories WHERE category_id = 201;

SELECT is(
    (SELECT count(*) FROM markers_categories WHERE category_id = 201),
    0::bigint,
    'should cascade on category deletion'
);

-- TEST 004
DELETE FROM markers WHERE marker_id = 101;

SELECT is(
    (SELECT count(*) FROM markers_categories WHERE marker_id = 101),
    0::bigint,
    'should cascade on markers deletion'
);

SELECT * FROM finish();
ROLLBACK;
