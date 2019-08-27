class ChangeTccToBeIntegerInBaseActivities < ActiveRecord::Migration[5.2]
  def change
    change_column :base_activities, :tcc, 'integer USING CAST(tcc AS integer)'
  end
end
