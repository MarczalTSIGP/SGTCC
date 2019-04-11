class RenameForeignKeyActivityTypeToBaseActivityType < ActiveRecord::Migration[5.2]
  def change
    rename_column :base_activities, :activity_type_id, :base_activity_type_id
  end
end
