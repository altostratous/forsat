PREPARE registration(email_domain, nickname_domain, password_domain, pic_url_domain) AS
  INSERT INTO "User" VALUES ($1, $2, $3, $4, current_timestamp, current_timestamp);
-- Tests --
EXECUTE registration('altostratous@gmail.com', 'alto', '1979', 'www.google.com');



PREPARE edit_personal_info(email_domain, email_domain, nickname_domain, password_domain, pic_url_domain) AS
  UPDATE "User" SET email = $2, nickname = $3, password = $4, pic_url = $5, last_activity = current_timestamp
    WHERE email = $1;
-- Tests --
EXECUTE edit_personal_info('altostratous@gmail.com','aliasgarikh@yahoo.com','alto', '1997', 'www.yahoo.com');



PREPARE remove_user(email_domain) AS
  DELETE FROM "User" WHERE email = $1;



PREPARE create_folder_for_user(email_domain, path_domain, path_domain) AS
  INSERT INTO folder VALUES ($2, $1, $3);
-- Tests --
EXECUTE create_folder_for_user('aliasgarikh@yahoo.com', '/Public', NULL );



PREPARE move_folder_for_user(email_domain, path_domain, path_domain, path_domain) AS
  UPDATE folder SET path = $3, child_of_path = $4 WHERE email = $1 AND path = $2;
-- Tests --
EXECUTE move_folder_for_user('aliasgarikh@yahoo.com', '/Semester4', '/University/Semester4', '/University');
EXECUTE create_folder_for_user('aliasgarikh@yahoo.com', '/Semester4', '/University');
EXECUTE create_folder_for_user('aliasgarikh@yahoo.com', '/Work', NULL);
EXECUTE move_folder_for_user('aliasgarikh@yahoo.com', '/Shora', '/University/Shora', '/University');



PREPARE delete_folder_for_user(email_domain, path_domain, path_domain) AS
  DELETE FROM folder WHERE email = $1 AND path = $2 AND child_of_path = $3;



CREATE FUNCTION create_list_for_user(email email_domain, parent_path path_domain, path path_domain) RETURNS VOID AS $create_list_for_user$
BEGIN
  INSERT INTO folder VALUES (path, email, parent_path);
  INSERT INTO list VALUES (path, email);
END;
$create_list_for_user$ LANGUAGE plpgsql;



PREPARE create_task_in_list(email_domain, path_domain, title_domain, boolean_domain,
  text_domain, time_setting_domain, time_setting_domain, duration_domain, duration_domain,
  time_setting_domain, recurrence_id_domain, email_domain) AS
  INSERT INTO task (title, starred, description, predicted_time, real_time, predicted_duration,
                    real_duration, deadline, email, path, recurrence_of_id, assigned_user_email)
  VALUES ($3, $4, $5, $6, $7, $8,
          $9, $10, $1, $2, $11, $12);
-- Tests --
EXECUTE create_task_in_list('aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Project',
                            TRUE, 'Course Project', '2017-07-09 20:29:22.743437',
                            '2017-07-09 22:29:22.743437', '2:00:00', '3:00:00',
                            '2017-07-10 22:29:22.743437', NULL, 'aliasgarikh@yahoo.com');



PREPARE edit_task_in_list(id_domain, email_domain, path_domain, title_domain, boolean_domain,
  text_domain, time_setting_domain, time_setting_domain, duration_domain, duration_domain,
  time_setting_domain, recurrence_id_domain, email_domain) AS
  UPDATE task SET email = $2, path = $3, title = $4, starred = $5, description = $6,
                  predicted_time = $7, real_time = $8, predicted_duration = $9,
                  real_duration = $10, deadline = $11, recurrence_of_id = $12, assigned_user_email = $13
  WHERE id = $1;
-- Tests --
EXECUTE edit_task_in_list(1, 'aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Assignment3',
                            TRUE, 'Third Assignment', '2017-07-09 20:29:22.743437',
                            '2017-07-09 22:29:22.743437', '2:00:00', '3:00:00',
                            '2017-07-10 22:29:22.743437', NULL);



PREPARE delete_task_in_list(id_domain) AS
  DELETE FROM task WHERE id = $1;



PREPARE create_subtask_for_task(id_domain, title_domain) AS
  INSERT INTO subtask (id, title) VALUES ($1, $2);
-- Tests --
EXECUTE create_subtask_for_task(1, 'Reading slides');



PREPARE edit_subtask_for_task(id_domain, title_domain, title_domain, boolean_domain) AS
  UPDATE subtask SET title = $3, done = $4 WHERE id = $1 AND title = $2;
-- Tests --
EXECUTE edit_subtask_for_task(1, 'Reading slides', 'Reading handouts', TRUE);



PREPARE delete_subtask_for_task(id_domain, title_domain) AS
  DELETE FROM subtask WHERE id = $1 AND title = $2;



PREPARE create_reminder_for_task(id_domain, time_setting_domain, boolean_domain, boolean_domain) AS
  INSERT INTO reminder VALUES ($2, $1, $3, $4);
-- Tests --
EXECUTE create_reminder_for_task(1, '2017-07-11 20:30:0.0', TRUE, TRUE);



PREPARE edit_reminder_for_task(id_domain, time_setting_domain, time_setting_domain, boolean_domain, boolean_domain) AS
  UPDATE reminder SET time = $3, send_email = $4, notify = $5 WHERE id = $1 AND time = $2;
-- Tests --
EXECUTE edit_reminder_for_task(1, '2017-07-11 20:30:0.0', '2017-07-12 20:30:0.0', TRUE, FALSE);



PREPARE delete_reminder_for_task(id_domain, time_setting_domain) AS
  DELETE FROM reminder WHERE id = $1 AND time = $2;



PREPARE share_list_with_user(email_domain, email_domain, path_domain, boolean_domain) AS
  INSERT INTO sharedfolders VALUES($1, $2, $3, $4);
-- Tests --
EXECUTE registration('mohammad.alamy@gmail.com', 'MHA', '1968', 'www.avatar');
EXECUTE share_list_with_user('mohammad.alamy@gmail.com', 'aliasgarikh@yahoo.com', '/University/Semester4/DB', TRUE);


PREPARE edit_shared_list_with_user(email_domain, email_domain, path_domain, email_domain, path_domain, boolean_domain) AS
  UPDATE sharedfolders SET user_email = $4, path = $5, is_admin = $6 WHERE user_email = $1 AND owner_email = $2 AND path = $3;
-- Tests --
EXECUTE edit_shared_list_with_user('mohammad.alamy@gmail.com', 'aliasgarikh@yahoo.com', '/University/Semester4/DB',
                                    'mohammad.alamy@gmail.com', '/University/Semester4/DB', FALSE );



PREPARE remove_user_from_list(email_domain, email_domain, path_domain) AS
  DELETE FROM sharedfolders WHERE user_email = $1 AND owner_email = $2 AND path = $3;



PREPARE assign_task_to_user(id_domain, email_domain) AS
  UPDATE task SET assigned_user_email = $2 WHERE id = $1;
-- Tests --
EXECUTE create_task_in_list('aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Project',
                            TRUE, 'Course Project', '2017-07-09 20:29:22.743437',
                            '2017-07-09 22:29:22.743437', '2:00:00', '3:00:00',
                            '2017-07-10 22:29:22.743437', NULL, 'aliasgarikh@yahoo.com');
EXECUTE assign_task_to_user(2,'mohammad.alamy@gmail.com');



PREPARE begin_task(id_domain) AS
  UPDATE task SET real_time = current_timestamp WHERE id = $1;



PREPARE end_task(id_domain) AS
  UPDATE task SET real_duration = current_timestamp - real_time WHERE id = $1;



-- Tests --
EXECUTE create_task_in_list('aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Assignment2',
                            FALSE, 'Second assignment', '2017-07-09 20:29:22.743437',
                            NULL , '2:00:00', NULL, '2017-07-10 22:29:22.743437', NULL, 'mohammad.alamy@gmail.com');
EXECUTE begin_task(3);
EXECUTE end_task(3);



PREPARE write_comment_under_task(id_domain, text_domain, email_domain, time_setting_domain, email_domain) AS
  INSERT INTO comment VALUES($2, current_timestamp, $3, $1, $4, $5);
-- Tests --
EXECUTE write_comment_under_task(3, 'Covfefe', 'mohammad.alamy@gmail.com', NULL, NULL);



PREPARE edit_comment_under_task(id_domain, time_setting_domain, text_domain, email_domain, time_setting_domain, email_domain) AS
  UPDATE comment SET text = $3, time = current_timestamp, email = $4, replied_to_time = $5, replied_to_email = $6
    WHERE id = $1 AND time = $2;
-- Tests --
EXECUTE edit_comment_under_task(3,'2017-07-09 22:58:03.238175', '???', 'mohammad.alamy@gmail.com', NULL, NULL );



PREPARE delete_comment_under_task(id_domain, time_setting_domain) AS
  DELETE FROM comment WHERE id = $1 AND time = $2;



PREPARE add_resource_for_task(id_domain, resource_url_domain) AS
  INSERT INTO resourceurls VALUES ($1, $2);
PREPARE edit_resource_for_task(id_domain, resource_url_domain, id_domain, resource_url_domain) AS
  UPDATE resourceurls SET id = $3, resource_url = $4 WHERE id = $1 AND resource_url = $2;
PREPARE delete_resources_for_task(id_domain, resource_url_domain) AS
  DELETE FROM resourceurls WHERE id = $1 AND resource_url = $2;



PREPARE add_tag_for_task(id_domain, label_domain) AS
  INSERT INTO tasktags VALUES ($2, $1);
PREPARE edit_tag_for_task(id_domain, label_domain, id_domain, label_domain) AS
  UPDATE tasktags SET id = $3, tag = $4 WHERE id = $1 AND tag = $2;
PREPARE delete_tag_for_task(id_domain, label_domain) AS
  DELETE FROM tasktags WHERE id = $1 AND tag = $2;



PREPARE get_tasks_of_a_folder(email_domain, path_domain) AS
  SELECT * FROM task
    WHERE email = $1 AND path LIKE $2 || '%';
-- Tests --
EXECUTE get_tasks_of_a_folder('aliasgarikh@yahoo.com', '/University');



PREPARE get_tasks_of_a_list(email_domain, path_domain) AS
  SELECT * FROM task
    WHERE email = $1 AND path = $2;



PREPARE get_tasks_with_tag(email_domain, label_domain) AS
  SELECT * FROM task AS t
    WHERE exists(SELECT * FROM tasktags AS tt
                  WHERE tt.id = t.id AND tag = $2)
    AND (email = $1 OR exists(SELECT * FROM sharedfolders as sf
          WHERE user_email = $1 AND sf.owner_email = t.email AND sf.path = t.path));



PREPARE get_recent_comments_of_a_task(id_domain) AS
  SELECT * FROM comment
    WHERE id = $1 AND time BETWEEN current_timestamp - INTERVAL '7 days' AND current_timestamp;
-- Tests --
EXECUTE write_comment_under_task(2, '!!!', 'aliasgarikh@yahoo.com', NULL, NULL);
EXECUTE get_recent_comments_of_a_task(2);



PREPARE get_older_comments_of_a_task(id_domain) AS
  SELECT * FROM comment
    WHERE id = $1 AND time < current_timestamp - INTERVAL '7 days';
-- Tests --
EXECUTE get_older_comments_of_a_task(2);



PREPARE get_recent_comments_of_other_users(email_domain) AS
  SELECT * FROM comment
    WHERE id IN (
      SELECT id FROM task AS t
        WHERE exists(
            SELECT * FROM sharedfolders AS sf
              WHERE sf.path = t.path AND (sf.user_email = $1 OR sf.owner_email = $1)
        )
    ) ORDER BY time DESC LIMIT 20;



PREPARE get_activity_of_shared_lists(email_domain) AS
  SELECT time, message FROM folderactivities
    WHERE path IN (
      SELECT path FROM sharedfolders
        WHERE user_email = $1 OR owner_email = $1
    );



PREPARE get_activity_of_personal_lists(email_domain) AS
  SELECT time, message FROM folderactivities
    WHERE email = $1;



PREPARE get_tasks_of_a_day(email_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '1 days';
-- Tests --
EXECUTE get_tasks_of_a_day('mohammad.alamy@gmail.com', '2017-07-09');

PREPARE get_starred_tasks_of_a_day(email_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '1 days'
          AND starred = TRUE;

PREPARE get_tasks_of_a_day_in_a_list(email_domain, time_setting_domain, email_domain, path_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '1 days'
          AND email = $3 AND path = $4;



PREPARE get_tasks_of_a_week(email_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '7 days';

PREPARE get_starred_tasks_of_a_week(email_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '7 days'
          AND starred = TRUE;

PREPARE get_tasks_of_a_week_in_a_list(email_domain, time_setting_domain, email_domain, path_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '7 days'
          AND email = $3 AND path = $4;



PREPARE get_tasks_of_a_month(email_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '30 days';

PREPARE get_starred_tasks_of_a_month(email_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '30 days'
          AND starred = TRUE;

PREPARE get_tasks_of_a_month_in_a_list(email_domain, time_setting_domain, email_domain, path_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $2 + INTERVAL '30 days'
          AND email = $3 AND path = $4;



PREPARE get_tasks_of_an_interval(email_domain, time_setting_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $3;

PREPARE get_starred_tasks_of_an_interval(email_domain, time_setting_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND predicted_time BETWEEN $2 AND $3 AND starred = TRUE;



PREPARE sort_tasks_of_a_list_by_deadline(email_domain, path_domain) AS
  SELECT * FROM task
    WHERE email = $1 AND path = $2
      ORDER BY deadline DESC;

PREPARE sort_tasks_of_a_list_by_predicted_time(email_domain, path_domain) AS
  SELECT * FROM task
    WHERE email = $1 AND path = $2
      ORDER BY predicted_time DESC;

PREPARE sort_tasks_of_a_list_by_predicted_duration(email_domain, path_domain) AS
  SELECT * FROM task
    WHERE email = $1 AND path = $2
      ORDER BY predicted_duration DESC;

PREPARE sort_tasks_of_a_list_by_starred(email_domain, path_domain) AS
  SELECT * FROM task
    WHERE email = $1 AND path = $2
      ORDER BY starred DESC;



PREPARE get_tasks_with_deadline_before(email_domain, time_setting_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND deadline < $2;

PREPARE get_tasks_with_deadline_before_in_a_list(email_domain, time_setting_domain, email_domain, path_domain) AS
  SELECT * FROM task
    WHERE assigned_user_email = $1 AND deadline < $2 AND email = $3 AND path = $4;



PREPARE get_total_duration_for_a_folder_in_an_interval(email_domain, path_domain, time_setting_domain, time_setting_domain) AS
  SELECT sum(predicted_duration) FROM task
    WHERE email = $1 AND path LIKE $2 || '%' AND predicted_time BETWEEN $3 AND $4;

PREPARE get_total_duration_for_a_list_in_an_interval(email_domain, path_domain, time_setting_domain, time_setting_domain) AS
  SELECT sum(predicted_duration) FROM task
    WHERE email = $1 AND path = $2 AND predicted_time BETWEEN $3 AND $4;

PREPARE get_total_duration_for_a_tag_in_an_interval(email_domain, label_domain, time_setting_domain, time_setting_domain) AS
  SELECT sum(predicted_duration) FROM task as t
    WHERE predicted_time BETWEEN $3 AND $4 AND exists(
        SELECT * FROM tasktags as tt
          WHERE tt.id = t.id AND tag = $2
    ) AND (email = $1 OR exists (
        SELECT * FROM sharedfolders as sf
          WHERE user_email = $1 AND sf.owner_email = t.email AND sf.path = t.path
    ));



PREPARE get_total_real_duration_for_a_folder_in_an_interval(email_domain, path_domain, time_setting_domain, time_setting_domain) AS
  SELECT sum(real_duration) FROM task
    WHERE email = $1 AND path LIKE $2 || '%' AND predicted_time BETWEEN $3 AND $4;


PREPARE get_total_duration_for_a_list_in_an_interval(email_domain, path_domain, time_setting_domain, time_setting_domain) AS
  SELECT sum(real_duration) FROM task
    WHERE email = $1 AND path = $2 AND predicted_time BETWEEN $3 AND $4;

PREPARE get_total_duration_for_a_tag_in_an_interval(email_domain, label_domain, time_setting_domain, time_setting_domain) AS
  SELECT sum(real_duration) FROM task as t
    WHERE predicted_time BETWEEN $3 AND $4 AND exists(
        SELECT * FROM tasktags as tt
          WHERE tt.id = t.id AND tag = $2
    ) AND (email = $1 OR exists (
        SELECT * FROM sharedfolders as sf
          WHERE user_email = $1 AND sf.owner_email = t.email AND sf.path = t.path
    ));



PREPARE get_longest_task_in_future_shorter_than(email_domain, duration_domain) AS
  SELECT id FROM task as t WHERE
      email = $1 OR exists(
        SELECT * FROM sharedfolders as sf
          WHERE user_email = $1 AND owner_email = t.email AND sf.path = t.path
      ) AND predicted_duration < $2 ORDER BY predicted_duration DESC LIMIT 1
        AND predicted_time BETWEEN current_timestamp AND current_timestamp + INTERVAL '7 days';



PREPARE get_total_real_duration_for_user(email_domain, time_setting_domain, time_setting_domain) AS
  SELECT sum(real_duration) FROM task AS t
    WHERE real_duration IS NOT NULL AND (email = $1 OR exists (
        SELECT * FROM sharedfolders as sf
          WHERE user_email = $1 AND sf.owner_email = t.email AND sf.path = t.path
    )) AND predicted_time BETWEEN $2 AND $3;

DEALLOCATE PREPARE get_user_free_time_in_interval;

PREPARE get_user_free_time_in_interval(email_domain, time_setting_domain, time_setting_domain) AS
  SELECT extract(HOUR FROM ($3 - $2)) - extract(HOUR FROM sum(predicted_duration)) * (
    SELECT extract(HOUR FROM sum(real_duration))/extract(HOUR FROM sum(predicted_duration)) FROM task
      WHERE real_duration IS NOT NULL AND predicted_duration IS NOT NULL AND assigned_user_email = $1
  ) FROM task WHERE predicted_time BETWEEN $2 AND $3 AND assigned_user_email = $1;

EXECUTE get_user_free_time_in_interval('mohammad.alamy@gmail.com', current_timestamp, current_timestamp + '0 years 0 mons 0 days 5 hours 0 mins 0.00 secs');



PREPARE get_functionality_of_a_task(id_domain) AS
  SELECT (extract(SECOND FROM real_duration) + 60*(extract(MINUTE FROM real_duration)) +
          3600*(extract(HOUR FROM real_duration)) + 43200*(extract(DAY FROM real_duration)))
          /
         (extract(SECOND FROM predicted_duration) + 60*(extract(MINUTE FROM predicted_duration)) +
          3600*(extract(HOUR FROM predicted_duration)) + 43200*(extract(DAY FROM predicted_duration)))
  FROM task WHERE id = $1;
-- Tests --
EXECUTE get_functionality_of_a_task(4);

DEALLOCATE PREPARE get_functionality_of_tasks_in_a_duration;

PREPARE get_functionality_of_tasks_in_a_duration(email_domain, time_setting_domain, time_setting_domain) AS
  SELECT (extract(SECOND FROM sum(real_duration)) + 60*(extract(MINUTE FROM sum(real_duration))) +
          3600*(extract(HOUR FROM sum(real_duration))) + 43200*(extract(DAY FROM sum(real_duration))))
          /
         (extract(SECOND FROM sum(predicted_duration)) + 60*(extract(MINUTE FROM sum(predicted_duration))) +
          3600*(extract(HOUR FROM sum(predicted_duration))) + 43200*(extract(DAY FROM sum(predicted_duration))))
  FROM task WHERE assigned_user_email = $1 AND real_duration IS NOT NULL AND predicted_duration IS NOT NULL
            AND real_time BETWEEN $2 AND $3;
-- Tests --
EXECUTE get_functionality_of_tasks_in_a_duration('mohammad.alamy@gmail.com', '2017-07-09 22:20:00.0', '2017-07-09 22:50:00.0');

PREPARE get_functionality_of_tasks_in_a_list(path_domain, email_domain) AS
  SELECT (extract(SECOND FROM sum(real_duration)) + 60*(extract(MINUTE FROM sum(real_duration))) +
          3600*(extract(HOUR FROM sum(real_duration))) + 43200*(extract(DAY FROM sum(real_duration))))
          /
         (extract(SECOND FROM sum(predicted_duration)) + 60*(extract(MINUTE FROM sum(predicted_duration))) +
          3600*(extract(HOUR FROM sum(predicted_duration))) + 43200*(extract(DAY FROM sum(predicted_duration))))
  FROM task WHERE path = $1 AND task.email = $2 AND real_duration IS NOT NULL AND predicted_duration IS NOT NULL;
-- Tests --
EXECUTE get_functionality_of_tasks_in_a_list('/University/Semester4/DB','aliasgarikh@yahoo.com');

PREPARE get_functionality_of_tasks_in_a_folder(path_domain, email_domain) AS
  SELECT (extract(SECOND FROM sum(real_duration)) + 60*(extract(MINUTE FROM sum(real_duration))) +
          3600*(extract(HOUR FROM sum(real_duration))) + 43200*(extract(DAY FROM sum(real_duration))))
          /
         (extract(SECOND FROM sum(predicted_duration)) + 60*(extract(MINUTE FROM sum(predicted_duration))) +
          3600*(extract(HOUR FROM sum(predicted_duration))) + 43200*(extract(DAY FROM sum(predicted_duration))))
  FROM task WHERE path = $1 || '%' AND task.email = $2 AND real_duration IS NOT NULL AND predicted_duration IS NOT NULL;

SELECT count(*) FROM "User"
  WHERE extract(date FROM last_activity) = extract(DATE FROM current_timestamp);

PREPARE get_number_of_users_added_in_an_interval(time_setting_domain, time_setting_domain) AS
  SELECT count(email) FROM "User"
    WHERE registration_time BETWEEN $1 AND $2;

PREPARE get_user_growth_rate_in_an_interval(time_setting_domain, time_setting_domain) AS
  SELECT (SELECT count(email) FROM "User"
    WHERE registration_time BETWEEN $1 AND $2)
  /(SELECT count(email) FROM "User"
    WHERE registration_time < $1) FROM "User";

PREPARE delete_user(email_domain) AS
  DELETE FROM "User" WHERE email = $1;

PREPARE delete_list(path_domain, email_domain) AS
  DELETE FROM list WHERE path = $1 AND email = $2;

PREPARE delete_folder(path_domain, email_domain) AS
  DELETE FROM folder WHERE path = $1 AND email = $2;

PREPARE delete_comment(id_domain, log_time_domain) AS
  DELETE FROM comment WHERE id = $1 AND time = $2;

PREPARE promote_to_admin(email_domain) AS
  INSERT INTO role VALUES($1, 'admin');


-- Test Data --
EXECUTE registration('u1@m.c', 'u1', '1', '1');
EXECUTE registration('u2@m.c', 'u2', '2', '2');
EXECUTE registration('u3@m.c', 'u3', '3', '3');

EXECUTE create_folder_for_user('u1@m.c', '/Public', NULL );
EXECUTE create_folder_for_user('u2@m.c', '/Public', NULL );
EXECUTE create_folder_for_user('u3@m.c', '/Public', NULL );

SELECT create_list_for_user('u1@m.c', '/Public', '/Public/First');
SELECT create_list_for_user('u2@m.c', '/Public', '/Public/Second');
SELECT create_list_for_user('u3@m.c', '/Public', '/Public/Third');

EXECUTE create_task_in_list('u1@m.c', '/Public/First', 'Task1',
                            FALSE , 'First task of first user', '2018-01-01 20:30:0.0',
                            NULL, '2:00:00', NULL ,
                            '2018-01-02 20:30:0.0', NULL, 'u1@m.c');
EXECUTE create_task_in_list('u2@m.c', '/Public/Second', 'Task1',
                            FALSE , 'First task of second user', '2018-01-01 20:30:0.0',
                            NULL, '2:00:00', NULL ,
                            '2018-01-02 20:30:0.0', NULL, 'u2@m.c');
EXECUTE create_task_in_list('u3@m.c', '/Public/Third', 'Task1',
                            FALSE , 'First task of third user', '2018-01-01 20:30:0.0',
                            NULL, '2:00:00', NULL ,
                            '2018-01-02 20:30:0.0', NULL, 'u3@m.c');

EXECUTE create_subtask_for_task(3, 'Subtask1');
EXECUTE create_subtask_for_task(4, 'Subtask1');
EXECUTE create_subtask_for_task(5, 'Subtask1');

EXECUTE create_reminder_for_task(3, '2018-01-01 20:00:0.0', TRUE, TRUE);
EXECUTE create_reminder_for_task(4, '2018-01-01 20:00:0.0', TRUE, TRUE);
EXECUTE create_reminder_for_task(5, '2018-01-01 20:00:0.0', TRUE, TRUE);

-- Creating a shared folder --

EXECUTE create_folder_for_user('u1@m.c', '/Shared', NULL );
SELECT create_list_for_user('u1@m.c', '/Shared', '/Shared/First');
EXECUTE share_list_with_user('u2@m.c', 'u1@m.c', '/Shared/First', FALSE );
EXECUTE create_task_in_list('u1@m.c', '/Shared/First', 'SharedTask1',
                            FALSE , 'First shared task', '2018-02-01 20:30:0.0',
                            NULL, '3:00:00', NULL ,
                            '2018-02-03 20:30:0.0', NULL, NULL );
EXECUTE create_task_in_list('u1@m.c', '/Shared/First', 'SharedTask2',
                            FALSE , 'Second shared task', '2018-02-01 20:30:0.0',
                            NULL, '4:00:00', NULL ,
                            '2018-03-03 20:30:0.0', NULL, NULL );

EXECUTE write_comment_under_task(10, '???', 'u1@m.c', NULL, NULL);
EXECUTE write_comment_under_task(11, '!!!', 'u2@m.c', NULL, NULL);

EXECUTE add_resource_for_task(3, 'FirstResourceURL');
EXECUTE add_resource_for_task(4, 'SecondResourceURL');

EXECUTE add_tag_for_task(5, 'T1');
EXECUTE add_tag_for_task(5, 'T2');
EXECUTE add_tag_for_task(10, 'T3');

-- Checking trigger for preventing bad parent folder --
EXECUTE create_folder_for_user('u1@m.c', '/Private', '/Public');
-- Checking trigger for checking bad reminder times --
EXECUTE create_reminder_for_task(11, '2016-01-01 20:00:0.0', TRUE, TRUE);
EXECUTE create_reminder_for_task(11, '2018-02-03 20:30:00.0', TRUE, TRUE);
-- Checking trigger for assigning personal tasks automatically --
EXECUTE create_task_in_list('u1@m.c', '/Public/First', 'Task2',
                            FALSE , 'Second task of first user', '2018-01-03 20:30:0.0',
                            NULL, '5:00:00', NULL ,
                            '2018-01-06 20:30:0.0', NULL, NULL );