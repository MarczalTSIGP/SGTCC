class AddFinalVersionToActivities < ActiveRecord::Migration[5.2]
  change_table :activities, bulk: true do |t|
    t.boolean :final_version, default: false, null: false
  end
end
