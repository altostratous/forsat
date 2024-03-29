CREATE TABLE "User"(
  email   email_domain,
  nickname nickname_domain,
  password password_domain,
  pic_url pic_url_domain,
  last_activity log_time_domain,
  registration_time log_time_domain,
  PRIMARY KEY (email)
);

CREATE TABLE Folder(
  path path_domain,
  email email_domain,
  child_of_path path_domain,
  FOREIGN KEY (email) REFERENCES "User"
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (child_of_path,email) REFERENCES Folder
    ON UPDATE CASCADE
    on DELETE CASCADE,
  PRIMARY KEY (path,email)
);

CREATE TABLE FolderActivities(
  path path_domain,
  email email_domain,
  time log_time_domain,
  message comment_text_domain,
  FOREIGN KEY (path,email) REFERENCES Folder
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (path,email,time,message)
);

CREATE TABLE List(
  path path_domain,
  email email_domain,
  FOREIGN KEY (path,email) REFERENCES Folder
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (path,email)
);

CREATE TABLE Task(
  id SERIAL,
  title title_domain,
  starred boolean_domain,
  description text_domain,
  predicted_time time_setting_domain,
  real_time time_setting_domain,
  predicted_duration duration_domain,
  real_duration duration_domain,
  deadline time_setting_domain,
  email email_domain,
  path path_domain,
  recurrence_of_id recurrence_id_domain,
  assigned_user_email email_domain,
  PRIMARY KEY (id),
  FOREIGN KEY (path,email) REFERENCES List
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (recurrence_of_id) REFERENCES Task
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (assigned_user_email) REFERENCES "User"
    ON UPDATE CASCADE
    ON DELETE SET NULL
);

CREATE TABLE ResourceURLs(
  id id_domain,
  resource_url resource_url_domain,
  FOREIGN KEY (id) REFERENCES Task
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (id,resource_url)
);

CREATE TABLE TaskTags(
  tag label_domain,
  id id_domain,
  FOREIGN KEY (id) REFERENCES Task
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (id,tag)
);

CREATE TABLE Comment(
  text  comment_text_domain,
  time  log_time_domain,
  email email_domain,
  id id_domain,
  replied_to_time time_setting_domain,
  replied_to_email email_domain,
  FOREIGN KEY (email) REFERENCES "User"
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (id) REFERENCES Task
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  FOREIGN KEY (email, time, id) REFERENCES Comment
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (email, time, id)
);

CREATE TABLE Subtask(
  id id_domain,
  title title_domain,
  done boolean_domain DEFAULT FALSE,
  FOREIGN KEY (id) REFERENCES Task
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (id,title)
);

CREATE TABLE Reminder(
  time time_setting_domain,
  id id_domain,
  send_email boolean_domain,
  notify boolean_domain,
  FOREIGN KEY (id) REFERENCES Task
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (id,time)
);

CREATE TABLE Role(
  email email_domain,
  name label_domain,
  FOREIGN KEY (email) REFERENCES "User"
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (email,name)
);

CREATE TABLE SharedFolders(
  user_email email_domain,
  owner_email email_domain,
  path path_domain,
  is_admin boolean_domain,
  FOREIGN KEY (user_email) REFERENCES "User"
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (path, owner_email) REFERENCES Folder
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  PRIMARY KEY (user_email, owner_email, path)
)