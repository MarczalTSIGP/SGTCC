module ExaminationBoards
  class Destroy
    Result = Data.define(:status) do
      def destroyed?
        status == :destroyed
      end

      def blocked_by_defense_minutes?
        status == :blocked_by_defense_minutes
      end

      def failed?
        status == :failed
      end
    end

    def self.call(examination_board)
      new(examination_board).call
    end

    def initialize(examination_board)
      @examination_board = examination_board
    end

    def call
      return Result.new(status: :blocked_by_defense_minutes) if defense_minutes?

      examination_board.destroy

      Result.new(status: examination_board.destroyed? ? :destroyed : :failed)
    end

    private

    attr_reader :examination_board

    def defense_minutes?
      examination_board.defense_minutes.present?
    end
  end
end
