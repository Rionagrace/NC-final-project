BEGIN;
-- TEST START
SELECT plan(5);
 
-- TEST 001
INSERT INTO markers (marker_id, title, longitude, latitude)
    VALUES  (101, 'MOCK1', -2.2368268, 53.4664686)
;

SELECT is(
    (SELECT count(*) FROM markers WHERE marker_id = 101),
    1::bigint,
    'should have one record with marker_id 101'
);

-- TEST 002
SELECT is(
    (SELECT location FROM markers WHERE marker_id = 101),
    '0101000020E6100000D987067305E501C032CE3A3EB5BB4A40',
    'should populate location on insertion with data from longitude, latitude'
);

-- TEST 003
DELETE FROM markers WHERE marker_id = 101;

SELECT is(
    (SELECT count(*) FROM markers WHERE marker_id = 101),
    0::bigint,
    'should not have record with title MOCK after deletion'
);

-- TEST 004
INSERT INTO auth.users (instance_id, id, email)
    VALUES ('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000000', 'mock@test.com');

INSERT INTO markers (marker_id, title, longitude, latitude, user_id)
    VALUES (102, 'MOCK2', -2.2368268, 53.4664686, '00000000-0000-0000-0000-000000000000');

SELECT is(
    (SELECT count(*) FROM markers WHERE user_id = '00000000-0000-0000-0000-000000000000'),
    1::bigint,
    'should have record with valid user_id reference after insertion'
);

-- TEST 005
DELETE FROM auth.users WHERE id = '00000000-0000-0000-0000-000000000000';

SELECT is(
    (SELECT user_id FROM markers WHERE marker_id = 102),
    NULL
    ,
    'should nullify user_id on profile deletion'
);

--  TEST END
SELECT * FROM finish();
ROLLBACK;
