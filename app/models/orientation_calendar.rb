class OrientationCalendar < ApplicationRecord
  belongs_to :orientation
  belongs_to :calendar

  validates :orientation_id, uniqueness: { scope: :calendar_id }
end
