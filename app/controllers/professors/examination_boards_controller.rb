class Professors::ExaminationBoardsController < Professors::BaseController
  before_action :set_examination_board, only: [:show, :minutes]
  before_action :set_orientation, only: :minutes

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

  def minutes
    data_params = { orientation_id: @orientation.id }

    document = DocumentType.find_by(identifier: @examination_board.minutes_type)
                           .documents.create!(data_params)

    render json: document.id
  end

  private

  def set_examination_board
    @examination_board = ExaminationBoard.with_relationships.find(params[:id])
  end

  def set_orientation
    @orientation = @examination_board.orientation
  end
end
