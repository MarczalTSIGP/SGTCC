module ExaminationBoards
  class StatusPresenter
    include ActionView::Helpers::DateHelper

    def initialize(examination_board)
      @board = examination_board
    end

    def status
      current_date = Date.current.to_s
      board_date = Date.parse(@board.date.to_s).to_s
      return 'today' if board_date == current_date

      board_date > current_date ? 'next' : 'occurred'
    end

    def distance_of_date
      i18n = 'views.tables.examination_board'
      board_date = I18n.l(@board.date, format: :datetime)
      return I18n.t("#{i18n}.today", time: I18n.l(@board.date, format: :time)) if status == 'today'

      distance_of_time = distance_of_time_in_words(board_date, Time.current)
      I18n.t("#{i18n}.#{status}", distance: distance_of_time)
    end
  end
end
