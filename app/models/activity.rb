class Activity < ApplicationRecord
  include Tcc

  belongs_to :base_activity_type
  belongs_to :calendar, required: false

  validates :name, presence: true
  validates :tcc, presence: true

  def self.create_activities(calendar)
    activities = BaseActivity.where(tcc: calendar.tcc)
    activities.each do |activity|
      create(
        name: activity.name,
        tcc: activity.tcc,
        calendar_id: calendar.id,
        base_activity_type_id: activity.base_activity_type_id
      )
    end
  end

  def self.by_tcc(tcc = Activity.tccs[:one], calendar_id = nil)
    calendar_id = Calendar.current_id_by_tcc(tcc) if calendar_id.blank?

    Activity.where(tcc: tcc, calendar_id: calendar_id)
            .includes(:base_activity_type)
            .order(:name)
  end
end
