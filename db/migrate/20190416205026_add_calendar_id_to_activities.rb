class AddCalendarIdToActivities < ActiveRecord::Migration[5.2]
  change_table :activities do |t|
    t.belongs_to :calendar, index: true, foreign_key: true
  end
end
