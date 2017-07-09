CREATE FUNCTION validate_parent_path() RETURNS TRIGGER AS
  BEGIN
  END

CREATE TRIGGER parent_path_validity
  BEFORE UPDATE OF path ON Folder
  FOR EACH ROW
  WHEN (NOT new.path LIKE (SELECT path FROM Folder WHERE path = new.child_of_path) || '%')


CREATE ASSERTION parent_path_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Folder JOIN Folder AS Parent
      WHERE NOT Folder.path LIKE Parent.path || '%'
  )
)

CREATE ASSERTION predicted_end_time_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Task WHERE real_end_time < real_time
  )
)

CREATE ASSERTION predicted_end_time_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Task WHERE predicted_end_time < predicted_time
  )
)

CREATE ASSERTION reminder_time_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Reminder JOIN Task WHERE
      Reminder.time > Task.predicted_time OR
      Reminder.time > Task.real_time
  )
)


