class AddInitialAndFinalDateToActivities < ActiveRecord::Migration[5.2]
  change_table :activities, bulk: true do |t|
    t.timestamp :initial_date
    t.timestamp :final_date
  end
end
