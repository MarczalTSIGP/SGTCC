class Calendar < ApplicationRecord
  include Searchable
  include Tcc
  include Semester
  include CurrentCalendar

  searchable :year

  has_many :orientation_calendars, dependent: :restrict_with_error
  has_many :orientations, through: :orientation_calendars

  has_many :activities, dependent: :restrict_with_error
  has_many :academic_activities, through: :activities, source: :academic_activities

  validates :tcc, presence: true
  validates :semester, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validates :year,
            presence: true,
            format: { with: /\A\d{4}\z/ },
            uniqueness: { scope: [:semester, :tcc], case_sensitive: false,
                          message: I18n.t('activerecord.errors.models.calendar.attributes.year') }

  before_validation :set_dates
  after_create :clone_base_activities

  def set_dates
    return if start_date.present? && end_date.present?

    y = year.to_i
    s = semester.to_i

    self.start_date ||= Date.new(y, s == 1 ? 1 : 7, 1)
    self.end_date   ||= Date.new(y, s == 1 ? 6 : 12, -1)
  end

  def year_with_semester
    "#{year}/#{I18n.t("enums.semester.#{semester}")}"
  end

  def year_with_semester_and_tcc
    "#{year_with_semester} - TCC: #{I18n.t("enums.tcc.#{tcc}")}"
  end

  def orientation_by_academic(academic_id)
    orientations.find_by(academic_id)
  end

  def current?
    Calendar.current_calendar?(self)
  end

  def self.search_by_semester(calendar, semester)
    find_by(semester:, year: calendar.year, tcc: tccs[calendar.tcc])
  end

  def self.search_by_first_semester_next_year(calendar)
    find_by(semester: 1, year: calendar.year.to_i + 1, tcc: tccs[calendar.tcc])
  end

  def self.search_by_second_semester_previous_year(calendar)
    find_by(semester: 2, year: calendar.year.to_i - 1, tcc: tccs[calendar.tcc])
  end

  def self.previous_semester(calendar)
    return nil if calendar.nil?
    return search_by_semester(calendar, 1) if calendar.semester == 'two'

    search_by_second_semester_previous_year(calendar)
  end

  def self.next_semester(calendar)
    return search_by_semester(calendar, 2) if calendar.semester == 'one'

    search_by_first_semester_next_year(calendar)
  end

  def self.next_semester_tcc_two(calendar)
    return next_semester(calendar) if calendar.tcc == 'two'

    if calendar.semester == 'one'
      return find_by(semester: 'two', year: calendar.year, tcc: tccs[:two])
    end

    find_by(semester: 'one', year: calendar.year.to_i + 1, tcc: tccs[:two])
  end

  def self.search_by_tcc(tcc, page, term)
    where(tcc:).page(page).search(term).order({ year: :desc }, { semester: :desc })
  end

  def self.search_by_tcc_one(page, term)
    search_by_tcc(tccs[:one], page, term)
  end

  def self.search_by_tcc_two(page, term)
    search_by_tcc(tccs[:two], page, term)
  end

  def self.select_data(tcc)
    where(tcc:).order({ year: :desc }, :semester).map do |calendar|
      [calendar.id, calendar.year_with_semester]
    end
  end

  def self.select_for_orientation
    order({ year: :desc }, :tcc, :semester).map do |calendar|
      [calendar.id, calendar.year_with_semester_and_tcc]
    end
  end

  def self.by_first_year_and_tcc(tcc)
    first_year = minimum('year')
    first_calendar = find_by(year: first_year, semester: 'one', tcc:)
    return first_calendar if first_calendar.present?

    find_by(year: first_year, semester: 'two', tcc:)
  end

  def self.orientations_report_by_status(status, years: [], total: [])
    calendar = by_first_year_and_tcc('two')
    loop do
      break if calendar.blank?

      years.push(calendar.year_with_semester)
      total.push(calendar.orientations.where(status:).size)
      calendar = next_semester(calendar)
    end
    { years:, total: }
  end

  private

  def clone_base_activities
    Calendars::CloneBaseActivities.to(self)
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    return unless end_date <= start_date

    errors.add(:end_date, 'deve ser posterior à data de início')
  end
end
