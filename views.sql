CREATE VIEW SharedFoldersView AS
  SELECT DISTINCT (path,owner_email) FROM sharedfolders;