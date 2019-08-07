class Professors::ExaminationBoardsController < Professors::BaseController
  before_action :set_examination_board, only: :show

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :professors_examination_boards_path

  def index
    data = current_professor.examination_boards(params[:term])
    @examination_boards = Kaminari.paginate_array(data).page(params[:page])
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, professors_examination_board_path
  end

  private

  def set_examination_board
    @examination_board = current_professor.guest_examination_boards
                                          .find(params[:id])
                                          .first
  end
end
