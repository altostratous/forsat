PREPARE registration(email_domain, nickname_domain, password_domain, pic_url_domain) AS
  INSERT INTO "User" VALUES ($1, $2, $3, $4, current_timestamp);
-- Tests --
EXECUTE registration('altostratous@gmail.com', 'alto', '1979', 'www.google.com');



PREPARE edit_personal_info(email_domain, email_domain, nickname_domain, password_domain, pic_url_domain) AS
  UPDATE "User" SET email = $2, nickname = $3, password = $4, pic_url = $5, last_activity = current_timestamp
    WHERE email = $1;
-- Tests --
EXECUTE edit_personal_info('altostratous@gmail.com','aliasgarikh@yahoo.com','alto', '1997', 'www.yahoo.com');



PREPARE remove_user(email_domain) AS
  DELETE FROM "User" WHERE email = $1;
-- Not tested yet --



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
-- Not tested yet --

CREATE FUNCTION create_list_for_user(email email_domain, parent_path path_domain, path path_domain) RETURNS VOID AS $create_list_for_user$
BEGIN
  INSERT INTO folder VALUES (path, email, parent_path);
  INSERT INTO list VALUES (path, email);
END;
$create_list_for_user$ LANGUAGE plpgsql;

-- TODO: Creating trigger for inserting values into Folder table --
EXECUTE create_folder_for_user ('aliasgarikh@yahoo.com', '/University/Semester4', NULL);
SELECT create_list_for_user('aliasgarikh@yahoo.com', '/University/Semester4', '/University/Semester4/CA');

ALTER TABLE list DROP COLUMN folder_path;

PREPARE move_list_for_user(email_domain, path_domain, path_domain, path_domain) AS
  UPDATE list SET path = $3, folder_path = $4 WHERE email = $1 AND path = $2;
-- TODO: Creating trigger for updating values of Folder table --
EXECUTE move_list_for_user('aliasgarikh@yahoo.com', '/University/Semester4/CA', '/University/Semester4/DB', '/University/Semester4');



PREPARE delete_list_for_user(email_domain, path_domain) AS
  DELETE FROM list WHERE email = $1 AND path = $2;
-- TODO: Creating trigger for deleting values from Folder table --
-- Not tested yet --



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

-- TODO: In personal lists(not shared) the task created must be assigned to creator automatically. Must be handled in app side --

PREPARE edit_task_in_list(id_domain, email_domain, path_domain, title_domain, boolean_domain,
  text_domain, time_setting_domain, time_setting_domain, duration_domain, duration_domain,
  time_setting_domain, recurrence_id_domain, email_domain) AS
  UPDATE task SET email = $2, path = $3, title = $4, starred = $5, description = $6,
                  predicted_time = $7, real_time = $8, predicted_duration = $9,
                  real_duration = $10, deadline = $11, recurrence_of_id = $12, assigned_user_email = $13
  WHERE id = $1;
-- Tests --
-- TODO: Edit tasks in
EXECUTE edit_task_in_list(1, 'aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Assignment3',
                            TRUE, 'Third Assignment', '2017-07-09 20:29:22.743437',
                            '2017-07-09 22:29:22.743437', '2:00:00', '3:00:00',
                            '2017-07-10 22:29:22.743437', NULL);



PREPARE delete_task_in_list(id_domain) AS
  DELETE FROM task WHERE id = $1;
-- Not tested yet --



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
-- Not tested yet --



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
-- Not tested yet --



PREPARE share_list_with_user(email_domain, email_domain, path_domain, boolean_domain) AS
  INSERT INTO sharedfolders VALUES($1, $2, $3, $4);
-- Tests --
EXECUTE registration('mohammad.alamy@gmail.com', 'MHA', '1968', 'www.avatar');
EXECUTE share_list_with_user('mohammad.alamy@gmail.com', 'aliasgarikh@yahoo.com', '/University/Semester4/DB', TRUE);

-- TODO: Check the person who is sharing is either owner or admin of list --

PREPARE edit_shared_list_with_user(email_domain, email_domain, path_domain, email_domain, path_domain, boolean_domain) AS
  UPDATE sharedfolders SET user_email = $4, path = $5, is_admin = $6 WHERE user_email = $1 AND owner_email = $2 AND path = $3;
-- Tests --
EXECUTE edit_shared_list_with_user('mohammad.alamy@gmail.com', 'aliasgarikh@yahoo.com', '/University/Semester4/DB',
                                    'mohammad.alamy@gmail.com', '/University/Semester4/DB', FALSE );

-- TODO: Check the person who is editing is either owner or admin of list --

PREPARE remove_user_from_list(email_domain, email_domain, path_domain) AS
  DELETE FROM sharedfolders WHERE user_email = $1 AND owner_email = $2 AND path = $3;
-- Not tested yet --

-- TODO: Check the person who is removing is either owner or admin of list --
-- TODO: Remove the user from the tasks which are assigned to him when removing --

PREPARE assign_task_to_user(id_domain, email_domain) AS
  UPDATE task SET assigned_user_email = $2 WHERE id = $1;
-- Tests --
-- TODO: Adding Trigger to check that the change is made by admin or owner(maybe in application level) --
EXECUTE create_task_in_list('aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Project',
                            TRUE, 'Course Project', '2017-07-09 20:29:22.743437',
                            '2017-07-09 22:29:22.743437', '2:00:00', '3:00:00',
                            '2017-07-10 22:29:22.743437', NULL, 'aliasgarikh@yahoo.com');
EXECUTE assign_task_to_user(2,'mohammad.alamy@gmail.com');



PREPARE begin_task(id_domain) AS
  UPDATE task SET real_time = current_timestamp WHERE id = $1;

-- TODO: Check the user beginning task is the user that task is assigned to --

PREPARE end_task(id_domain) AS
  UPDATE task SET real_duration = current_timestamp - real_time WHERE id = $1;

-- TODO: Check the user ending task is the user that task is assigned to --

-- Tests --
EXECUTE create_task_in_list('aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Assignment2',
                            FALSE, 'Second assignment', '2017-07-09 20:29:22.743437',
                            NULL , '2:00:00', NULL, '2017-07-10 22:29:22.743437', NULL, 'mohammad.alamy@gmail.com')
EXECUTE begin_task(3);
EXECUTE end_task(3);



PREPARE write_comment_under_task(id_domain, text_domain, email_domain, time_setting_domain, email_domain) AS
  INSERT INTO comment VALUES($2, current_timestamp, $3, $1, $4, $5);
-- Tests --
EXECUTE write_comment_under_task(3, 'Covfefe', current_timestamp, 'mohammad.alamy@gmail.com', NULL, NULL);

-- TODO: Check that only users can write comments that are either owner or shared with list. --

PREPARE edit_comment_under_task(id_domain, time_setting_domain, text_domain, email_domain, time_setting_domain, email_domain) AS
  UPDATE comment SET text = $3, time = current_timestamp, email = $4, replied_to_time = $5, replied_to_email = $6
    WHERE id = $1 AND time = $2;
-- Tests --
EXECUTE edit_comment_under_task(3,'2017-07-09 22:58:03.238175', '???', 'mohammad.alamy@gmail.com', NULL, NULL );

-- TODO: Check that the person which is editing comment is the person who wrote it --

PREPARE delete_comment_under_task(id_domain, time_setting_domain) AS
  DELETE FROM comment WHERE id = $1 AND time = $2;
-- Not tested yet --

-- TODO: Check that the person which is deleting comment is the person who wrote it or admin or owner --



