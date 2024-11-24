BEGIN;
-- TEST START
SELECT plan(3);

-- TEST 001
INSERT INTO auth.users (instance_id, id, email)
    VALUES ('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000000', 'mock@test.com');

INSERT INTO markers (marker_id, title, longitude, latitude)
    VALUES  (101, 'MOCK1', -2.2368268, 53.4664686),
            (102, 'MOCK2', -2.2490792, 53.4851459)
;

INSERT INTO planners_markers (planner_id, marker_id)
    VALUES  ((SELECT planner_id FROM planners WHERE user_id = '00000000-0000-0000-0000-000000000000' AND title = 'default'), 101),
            ((SELECT planner_id FROM planners WHERE user_id = '00000000-0000-0000-0000-000000000000' AND title = 'default'), 102);

SELECT is(
    (SELECT count(*) FROM planners_markers WHERE planner_id = (SELECT planner_id FROM planners WHERE user_id = '00000000-0000-0000-0000-000000000000' AND title = 'default')),
    2::bigint,
    'should have two records with valid planner_id after insertion'
);

-- TEST 002
DELETE FROM markers WHERE marker_id = 101;

SELECT is(
    (SELECT count(*) FROM planners_markers WHERE marker_id = 101),
    0::bigint,
    'should cascade on marker deletion'
);

-- TEST 003
DELETE FROM auth.users WHERE id = '00000000-0000-0000-0000-000000000000';

SELECT is(
    (SELECT count(*) FROM planners_markers),
    0::bigint,
    'should cascade on profile deletion'
);

-- TEST END
SELECT * FROM finish();
ROLLBACK;
