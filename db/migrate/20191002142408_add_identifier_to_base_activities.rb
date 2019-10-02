class AddIdentifierToBaseActivities < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE base_activity_identifiers AS ENUM ('proposal', 'project', 'monograph');
      ALTER TABLE base_activities ADD identifier base_activity_identifiers;
    SQL
  end

  def down
    remove_column :base_activities, :identifier
    execute <<-SQL
      DROP TYPE base_activity_identifiers;
    SQL
  end
end
