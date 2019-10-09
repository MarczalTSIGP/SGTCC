class AddIdentifierToBaseActivityTypes < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE base_activity_type_identifiers AS ENUM ('send_document', 'info');
      ALTER TABLE base_activity_types ADD identifier base_activity_type_identifiers;
    SQL
  end

  def down
    remove_column :base_activity_types, :identifier
    execute <<-SQL
      DROP TYPE base_activity_type_identifiers;
    SQL
  end
end
