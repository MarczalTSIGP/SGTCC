class Logics::ExaminationBoard::EvaluatorsResponses
  def initialize(examination_board)
    @examination_board = examination_board
    map_evaluators
  end

  def size
    advisor = 1
    @size ||= @evaluators_responses.size + advisor
  end

  def all_evaluated?
    @examination_board.examination_board_notes.where.not(note: nil).size == size
  end

  def responses
    @evaluators_responses
  end

  private

  def map_evaluators
    @evaluators_responses = []
    map_professors
    map_external_members

    @evaluators_responses << new_evaluator_response(@examination_board.orientation.advisor)
  end

  def map_professors
    @examination_board.professors.each do |professor|
      @evaluators_responses << new_evaluator_response(professor)
    end
  end

  def map_external_members
    @examination_board.external_members.each do |external_member|
      @evaluators_responses << new_evaluator_response(external_member)
    end
  end

  def new_evaluator_response(evaluator)
    Logics::ExaminationBoard::EvaluatorResponse.new(evaluator,
                                                    @examination_board)
  end
end

class Logics::ExaminationBoard::EvaluatorResponse
  def initialize(evaluator, examination_board)
    @evaluator = evaluator
    @examination_board = examination_board
    @eb_note = examination_board.examination_board_notes.find_by(evaluator_condition)
  end

  attr_reader :evaluator

  def id
    "#{@examination_board.id}-#{@evaluator.id}"
  end

  def sent_note?
    @eb_note&.note != nil
  end

  def appointments_file?
    @eb_note&.appointment_file.present?
  end

  def appointments_file
    @eb_note.appointment_file
  end

  def appointments_text?
    @eb_note&.appointment_text.present?
  end

  def appointments_text
    @eb_note.appointment_text
  end

  private

  def evaluator_condition
    return { professor_id: @evaluator.id } if @evaluator.is_a?(Professor)

    { external_member_id: @evaluator.id }
  end
end
