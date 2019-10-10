class Professors::ExaminationBoardsController < Professors::BaseController
  before_action :set_examination_board, only: [:show, :minutes]
  before_action :set_examination_board_note, only: :show

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
    return if @examination_board.defense_minutes.present?
    document = @examination_board.create_defense_minutes

    render json: document.id
  end

  private

  def set_examination_board
    @examination_board = ExaminationBoard.with_relationships.find(params[:id])
  end

  def set_examination_board_note
    @examination_board_note = @examination_board.find_note_by_professor(current_professor)
    @examination_board_note = ExaminationBoard.new if @examination_board_note.blank?
  end
end
