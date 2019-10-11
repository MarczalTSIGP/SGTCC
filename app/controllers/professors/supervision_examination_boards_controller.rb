class Professors::SupervisionExaminationBoardsController < Professors::BaseController
  before_action :set_examination_board, only: :show
  before_action :set_examination_board_note, only: :show
  before_action :set_can_edit_note, only: :show

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

  def set_examination_board_note
    @examination_board_note = @examination_board.find_note_by_professor(current_professor)
    @examination_board_note = ExaminationBoardNote.new if @examination_board_note.blank?
  end

  def set_can_edit_note
    @can_edit_note = true
    @can_edit_note = false if @examination_board.professor_evaluator_sign?(current_professor)
  end
end
