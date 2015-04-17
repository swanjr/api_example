class AddSyncTriggers < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE TRIGGER contribution_insert BEFORE INSERT ON contributions
          FOR EACH ROW
          BEGIN
            INSERT INTO files (file_name, upload_bucket, created_at, updated_at)
            VALUES (NEW.file_name, NEW.upload_bucket, NOW(), NOW());

            SET NEW.file_id = LAST_INSERT_ID();
          END;
        SQL

        execute <<-SQL
          CREATE TRIGGER contribution_update AFTER UPDATE ON contributions
          FOR EACH ROW
          BEGIN
            UPDATE files SET file_name = NEW.file_name, file_path = NEW.file_path, upload_bucket = NEW.upload_bucket, final_bucket = NEW.final_bucket, external_file_location = NEW.external_file_location, created_at = NEW.created_at, updated_at = NEW.updated_at WHERE files.id = NEW.file_id;
          END;
        SQL

        execute <<-SQL
          CREATE TRIGGER contribution_delete AFTER DELETE ON contributions
          FOR EACH ROW
          BEGIN
            DELETE FROM files WHERE files.id = OLD.file_id;
          END;
        SQL
      end

      dir.down do
        execute <<-SQL
          DROP TRIGGER IF EXISTS contribution_insert;
          DROP TRIGGER IF EXISTS contribution_update;
          DROP TRIGGER IF EXISTS contribution_delete;
        SQL
      end
    end

  end
end
