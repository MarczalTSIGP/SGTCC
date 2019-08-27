class AddStatusToOrientations < ActiveRecord::Migration[5.2]
  change_table :orientations, bulk: true do |t|
    t.string :status, default: Orientation.statuses['IN_PROGRESS']
  end
end
