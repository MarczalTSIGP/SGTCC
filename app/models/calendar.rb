class Calendar < ApplicationRecord
  include Tcc

  has_many :activities, dependent: :restrict_with_error

  validates :year, presence: true
  validates :semester, presence: true
  validates :tcc, presence: true

  enum semester: { one: 1, two: 2 }, _prefix: :semester

  def year_with_semester
    semester_t = I18n.t("enums.semester.#{semester}")
    "#{year}/#{semester_t}"
  end

  def self.current_by_tcc(tcc = Activity.tccs[:one])
    Calendar.find_by(
      year: current_year,
      semester: current_semester,
      tcc: tcc
    )
  end

  def self.current_id_by_tcc(tcc = Activity.tccs[:one])
    calendar = current_by_tcc(tcc)
    calendar.present? ? calendar.id : nil
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

  def self.search_by_param(tcc, param)
    calendar = param.split('/')
    year = calendar.first.to_i
    semester = calendar.last.to_i
    Calendar.find_by(year: year, semester: semester, tcc: tcc)
  end

  def self.human_semesters
    hash = {}
    semesters.each_key { |key| hash[I18n.t("enums.tcc.#{key}")] = key }
    hash
  end
end
