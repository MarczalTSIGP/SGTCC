module ExaminationBoards
  # Situação de um avaliador em uma banca: se lançou a nota e os apontamentos.
  # Não delega ao avaliador (expõe `evaluator` e tem `id` próprio, usado pela view
  # para identificar o modal de apontamentos), por isso é Presenter e não Decorator.
  class EvaluatorResponsePresenter
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
end
