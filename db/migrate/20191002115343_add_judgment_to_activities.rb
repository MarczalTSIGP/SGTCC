class AddJudgmentToActivities < ActiveRecord::Migration[5.2]
  change_table :activities, bulk: true do |t|
    t.boolean :judgment, default: false, null: false
  end
end
