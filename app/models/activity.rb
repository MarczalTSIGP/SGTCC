class Activity < ApplicationRecord
  include Tcc

  belongs_to :base_activity_type
  belongs_to :calendar, required: false

  validates :name, presence: true
  validates :tcc, presence: true

  def self.create_activities(calendar)
    activities = BaseActivity.where(tcc: calendar.tcc)
    activities.each do |activity|
      Activity.create(
        name: activity.name,
        tcc: activity.tcc,
        calendar_id: calendar.id,
        base_activity_type_id: activity.base_activity_type_id
      )
    end
  end

  def self.by_tcc(tcc = Activity.tccs[:one])
    current_calendar_id = Calendar.current_id_by_tcc(tcc)

    Activity.where(tcc: tcc, calendar_id: current_calendar_id)
            .includes(:base_activity_type)
            .order(:name)
  end
end
