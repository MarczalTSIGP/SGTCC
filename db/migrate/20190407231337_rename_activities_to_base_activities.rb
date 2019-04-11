class RenameActivitiesToBaseActivities < ActiveRecord::Migration[5.2]
  def change
    rename_table :activities, :base_activities
  end
end
