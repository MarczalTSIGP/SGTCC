class AddIdentifierToActivities < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE activity_identifiers AS ENUM ('proposal', 'project', 'monograph');
      ALTER TABLE activities ADD identifier activity_identifiers;
    SQL
  end

  def down
    remove_column :activities, :identifier
    execute <<-SQL
      DROP TYPE activity_identifiers;
    SQL
  end
end
