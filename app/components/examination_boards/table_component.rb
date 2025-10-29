# frozen_string_literal: true

class ExaminationBoards::TableComponent < ViewComponent::Base
  Badge = Struct.new(:type, :style)

  renders_one :tabs

  def initialize(examination_boards:, namespace:, path_helper: nil)
    @examination_boards = examination_boards
    @namespace = namespace
    @path_helper = path_helper
  end

  def show_path(examination_board)
    if @path_helper
      send(@path_helper, examination_board)
    else
      send("#{@namespace}_examination_board_path", examination_board)
    end
  end

  def edit_path(examination_board)
    send("edit_#{@namespace}_examination_board_path", examination_board)
  end

  def actions(examination_board)
    return '' unless [:responsible, :tcc_one_professors].include?(@namespace)

    edit_link(examination_board) + ' '.html_safe + delete_link(examination_board)
  end

  def edit_link(examination_board)
    helpers.link_to(edit_path(examination_board)) do
      helpers.content_tag(:i, '', class: 'fe fe-edit', data: { controller: 'ui--tooltip' },
                                  title: I18n.t('titles.edit'))
    end
  end

  def delete_link(examination_board)
    delete_options = {
      data: { turbo_method: :delete, turbo_confirm: I18n.t('prompt.confirm') },
      class: 'destroy'
    }
    helpers.link_to(show_path(examination_board), delete_options) do
      helpers.content_tag(:i, '', class: 'fe fe-trash', data: { controller: 'ui--tooltip' },
                                  title: I18n.t('titles.delete'))
    end
  end

  def confirm_button(examination_board)
    return '' unless @namespace == :responsible

    if examination_board.confirm?
      helpers.content_tag(:button, 'Banca Confirmada',
                          class: 'btn btn-primary w-100',
                          disabled: true)
    else
      helpers.button_to(
        helpers.responsible_examination_boards_confirm_path(examination_board),
        method: :patch,
        class: 'btn btn-outline-primary w-100',
        data: { turbo_stream: true, turbo_confirm: 'Deseja confirmar esta banca?' }
      ) do
        '✓ Confirmar Banca'
      end
    end
  end

  def badge_html(examination_board)
    badge = badge_style(examination_board)

    content_tag(
      :span,
      '&nbsp;'.html_safe,
      data: { controller: 'tooltip' },
      title: examination_board.distance_of_date,
      class: "badge badge-pill badge-#{badge.type}"
    )
  end

  private

  def badge_style(examination_board)
    case examination_board.status
    when 'today'
      Badge.new('today', '#0b9b1e')
    when 'next'
      Badge.new('minutes', '#cccc0e')
    else
      Badge.new('passad', '#c1c1c1')
    end
  end
end
