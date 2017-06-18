CREATE DOMAIN email_domain VARCHAR(254)
  CHECK (VALUE ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');

CREATE DOMAIN nickname_domain VARCHAR(32) NOT NULL;

CREATE DOMAIN password_domain CHAR(32) NOT NULL;

CREATE DOMAIN pic_url_domain VARCHAR(512) NOT NULL
  DEFAULT 'http://www.gravatar.com/avatar/00095965ca2e9b81c365d541b9cc73ec?s=40&d=identicon';

CREATE DOMAIN log_time_domain TIME NOT NULL;