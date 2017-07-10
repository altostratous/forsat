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

-- triggers to redirect delete and update from list to folder
CREATE FUNCTION delete_from_list() RETURNS trigger AS $$
  BEGIN
    DELETE FROM folder WHERE OLD.email = email AND OLD.path = path;
    RETURN OLD;
  END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION update_list() RETURNS trigger AS $$
  BEGIN
    UPDATE folder SET path = NEW.path, email = NEW.email WHERE email = OLD.email AND path = OLD.path;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER list_delete_redirection
  AFTER DELETE ON list
  FOR EACH ROW EXECUTE PROCEDURE delete_from_list();

CREATE TRIGGER list_update_redirection
  BEFORE UPDATE ON list
  FOR EACH ROW EXECUTE PROCEDURE update_list();

DROP TRIGGER list_delete_redirection;

-- Logging user folder activities
CREATE FUNCTION assign_personal_tasks() RETURNS trigger AS $$
  BEGIN
    IF NOT EXISTS(SELECT * FROM sharedfolders WHERE path = NEW.path AND owner_email = NEW.email) THEN
      NEW.assigned_user_email = NEW.email;
    END IF;
    RETURN NEW;
  END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER task_insert_validity
  BEFORE INSERT ON task
  FOR EACH ROW
  EXECUTE PROCEDURE assign_personal_tasks();