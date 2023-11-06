class ExaminationBoard < ApplicationRecord
  require 'action_view'
  include ActionView::Helpers::DateHelper
  include ExaminationBoardDefenseMinutes
  include UsersToDocument
  include SituationEnum
  include TccIdentifier
  include Searchable
  include Tcc

  searchable place: { unaccent: true }, relationships: {
    orientation: { fields: [title: { unaccent: true }] }
  }

  belongs_to :orientation

  validates :place, presence: true
  validates :date, presence: true
  validates :identifier, presence: true
  validates :document_available_until, presence: true

  has_many :examination_board_attendees, dependent: :delete_all
  has_many :examination_board_notes, dependent: :delete_all

  has_many :professors, class_name: 'Professor', foreign_key: :professor_id,
                        through: :examination_board_attendees, dependent: :destroy

  has_many :external_members, class_name: 'ExternalMember', foreign_key: :external_member_id,
                              through: :examination_board_attendees, dependent: :destroy

  scope :tcc_one, -> { where(tcc: Calendar.tccs[:one]) }
  scope :tcc_two, -> { where(tcc: Calendar.tccs[:two]) }

  scope :current_semester, -> { where('date >= ?', Calendar.start_date) }
  scope :recent, -> { order(date: :desc) }

  scope :with_relationships, lambda {
    includes(orientation: [:academic, :calendars, { advisor: [:scholarity] }])
  }

  scope :site_with_relationships, lambda {
    includes(external_members: [:scholarity], professors: [:scholarity],
             orientation: [:academic, :orientation_supervisors, :professor_supervisors,
                           :external_member_supervisors, { advisor: [:scholarity] }]).recent
  }

  def self.cs_asc_from_now_desc_ago
    ebs_from_now = where('date >= ?', Date.current).order(date: :asc)
    ebs_ago = where('date >= ? AND date < ?', Calendar.start_date, Date.current).order(date: :desc)
    ebs_from_now.site_with_relationships + ebs_ago.site_with_relationships
  end

  def status
    current_date = Date.current.to_s
    board_date = Date.parse(date.to_s).to_s
    return 'today' if board_date == current_date

    board_date > current_date ? 'next' : 'occurred'
  end

  def distance_of_date
    i18n = 'views.tables.examination_board'
    board_date = I18n.l(date, format: :datetime)
    return I18n.t("#{i18n}.today", time: I18n.l(date, format: :time)) if status == 'today'

    distance_of_time = distance_of_time_in_words(board_date, Time.current)
    I18n.t("#{i18n}.#{status}", distance: distance_of_time)
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
    { id: id, evaluators: evaluators_object, document_title: academic_document_title,
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

  def evaluators_size(advisor_size: 1)
    advisor_size + professors.size + external_members.size
  end

  def number_to_evaluate
    evaluators_size - examination_board_notes.size
  end

  def examination_board_notes_by_others(filter_id)
    examination_board_notes.where.not(professor_id: filter_id)
                           .or(examination_board_notes.where.not(external_member_id: filter_id))
  end

  def professor_and_external_members_ids
    professor_ids = examination_board_notes.pluck(:professor_id).flatten.compact.uniq
    external_member_ids = examination_board_notes.pluck(:external_member_id).flatten.compact.uniq
    [professor_ids, external_member_ids]
  end

  def members_that_not_send_appointments(filter_id)
    professor_ids, external_member_ids = professor_and_external_members_ids
    professor_ids << filter_id
    external_member_ids << filter_id
    members = {
      professors: professors.where.not(id: professor_ids),
      external_members: external_members.where.not(id: external_member_ids)
    }
    members.values.flatten
  end
end
