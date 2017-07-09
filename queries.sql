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



PREPARE move_list_for_user(email_domain, path_domain, path_domain, path_domain) AS
  UPDATE list SET path = $3, folder_path = $4 WHERE email = $1 AND path = $2;
-- TODO: Creating trigger for updating values of Folder table --



PREPARE delete_list_for_user(email_domain, path_domain) AS
  DELETE FROM list WHERE email = $1 AND path = $2;
-- TODO: Creating trigger for deleting values from Folder table --



PREPARE create_task_in_list(email_domain, path_domain, id_domain, title_domain, boolean_domain,
  text_domain, time_setting_domain, time_setting_domain,  )

