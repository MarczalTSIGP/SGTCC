class AddIntervalToBaseActivities < ActiveRecord::Migration[5.2]
  change_table :base_activities, bulk: true do |t|
    t.integer :interval, default: 0
  end
end
