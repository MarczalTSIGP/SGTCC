class Calendar < ApplicationRecord
  include Searchable
  include Tcc

  searchable :year

  has_many :activities, dependent: :restrict_with_error

  validates :tcc, presence: true
  validates :semester, presence: true
  validates :year,
            presence: true,
            format: { with: /\A\d{4}\z/ },
            uniqueness: { scope: [:semester, :tcc], case_sensetive: false }

  enum semester: { one: 1, two: 2 }, _prefix: :semester

  after_create :clone_base_activities

  def year_with_semester
    semester_t = I18n.t("enums.semester.#{semester}")
    "#{year}/#{semester_t}"
  end

  def self.previous_semester(calendar)
    year = calendar.year

    if semesters[calendar.semester] == 2
      semester = 1
    else
      semester = 2
      year = year.to_i - 1
    end

    find_by(semester: semester, year: year, tcc: tccs[calendar.tcc])
  end

  def self.next_semester(calendar)
    year = calendar.year

    if semesters[calendar.semester] == 1
      semester = 2
    else
      semester = 1
      year = year.to_i + 1
    end

    find_by(semester: semester, year: year, tcc: tccs[calendar.tcc])
  end

  def self.current_by_tcc(tcc)
    find_by(year: current_year, semester: current_semester, tcc: tcc)
  end

  def self.current_by_tcc_one
    current_by_tcc(Activity.tccs[:one])
  end

  def self.current_by_tcc_two
    current_by_tcc(Activity.tccs[:two])
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
    where(tcc: tcc).order(:year, :semester).map do |calendar|
      [calendar.id, calendar.year_with_semester]
    end
  end

  def self.human_semesters
    hash = {}
    semesters.each_key { |key| hash[I18n.t("enums.semester.#{key}")] = key }
    hash
  end

  private

  def clone_base_activities
    base_activities = BaseActivity.where(tcc: tcc)
    base_activities.each do |base_activity|
      create_activity(base_activity)
    end
  end

  def create_activity(activity)
    current_time = Time.current
    activities.create(
      name: activity.name,
      tcc: activity.tcc,
      calendar_id: id,
      base_activity_type_id: activity.base_activity_type_id,
      initial_date: current_time,
      final_date: current_time
    )
  end
end
