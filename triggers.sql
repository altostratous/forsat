-- procedure to ignore update
CREATE FUNCTION ignore_manipulation() RETURNS trigger AS $ignore_manipulation$
  BEGIN
  RETURN NULL;
  END;
$ignore_manipulation$ LANGUAGE plpgsql;

-- triggers to prevent bad parent folders
CREATE TRIGGER parent_path_update_validity
  BEFORE UPDATE OF path ON Folder
  FOR EACH ROW
  WHEN (NOT NEW.path LIKE NEW.child_of_path || '%')
  EXECUTE PROCEDURE ignore_manipulation();
  
CREATE TRIGGER parent_path_insert_validity
  BEFORE INSERT ON Folder
  FOR EACH ROW
  WHEN (NOT NEW.path LIKE NEW.child_of_path || '%')
  EXECUTE PROCEDURE ignore_manipulation();

-- procedure to ignore bad reminder times
CREATE FUNCTION ignore_bad_reminder_time() RETURNS trigger AS $ignore_bad_reminder_time$
	BEGIN
    IF (SELECT predicted_time + predicted_duration FROM Task WHERE id = NEW.id) < NEW.time THEN
    	RETURN NULL;
    END IF;
    IF (SELECT real_time + real_duration FROM Task WHERE id = NEW.id) < NEW.time THEN
    	RETURN NULL;
    END IF;
    RETURN NEW;
    END;
$ignore_bad_reminder_time$ LANGUAGE plpgsql;

-- triggers to prevent invalid reminders
CREATE TRIGGER reminder_time_insert_validity 
  BEFORE INSERT ON Reminder
  FOR EACH ROW EXECUTE PROCEDURE ignore_bad_reminder_time();
 
CREATE TRIGGER reminder_time_update_validity 
  BEFORE UPDATE OF time ON Reminder
  FOR EACH ROW EXECUTE PROCEDURE ignore_bad_reminder_time();