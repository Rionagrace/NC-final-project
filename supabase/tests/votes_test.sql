BEGIN;
-- TEST START
SELECT plan(4);

-- TEST 001
INSERT INTO auth.users (instance_id, id, email)
VALUES ('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000000', 'mock@test.com');

INSERT INTO markers (marker_id, title, longitude, latitude)
    VALUES  (101, 'MOCK1', -2.2368268, 53.4664686),
            (102, 'MOCK2', -2.2490792, 53.4851459)
;

INSERT INTO votes (user_id, marker_id, value)
VALUES  ('00000000-0000-0000-0000-000000000000', 101, 3),
        ('00000000-0000-0000-0000-000000000000', 102, 5);

SELECT is(
    (SELECT count(*) FROM votes WHERE user_id = '00000000-0000-0000-0000-000000000000'),
    2::bigint,
    'should have two records with valid user_id after insertion'
);

-- TEST 002: should fail on attempt to insert duplicated maker_id and user_id combination
PREPARE status_insert AS INSERT INTO votes (user_id, marker_id) VALUES ('00000000-0000-0000-0000-000000000000', 101);

SELECT throws_ok('status_insert', '23505');

-- TEST 003
DELETE FROM markers WHERE marker_id = 101;

SELECT is(
    (SELECT count(*) FROM votes WHERE marker_id = 101),
    0::bigint,
    'should cascade on marker deletion'
);

-- TEST 004
DELETE FROM auth.users WHERE id = '00000000-0000-0000-0000-000000000000';

SELECT is(
    (SELECT count(*) FROM votes WHERE user_id = '00000000-0000-0000-0000-000000000000'),
    0::bigint,
    'should cascade on profile deletion'
);

-- TEST END
SELECT * FROM finish();
ROLLBACK;
