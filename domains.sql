CREATE DOMAIN email_domain VARCHAR(254)
  CHECK (VALUE ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');

CREATE DOMAIN label_domain VARCHAR(32) NULL;

CREATE DOMAIN nickname_domain label_domain;

CREATE DOMAIN password_domain CHAR(32) NOT NULL;

CREATE DOMAIN url_domain VARCHAR(512) NULL;

CREATE DOMAIN resource_url_domain url_domain NOT NULL;

CREATE DOMAIN pic_url_domain url_domain NOT NULL
  DEFAULT 'http://www.gravatar.com/avatar/00095965ca2e9b81c365d541b9cc73ec?s=40&d=identicon';

CREATE DOMAIN time_setting_domain TIMESTAMP NULL;

CREATE DOMAIN log_time_domain TIMESTAMP NOT NULL;

CREATE DOMAIN text_domain VARCHAR(8192) NULL;

CREATE DOMAIN comment_text_domain text_domain NOT NULL;

CREATE DOMAIN title_domain VARCHAR(1024) NOT NULL;

CREATE DOMAIN path_domain url_domain
  CHECK (VALUE ~* '^(/[[:space:]A-Za-z0-9._%-]+)+$');

CREATE DOMAIN boolean_domain BOOLEAN NOT NULL;

CREATE DOMAIN recurrence_id_domain INTEGER NULL;

CREATE DOMAIN id_domain INTEGER NOT NULL;

CREATE DOMAIN duration_domain INTERVAL CHECK (VALUE > '00:00:00'::interval);