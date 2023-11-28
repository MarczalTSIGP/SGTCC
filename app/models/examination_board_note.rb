class ExaminationBoardNote < ApplicationRecord
  belongs_to :examination_board
  belongs_to :professor, optional: true
  belongs_to :external_member, optional: true

  mount_uploader :appointment_file, AppointmentFileUploader

  validates :note,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 100
            },
            allow_nil: true

  after_save do
    if examination_board.all_evaluated? && examination_board.defense_minutes.blank?
      tcc_type = examination_board.identifier
      approved = final_note >= 60
      status = approved ? :approved : :reproved

      case tcc_type
      when 'proposal'
        orientation_status = approved ? 'IN_PROGRESS' : 'REPROVED_TCC_ONE'
      when 'project'
        orientation_status = approved ? 'APPROVED_TCC_ONE' : 'REPROVED_TCC_ONE'
      when 'monograph'
        orientation_status = approved ? 'APPROVED' : 'REPROVED'
      end

      examination_board.update(situation: status, final_note: final_note)
      examination_board.orientation.update(status: orientation_status)
    end
  end

  def evaluator
    professor || external_member
  end

  def appointment_filename(orientation: examination_board.orientation)
    calendar = orientation.current_calendar.year_with_semester.tr('/', '_')
    identifier = I18n.t("enums.tcc.identifiers.#{examination_board.identifier}")
    academic_initials = name_initials(orientation.academic.name)
    evaluator_initials = name_initials(evaluator.name)
    "GP_COINT_#{calendar}_#{identifier}_#{academic_initials}_APONTAMENTOS_#{evaluator_initials}"
      .upcase
  end

  private

  def name_initials(complete_name)
    complete_name.split.map { |name| name[0, 1] }.join
  end

  def final_note
    examination_board.examination_board_notes.where.not(note: nil).sum(&:note) / evaluators_number
  end

  def status(final_note)
    final_note >= 60 ? :approved : :reproved
  end

  def professor_evaluators_number
    professor_evaluators = examination_board.professors.select do |professor|
      examination_board.find_note_by_professor(professor).present?
    end
    professor_evaluators.size
  end

  def external_member_evaluators_number
    external_member_evaluators = examination_board.external_members.select do |external_member|
      examination_board.find_note_by_external_member(external_member).present?
    end
    external_member_evaluators.size
  end

  def evaluators_number(advisor_evaluator_number: 1)
    professor_evaluators_number + external_member_evaluators_number + advisor_evaluator_number
  end
end
