CREATE TABLE "User"(
  email   email_domain,
  nickname nickname_domain,
  password password_domain,
  pic_url pic_url_domain,
  last_activity log_time_domain,
  PRIMARY KEY (email)
);

CREATE TABLE Task(
  id
);

CREATE TABLE Comment(
  text  comment_text_domain,
  time  log_time_domain,
  email email_domain,
  FOREIGN KEY (email) REFERENCES "User",
  PRIMARY KEY (email, time)
);

CREATE TABLE