class Calendar < ApplicationRecord
  include Searchable
  include Tcc
  include Semester

  searchable :year

  has_many :activities, dependent: :restrict_with_error
  has_many :orientations, dependent: :restrict_with_error

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

  def self.search_by_second_semester(calendar)
    find_by(semester: 2, year: calendar.year, tcc: tccs[calendar.tcc])
  end

  def self.search_by_first_semester(calendar)
    find_by(semester: 1, year: calendar.year, tcc: tccs[calendar.tcc])
  end

  def self.search_by_first_semester_next_year(calendar)
    find_by(semester: 1, year: calendar.year.to_i + 1, tcc: tccs[calendar.tcc])
  end

  def self.search_by_second_semester_previous_year(calendar)
    find_by(semester: 2, year: calendar.year.to_i - 1, tcc: tccs[calendar.tcc])
  end

  def self.previous_semester(calendar)
    return search_by_first_semester(calendar) if calendar.semester == 'two'
    search_by_second_semester_previous_year(calendar)
  end

  def self.next_semester(calendar)
    return search_by_second_semester(calendar) if calendar.semester == 'one'
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

  def self.current_by_tcc_one
    find_by(year: current_year, semester: current_semester, tcc: tccs[:one])
  end

  def self.current_by_tcc_two
    find_by(year: current_year, semester: current_semester, tcc: tccs[:two])
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
    where(tcc: tcc).order({ year: :desc }, :semester).map do |calendar|
      [calendar.id, calendar.year_with_semester]
    end
  end

  def self.select_for_orientation
    all.order({ year: :desc }, :tcc, :semester).map do |calendar|
      [calendar.id, calendar.year_with_semester_and_tcc]
    end
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
