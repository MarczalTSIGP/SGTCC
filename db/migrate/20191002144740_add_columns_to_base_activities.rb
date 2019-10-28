class AddColumnsToBaseActivities < ActiveRecord::Migration[5.2]
  change_table :base_activities, bulk: true do |t|
    t.boolean :judgment, default: false
    t.boolean :final_version, default: false
  end
end
