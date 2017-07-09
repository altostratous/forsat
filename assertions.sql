CREATE ASSERTION parent_path_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Folder JOIN Folder AS Parent
      WHERE NOT Folder.path LIKE Parent.path || '%'
  )
)

CREATE ASSERTION predicted_end_time_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Task WHERE real_duration > 0
  )
)

CREATE ASSERTION predicted_end_time_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Task WHERE predicted_duration > 0
  )
)

CREATE ASSERTION reminder_time_validity CHECK (
  NOT EXISTS (
    SELECT * FROM Reminder JOIN Task WHERE
      Reminder.time > Task.predicted_time + Task.predicted_duration OR
      Reminder.time > Task.real_time + Task.real_duration
  )
)


