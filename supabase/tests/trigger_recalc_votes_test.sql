BEGIN;
SELECT plan(3);


-- TEST 001
INSERT INTO markers (marker_id, title, longitude, latitude)
    VALUES  (101, 'MOCK1', -2.2368268, 53.4664686);

INSERT INTO auth.users (instance_id, id, email)
    VALUES ('00000000-0000-0000-0000-000000000000', '00000000-0000-0000-0000-000000000000', 'mock1@test.com');

INSERT INTO auth.users (instance_id, id, email)
    VALUES ('00000000-0000-0000-0000-000000000000', '11111111-1111-1111-1111-111111111111', 'mock2@test.com');

INSERT INTO votes (user_id, marker_id, value)
  VALUES ('00000000-0000-0000-0000-000000000000', 101, 5);

INSERT INTO votes (user_id, marker_id, value)
  VALUES ('11111111-1111-1111-1111-111111111111', 101, 5);

SELECT is(
    (SELECT votes FROM markers WHERE marker_id = 101),
    10,
    'should have 10 votes upon insertion'
);

-- TEST 002
UPDATE votes
  SET value = 3
  WHERE user_id = '00000000-0000-0000-0000-000000000000'
  AND marker_id = 101;

SELECT is(
    (SELECT votes FROM markers WHERE marker_id = 101),
    8,
    'should have 8 votes upon update'
);

-- TEST 002
DELETE FROM votes
  WHERE user_id = '00000000-0000-0000-0000-000000000000'
  AND marker_id = 101;

SELECT is(
    (SELECT votes FROM markers WHERE marker_id = 101),
    5,
    'should have 5 votes upon deletion'
);

SELECT * FROM finish();
ROLLBACK;