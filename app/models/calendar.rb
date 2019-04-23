class Calendar < ApplicationRecord
  include Tcc

  has_many :activities, dependent: :restrict_with_error

  validates :tcc, presence: true
  validates :semester, presence: true
  validates :year,
            presence: true,
            format: { with: /\A\d{4}\z/ }

  enum semester: { one: 1, two: 2 }, _prefix: :semester

  after_create :clone_base_activities

  def clone_base_activities
    base_activities = BaseActivity.where(tcc: tcc)
    base_activities.each do |base_activity|
      activities.create(
        name: base_activity.name,
        tcc: base_activity.tcc,
        calendar_id: id,
        base_activity_type_id: base_activity.base_activity_type_id
      )
    end
  end

  def year_with_semester
    semester_t = I18n.t("enums.semester.#{semester}")
    "#{year}/#{semester_t}"
  end

  def self.current_by_tcc(tcc)
    Calendar.find_by(
      year: current_year,
      semester: current_semester,
      tcc: tcc
    )
  end

  def self.current_by_tcc_one
    Calendar.current_by_tcc(Activity.tccs[:one])
  end

  def self.current_by_tcc_two
    Calendar.current_by_tcc(Activity.tccs[:two])
  end

  def self.current_year
    I18n.l(Time.current, format: :year)
  end

  def self.current_month
    I18n.l(Time.current, format: :month)
  end

  def self.current_semester
    current_month.to_i <= 6 ? 1 : 2
  end

  def self.select_data(tcc)
    Calendar.where(tcc: tcc).order(created_at: :desc).map do |calendar|
      [calendar.id, calendar.year_with_semester]
    end
  end

  def self.human_semesters
    hash = {}
    semesters.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }
    hash
  end
end
