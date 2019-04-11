class AddTccToBaseActivities < ActiveRecord::Migration[5.2]
  change_table :base_activities, bulk: true do |t|
    t.string :tcc
  end
end
