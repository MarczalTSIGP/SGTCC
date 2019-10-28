class Professors::SupervisionExaminationBoardsController < Professors::BaseController
  before_action :set_examination_board, only: :show

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :professors_supervision_examination_boards_path

  def index
    data = current_professor.current_semester_supervision_examination_boards
    @examination_boards = data.page(params[:page])
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, professors_supervision_examination_board_path(@examination_board)
  end

  private

  def set_examination_board
    @examination_board = ExaminationBoard.with_relationships.find(params[:id])
  end
end
