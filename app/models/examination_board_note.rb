class ExaminationBoardNote < ApplicationRecord
  belongs_to :examination_board
  belongs_to :professor, optional: true
  belongs_to :external_member, optional: true

  mount_uploader :appointment_file, FileUploader

  validates :note,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 100 }

  after_save do
    if examination_board.all_evaluated? || !examination_board.available_defense_minutes?
      examination_board.update(situation: status(final_note),
                               final_note: final_note)
    end
  end

  private

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
