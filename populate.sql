SELECT create_list_for_user('first@gmail.com', NULL, '/private');
SELECT create_list_for_user('first@gmail.com', NULL, '/public');
SELECT create_list_for_user('second@gmail.com', NULL, '/private');
SELECT create_list_for_user('second@gmail.com', NULL, '/public');

INSERT INTO sharedfolders (user_email, owner_email, path, is_admin)
    VALUES ('second@gmail.com', 'first@gmail.com', '/public', TRUE );

INSERT INTO sharedfolders (user_email, owner_email, path, is_admin)
    VALUES ('first@gmail.com', 'second@gmail.com', '/public', FALSE);

INSERT INTO task (title, starred, predicted_time, predicted_duration, email, path, assigned_user_email)
    VALUES ('Delivering DB project', TRUE, current_timestamp + INTERVAL'5 hour', INTERVAL'20 minute', 'first@gmail.com', '/public', 'first@gmail.com');

INSERT INTO task (title, starred, predicted_time, predicted_duration, email, path)
    VALUES ('Checking DB project', TRUE, current_timestamp + INTERVAL'5 hour', INTERVAL'20 minute', 'first@gmail.com', '/public');

UPDATE task SET assigned_user_email = 'altostratous@gmail.com' WHERE title = 'Checking DB project';
UPDATE task SET assigned_user_email = 'second@gmail.com' WHERE title = 'Checking DB project';


INSERT INTO task (title, starred, predicted_time, predicted_duration, email, path, assigned_user_email)
    VALUES ('Good session', TRUE, current_timestamp + INTERVAL'8 hour', INTERVAL'20 minute', 'first@gmail.com', '/public', 'first@gmail.com');

INSERT INTO task (title, starred, predicted_time, real_time, predicted_duration, real_duration, email, path, assigned_user_email)
    VALUES ('Hard work', FALSE , current_timestamp - INTERVAL'8 hour', current_timestamp - INTERVAL'8 hour', INTERVAL'20 minute', INTERVAL'20 minute',
    'first@gmail.com', '/private', NULL );


INSERT INTO task (title, starred, predicted_time, real_time, predicted_duration, real_duration, email, path, assigned_user_email)
    VALUES ('First', FALSE , current_timestamp - INTERVAL'8 hour', current_timestamp - INTERVAL'9 hour', INTERVAL'20 minute', INTERVAL'20 minute',
    'first@gmail.com', '/private', NULL );


INSERT INTO task (title, starred, predicted_time, real_time, predicted_duration, real_duration, email, path, assigned_user_email)
    VALUES ('Hard bad work', FALSE , current_timestamp - INTERVAL'10 hour', current_timestamp - INTERVAL'8 hour', INTERVAL'20 minute', INTERVAL'20 minute',
    'first@gmail.com', '/private', NULL );


INSERT INTO task (title, starred, predicted_time, predicted_duration, email, path, assigned_user_email)
    VALUES ('Good session', TRUE, current_timestamp + INTERVAL'10 hour', INTERVAL'20 minute', 'first@gmail.com', '/public', 'second@gmail.com');


INSERT INTO task (title, starred, predicted_time, predicted_duration, email, path, assigned_user_email)
    VALUES ('Good session', TRUE , current_timestamp + INTERVAL'11 hour', INTERVAL'20 minute', 'first@gmail.com', '/public', 'first@gmail.com');


INSERT INTO task (title, starred, predicted_time, real_time, predicted_duration, real_duration, email, path, assigned_user_email)
    VALUES ('Hard bad work', FALSE , current_timestamp - INTERVAL'11 hour', current_timestamp - INTERVAL'8 hour', INTERVAL'20 minute', INTERVAL'20 minute',
    'first@gmail.com', '/private', NULL );

INSERT INTO task (title, starred, predicted_time, real_time, predicted_duration, real_duration, email, path, assigned_user_email)
    VALUES ('Hard bad work', FALSE , current_timestamp - INTERVAL'12 hour', current_timestamp - INTERVAL'8 hour', INTERVAL'20 minute', INTERVAL'100 minute',
    'first@gmail.com', '/private', NULL );
INSERT INTO task (title, starred, predicted_time, real_time, predicted_duration, real_duration, email, path, assigned_user_email)
    VALUES ('Hard bad work', FALSE , current_timestamp - INTERVAL'13 hour', current_timestamp - INTERVAL'8 hour', INTERVAL'20 minute', INTERVAL'100 minute',
    'first@gmail.com', '/private', NULL );

INSERT INTO task (title, starred, predicted_time, predicted_duration, email, path, assigned_user_email)
    VALUES ('Reminded one', TRUE, current_timestamp + INTERVAL'8 hour', INTERVAL'20 minute', 'first@gmail.com', '/public', 'first@gmail.com');

INSERT INTO reminder VALUES (current_timestamp + INTERVAL'6.4 hour', (SELECT id FROM task WHERE title = 'Reminded one'), TRUE , TRUE );

INSERT INTO resourceurls VALUES ((SELECT id FROM task WHERE title = 'Reminded one'), 'http://google.com');
INSERT INTO resourceurls VALUES ((SELECT id FROM task WHERE title = 'Reminded one'), 'http://yahoo.com');

INSERT INTO subtask VALUES ((SELECT id FROM task WHERE title = 'Reminded one'), 'first', FALSE );
INSERT INTO subtask VALUES ((SELECT id FROM task WHERE title = 'Reminded one'), 'second', FALSE );
INSERT INTO subtask VALUES ((SELECT id FROM task WHERE title = 'Reminded one'), 'third', FALSE );
INSERT INTO subtask VALUES ((SELECT id FROM task WHERE title = 'Reminded one'), 'fourth', FALSE );

INSERT INTO tasktags VALUES ('hard', (SELECT id FROM task WHERE title = 'Reminded one'));
INSERT INTO tasktags VALUES ('bad', (SELECT id FROM task WHERE title = 'Reminded one'));
INSERT INTO tasktags VALUES ('hell', (SELECT id FROM task WHERE title = 'Reminded one'));

INSERT INTO role VALUES ('first@gmail.com', 'admin');
INSERT INTO role VALUES ('altostratous@gmail.com', 'admin');

