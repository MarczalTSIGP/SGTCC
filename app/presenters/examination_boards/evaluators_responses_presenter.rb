module ExaminationBoards
  # Situação de todos os avaliadores de uma banca, na ordem exibida:
  # professores, membros externos e, por fim, o orientador.
  class EvaluatorsResponsesPresenter
    def initialize(examination_board)
      @examination_board = examination_board
      map_evaluators
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
      EvaluatorResponsePresenter.new(evaluator, @examination_board)
    end
  end
end
