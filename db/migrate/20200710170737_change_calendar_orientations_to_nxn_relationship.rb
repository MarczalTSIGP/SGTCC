class ChangeCalendarOrientationsToNxnRelationship < ActiveRecord::Migration[5.2]
  def change
    create_table :orientation_calendars do |t|
      t.belongs_to :calendar
      t.belongs_to :orientation
      t.timestamps
    end

    # Migration relationships
    Orientation.find_each do |o|
      OrientationCalendar.create(orientation_id: o.id, calendar_id: o.calendar_id)
    end

    # Remove column
    remove_column :orientations, :calendar_id, :boolean
  end
end
