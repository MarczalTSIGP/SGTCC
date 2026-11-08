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

    # Mesmo mapeamento de antes: ano inválido vira `to_i` e semestre ausente conta como
    # o 2º. Roda antes da validação, que reprova esses casos de qualquer forma.
    period = AcademicPeriod.new(year: year.to_i, semester: semester_one? ? 1 : 2)

    self.start_date ||= period.first_day
    self.end_date   ||= period.last_day
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

  def self.previous_semester(calendar)
    Calendars::PeriodNavigationQuery.previous_semester(calendar)
  end

  def self.next_semester(calendar)
    Calendars::PeriodNavigationQuery.next_semester(calendar)
  end

  def self.next_semester_tcc_two(calendar)
    Calendars::PeriodNavigationQuery.next_semester_tcc_two(calendar)
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
