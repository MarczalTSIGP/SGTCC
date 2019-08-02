class Responsible::ExaminationBoardsController < Responsible::BaseController
  before_action :set_examination_board, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :responsible_examination_boards_path

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.show'),
                 :responsible_examination_board_path,
                 only: [:show]

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.new'),
                 :new_responsible_examination_board_path,
                 only: [:new]

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.edit'),
                 :edit_responsible_examination_board_path,
                 only: [:edit]

  def index
    @examination_boards = ExaminationBoard.page(params[:page]).order(created_at: :desc)
  end

  def show; end

  def new
    @examination_board = ExaminationBoard.new
  end

  def edit; end

  def create
    @examination_board = ExaminationBoard.new(examination_board_params)

    if @examination_board.save
      feminine_success_create_message
      redirect_to responsible_examination_boards_path
    else
      error_message
      render :new
    end
  end

  def update
    if @examination_board.update(examination_board_params)
      feminine_success_update_message
      redirect_to responsible_examination_board_path(@examination_board)
    else
      error_message
      render :edit
    end
  end

  def destroy
    @examination_board.destroy
    feminine_success_destroy_message

    redirect_to responsible_examination_boards_path
  end

  private

  def set_examination_board
    @examination_board = ExaminationBoard.find(params[:id])
  end

  def examination_board_params
    params.require(:examination_board).permit(:place, :date, :orientation_id)
  end
end
