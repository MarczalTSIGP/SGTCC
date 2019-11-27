class Academics::ExaminationBoardsController < Academics::BaseController
  before_action :set_examination_board, only: :show

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :academics_examination_boards_path

  def index
    @examination_boards = current_academic.examination_boards
                                          .search(params[:term])
                                          .page(params[:page])
                                          .order(:tcc, date: :desc)
                                          .with_relationships
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, academics_examination_board_path
  end

  private

  def set_examination_board
    @examination_board = current_academic.examination_boards
                                         .with_relationships
                                         .includes(examination_board_notes: [:professor,
                                                                             :external_member])
                                         .find(params[:id])
  end
end
