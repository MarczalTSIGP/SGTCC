class RenameTccActivitiesToActivities < ActiveRecord::Migration[5.2]
  def change
    rename_table :tcc_activities, :activities
  end
end
