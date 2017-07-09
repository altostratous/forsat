PREPARE registration(email_domain, nickname_domain, password_domain, pic_url_domain) AS
  INSERT INTO "User" VALUES ($1, $2, $3, $4, current_timestamp);

EXECUTE registration('altostratous@gmail.com', 'alto', '1979', 'www.google.com');

PREPARE edit_personal_info(email_domain, nickname_domain, password_domain, pic_url_domain, email_domain, nickname_domain, password_domain, pic_url_domain) AS
  UPDATE "User" SET ($1, $2, )