DEALLOCATE PREPARE move_folder;



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



PREPARE create_list_for_user(email_domain, path_domain, path_domain) AS
  INSERT INTO list VALUES ($2, $1, $3);
-- TODO: Creating trigger for inserting values into Folder table --
EXECUTE create_list_for_user('aliasgarikh@yahoo.com', '/University/Semester4/CA', '/University/Semester4');



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
  time_setting_domain, recurrence_id_domain) AS
  INSERT INTO task (title, starred, description, predicted_time, real_time, predicted_duration,
                    real_duration, deadline, email, path, recurrence_of_id)
  VALUES ($3, $4, $5, $6, $7, $8,
          $9, $10, $1, $2, $11);
-- Tests --
EXECUTE create_task_in_list('aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Project',
                            TRUE, 'Course Project', '2017-07-09 20:29:22.743437',
                            '2017-07-09 22:29:22.743437', '2:00:00', '3:00:00',
                            '2017-07-10 22:29:22.743437', NULL);



PREPARE edit_task_in_list(id_domain, email_domain, path_domain, title_domain, boolean_domain,
  text_domain, time_setting_domain, time_setting_domain, duration_domain, duration_domain,
  time_setting_domain, recurrence_id_domain) AS
  UPDATE task SET email = $2, path = $3, title = $4, starred = $5, description = $6,
                  predicted_time = $7, real_time = $8, predicted_duration = $9,
                  real_duration = $10, deadline = $11, recurrence_of_id = $12
  WHERE id = $1;
-- Tests --
EXECUTE edit_task_in_list(1, 'aliasgarikh@yahoo.com', '/University/Semester4/DB', 'Assignment3',
                            TRUE, 'Third Assignment', '2017-07-09 20:29:22.743437',
                            '2017-07-09 22:29:22.743437', '2:00:00', '3:00:00',
                            '2017-07-10 22:29:22.743437', NULL);



PREPARE delete_task_in_list(id_domain) AS
  DELETE FROM task WHERE id = $1;
-- Not tested yet --



