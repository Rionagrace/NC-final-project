BEGIN;
-- TEST START
SELECT plan(2);

-- TEST 001
INSERT INTO auth.users (instance_id, id, email)
    VALUES ('11111111-1111-1111-1111-111111111111', '00000000-0000-0000-0000-000000000000', 'mock@test.com');

SELECT is(
    (SELECT count(*) FROM profiles WHERE user_id = '00000000-0000-0000-0000-000000000000'),
    1::bigint,
    'should have valid user id after insertion'
);

-- TEST 002
DELETE FROM auth.users WHERE id = '00000000-0000-0000-0000-000000000000';

SELECT is(
    (SELECT count(*) FROM profiles WHERE user_id = '00000000-0000-0000-0000-000000000000'),
    0::bigint,
    'should cascade on auth.user deletion'
);

-- TEST END
SELECT * FROM finish();
ROLLBACK;
