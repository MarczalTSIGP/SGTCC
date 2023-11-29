class AddIntervalToBaseActivities < ActiveRecord::Migration[5.2]
  def up
    change_table :base_activities, bulk: true do |t|
      t.integer :days_to_start, default: 0
      t.integer :duration_in_days, default: 0
    end
  end

  def down
    change_table :base_activities, bulk: true do |t|
      t.remove :days_to_start
      t.remove :duration_in_days
    end
  end
end
