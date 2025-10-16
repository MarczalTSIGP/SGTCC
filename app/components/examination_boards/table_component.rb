# frozen_string_literal: true

class ExaminationBoards::TableComponent < ViewComponent::Base
  Badge = Struct.new(:type, :style)

  def initialize(examination_boards:, namespace:)
    @examination_boards = examination_boards
    @namespace = namespace
  end

  def show_path(examination_board)
    send("#{@namespace}_examination_board_path", examination_board)
  end

  def badge_html(examination_board)
    badge = badge_style(examination_board)

    content_tag(
      :span,
      "&nbsp;".html_safe,
      data: { controller: "tooltip" },
      title: examination_board.distance_of_date,
      class: "badge badge-pill badge-#{badge.type}"
    )
  end

  private

    def badge_style(examination_board)
      case examination_board.status
      when "today"
        Badge.new("today", "#0b9b1e")
      when "next"
        Badge.new("minutes", "#cccc0e")
      else
        Badge.new("passad", "#c1c1c1")
      end
    end

end