CREATE DOMAIN email_domain VARCHAR(254)
  CHECK (VALUE ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');
