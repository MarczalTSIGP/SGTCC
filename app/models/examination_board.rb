class ExaminationBoard < ApplicationRecord
  include ExaminationBoardDefenseMinutes
  include UsersToDocument
  include SituationEnum
  include TccIdentifier
  include Searchable
  include Tcc

  searchable place: { unaccent: true }, relationships: {
    orientation: { fields: [{ title: { unaccent: true } }] }
  }

  belongs_to :orientation

  validates :place, presence: true
  validates :date, presence: true
  validates :identifier, presence: true
  validates :document_available_until, presence: true

  has_many :examination_board_attendees, dependent: :delete_all,
                                         after_add: :touch_updated_at,
                                         after_remove: :touch_updated_at

  has_many :examination_board_notes, dependent: :delete_all

  has_many :professors, class_name: 'Professor', foreign_key: :professor_id,
                        through: :examination_board_attendees, dependent: :destroy

  has_many :external_members, class_name: 'ExternalMember', foreign_key: :external_member_id,
                              through: :examination_board_attendees, dependent: :destroy

  scope :tcc_one, -> { where(tcc: :one) }
  scope :tcc_two, -> { where(tcc: :two) }

  scope :tcc_one_current_semester, lambda {
    tcc_value = :one
    current = Calendar.current_by_tcc_one ||
              Calendar.where(tcc: tcc_value)
                      .order(year: :desc, end_date: :desc)
                      .first

    return none if current.blank?

    joins(orientation: :calendars)
      .where(calendars: { id: current.id })
      .where(tcc: tcc_value)
      .distinct
  }

  scope :tcc_two_current_semester, lambda {
    tcc_value = :two

    current = Calendar.current_by_tcc_two ||
              Calendar.where(tcc: tcc_value)
                      .order(year: :desc, end_date: :desc)
                      .first

    return none if current.blank?

    joins(orientation: :calendars)
      .where(calendars: { id: current.id })
      .where(tcc: tcc_value)
      .distinct
  }

  scope :current_semester, lambda {
    current_calendar = Calendar
                       .where('start_date <= ? AND end_date >= ?', Date.current, Date.current)
                       .order(year: :desc, semester: :desc).first
    return none unless current_calendar

    where(date: current_calendar.start_date..current_calendar.end_date)
  }

  scope :recent, -> { order(date: :desc) }

  scope :with_relationships, lambda {
    includes(orientation: [:academic, :calendars, { advisor: [:scholarity] }])
  }

  scope :site_with_relationships, lambda {
    includes(external_members: [:scholarity], professors: [:scholarity],
             orientation: [:academic, :orientation_supervisors, :professor_supervisors,
                           :external_member_supervisors, { advisor: [:scholarity] }])
  }

  after_commit :trigger_create_notifications, on: :create

  def self.touch_related_to(academic_activity, orientation)
    orientation.examination_boards.each do |board|
      # rubocop:disable Rails/SkipsModelValidations
      board.touch if board.academic_activity == academic_activity
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  def minutes_type
    return :adpp if proposal?
    return :adpj if project?

    :admg
  end

  def academic_activity
    orientation.send(identifier)
  end

  def academic_document_title
    academic_activity&.title
  end

  def examination_board_data
    { id:, evaluators: evaluators_object, document_title: academic_document_title,
      date: I18n.l(date, format: :document), time: I18n.l(date, format: :time),
      situation: situation_translated }
  end

  def find_note_by_professor(professor)
    examination_board_notes.find_by(professor_id: professor.id)
  end

  def find_note_by_external_member(external_member)
    examination_board_notes.find_by(external_member_id: external_member.id)
  end

  def advisor?(professor)
    orientation.advisor.id == professor.id
  end

  def professor_evaluator?(professor)
    professors.find_by(id: professor.id).present? || advisor?(professor)
  end

  def external_member_evaluator?(external_member)
    external_members.find_by(id: external_member.id).present?
  end

  def evaluators_number
    advisor = 1
    professors.size + external_members.size + advisor
  end

  def all_evaluated?
    examination_board_notes.where.not(note: nil).size == evaluators_number || final_note.present?
  end

  def situation_translated
    I18n.t("enums.situation.#{situation}")
  end

  def appointments?
    examination_board_notes.where.not(appointment_file: nil)
                           .or(examination_board_notes.where.not(appointment_text: nil)).present?
  end

  def evaluators
    Logics::ExaminationBoard::EvaluatorsResponses.new(self)
  end

  # Callback to after_add and after_remove a professor or external member
  # Necessary to clear cache after add or remove a professor or external member
  def touch_updated_at(_attendee)
    # rubocop:disable Rails/SkipsModelValidations
    touch unless new_record?
    # rubocop:enable Rails/SkipsModelValidations
  end

  def confirm!
    update(confirmed: true)
    Notifications::Hooks::ExaminationBoard.confirmed_examination_board(self)
  end

  private

  def trigger_create_notifications
    Notifications::Hooks::ExaminationBoard.atendees_examination_board_assigned(self)
  end
end
