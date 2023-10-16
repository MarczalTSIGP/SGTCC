class Calendar < ApplicationRecord
  include Searchable
  include Tcc
  include Semester
  include CurrentCalendar
  include DateCalculator

  searchable :year

  has_many :orientation_calendars, dependent: :restrict_with_error
  has_many :orientations, through: :orientation_calendars

  has_many :activities, dependent: :restrict_with_error
  has_many :academic_activities, through: :activities, source: :academic_activities

  validates :tcc, presence: true
  validates :semester, presence: true
  validates :year,
            presence: true,
            format: { with: /\A\d{4}\z/ },
            uniqueness: { scope: [:semester, :tcc], case_sensetive: false,
                          message: I18n.t('activerecord.errors.models.calendar.attributes.year') }

  after_create :clone_base_activities

  def year_with_semester
    "#{year}/#{I18n.t("enums.semester.#{semester}")}"
  end

  def year_with_semester_and_tcc
    "#{year_with_semester} - TCC: #{I18n.t("enums.tcc.#{tcc}")}"
  end

  def current?
    Calendar.current_calendar?(self)
  end

  def self.start_date
    # TODO: remove
    # "01/#{current_month}/#{current_year}"
    # month = current_semester == 'one' ? 1 : 7
    Date.parse("1/#{current_semester}/#{current_year}")
  end

  def self.search_by_semester(calendar, semester)
    find_by(semester: semester, year: calendar.year, tcc: tccs[calendar.tcc])
  end

  def self.search_by_first_semester_next_year(calendar)
    find_by(semester: 1, year: calendar.year.to_i + 1, tcc: tccs[calendar.tcc])
  end

  def self.search_by_second_semester_previous_year(calendar)
    find_by(semester: 2, year: calendar.year.to_i - 1, tcc: tccs[calendar.tcc])
  end

  def self.previous_semester(calendar)
    return search_by_semester(calendar, 1) if calendar.semester == 'two'

    search_by_second_semester_previous_year(calendar)
  end

  def self.next_semester(calendar)
    return search_by_semester(calendar, 2) if calendar.semester == 'one'

    search_by_first_semester_next_year(calendar)
  end

  def self.search_by_tcc(tcc, page, term)
    where(tcc: tcc).page(page).search(term).order({ year: :desc }, :semester)
  end

  def self.search_by_tcc_one(page, term)
    search_by_tcc(tccs[:one], page, term)
  end

  def self.search_by_tcc_two(page, term)
    search_by_tcc(tccs[:two], page, term)
  end

  def self.select_data(tcc)
    where(tcc: tcc).order({ year: :desc }, :semester).map do |calendar|
      [calendar.id, calendar.year_with_semester]
    end
  end

  def self.select_for_orientation
    all.order({ year: :desc }, :tcc, :semester).map do |calendar|
      [calendar.id, calendar.year_with_semester_and_tcc]
    end
  end

  def self.by_first_year_and_tcc(tcc)
    first_year = minimum('year')
    first_calendar = find_by(year: first_year, semester: 'one', tcc: tcc)
    return first_calendar if first_calendar.present?

    find_by(year: first_year, semester: 'two', tcc: tcc)
  end

  def self.orientations_report_by_status(status, years: [], total: [])
    calendar = by_first_year_and_tcc('two')
    loop do
      break if calendar.blank?

      years.push(calendar.year_with_semester)
      total.push(calendar.orientations.where(status: status).size)
      calendar = next_semester(calendar)
    end
    { years: years, total: total }
  end

  private

  def clone_base_activities
    base_activities = BaseActivity.where(tcc: tcc)
    date_data = DateCalculator.calculate_all_dates(tcc)
    initial_date = date_data.initial_date
    final_date = date_data.final_date

    base_activities.each do |base_activity|
      create_activity(base_activity, initial_date, final_date)
      initial_date = DateCalculator.increment_date(initial_date, interval + 1)
      final_date = DateCalculator.calculate_final_date(initial_date, interval)
    end
  end

  def create_activity(base_activity, initial_date, final_date)
    activity_params = {
      name: base_activity.name, tcc: base_activity.tcc,
      calendar_id: id,
      base_activity_type_id: base_activity.base_activity_type_id,
      judgment: base_activity&.judgment, identifier: base_activity&.identifier,
      initial_date: initial_date, final_date: final_date,
      final_version: base_activity&.final_version
    }
    
    activities.create(activity_params)
  end
end
