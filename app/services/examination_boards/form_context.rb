module ExaminationBoards
  class FormContext
    TCC_ONE_ACTIVITIES = :human_tcc_one_identifiers
    TCC_TWO_ACTIVITIES = :human_tcc_two_identifiers

    attr_reader :examination_board

    def self.for_new(tcc:)
      new(tcc:)
    end

    def self.for_board(examination_board)
      new(examination_board:)
    end

    def initialize(tcc: nil, examination_board: nil)
      @examination_board = examination_board || build_examination_board(tcc)
      @tcc = tcc&.to_s&.to_sym
    end

    def orientations
      tcc_two? ? Orientation.current_tcc_two : Orientation.current_tcc_one
    end

    def activities
      Activity.public_send(tcc_two? ? TCC_TWO_ACTIVITIES : TCC_ONE_ACTIVITIES)
    end

    def disabled_field?
      examination_board&.defense_minutes.present?
    end

    private

    attr_reader :tcc

    def build_examination_board(tcc)
      return ExaminationBoard.new(identifier: :monograph) if tcc.to_s.to_sym == :two

      ExaminationBoard.new
    end

    def tcc_two?
      return true if tcc == :two

      examination_board&.monograph?
    end
  end
end
