BEGIN;
SELECT plan(2);

-- TEST 001
INSERT INTO markers (title, longitude, latitude)
  VALUES    ('Manchester Cathedral', -2.2490792, 53.4851459),
            ('Manchester Museum', -2.2368268, 53.4664686),
            ('Emmeline Pankhurst Statue',-2.243056 , 53.477778),
            ('Mamucium Roman Fort Reconstruction', -2.2588591, 53.4754896),
            ('Alan Turing Memorial', -2.2407774, 53.4767288)
;

SELECT is (
    (SELECT title FROM nearby_markers(-2.2490792, 53.4851459, 0)),
    'Manchester Cathedral',
    'should have one record with title "Manchester Cathedral"'
);

-- TEST 002
SELECT is(
    ARRAY(SELECT title FROM nearby_markers(-2.2490792, 53.4851459, 1100)),
    ARRAY[ 'Manchester Cathedral', 'Emmeline Pankhurst Statue', 'Alan Turing Memorial' ]::varchar[],
    'should have 3 records in exact order'
);

SELECT * FROM finish();
ROLLBACK;