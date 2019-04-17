class Calendar < ApplicationRecord
  include Tcc

  validates :year, presence: true
  validates :semester, presence: true
  validates :tcc, presence: true

  enum semester: { one: 1, two: 2 }, _prefix: :semester

  def create_activities
    activities = BaseActivity.where(tcc: tcc)
    activities.each do |activity|
      Activity.create(
        name: activity.name,
        tcc: activity.tcc,
        calendar_id: id,
        base_activity_type_id: activity.base_activity_type_id
      )
    end
  end

  def self.current_calendar_by_tcc(tcc = 1)
    current_time = Time.current
    month = I18n.l(current_time, format: :month)
    year = I18n.l(current_time, format: :year)

    semester = month.to_i <= 6 ? 1 : 2

    Calendar.find_by(year: year, semester: semester, tcc: tcc)
  end

  def self.current_calendar_id_by_tcc(tcc = 1)
    calendar = current_calendar_by_tcc(tcc)
    calendar.present? ? calendar.id : nil
  end

  def self.human_semesters
    hash = {}
    semesters.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }
    hash
  end
end
