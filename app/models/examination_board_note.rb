class ExaminationBoardNote < ApplicationRecord
  belongs_to :examination_board
  belongs_to :professor, optional: true
  belongs_to :external_member, optional: true

  attr_accessor :validate_note

  mount_uploader :appointment_file, AppointmentFileUploader

  validates :note,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100 },
            allow_nil: true

  after_save do
    if examination_board.all_evaluated? || !examination_board.available_defense_minutes?
      status = status(final_note)
      examination_board.update(situation: status, final_note: final_note)

      if status.eql?(:approved) &&
         examination_board.identifier.eql?(ExaminationBoard.identifiers[:project])
        status = 'APPROVED_TCC_ONE'
      end

      if examination_board.identifier != ExaminationBoard.identifiers[:proposal]
        # rubocop:disable Rails/SkipsModelValidations
        examination_board.orientation.update_column(:status, status.to_s.upcase)
        # rubocop:enable Rails/SkipsModelValidations
      end
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
    examination_board.examination_board_notes.sum(&:note) / evaluators_number
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
