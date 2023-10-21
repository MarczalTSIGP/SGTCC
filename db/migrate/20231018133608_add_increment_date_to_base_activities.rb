class AddIncrementDateToBaseActivities < ActiveRecord::Migration[5.2]
  change_table :base_activities, bulk: true do |t|
    t.integer :increment_date, default: 0
  end
end
