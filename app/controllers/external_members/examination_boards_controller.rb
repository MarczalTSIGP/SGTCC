class ExternalMembers::ExaminationBoardsController < ExternalMembers::BaseController
  before_action :set_examination_board, only: :show
  before_action :set_examination_board_note, only: :show

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :external_members_examination_boards_path

  def index
    @examination_boards = current_external_member.examination_boards
                                                 .current_semester
                                                 .search(params[:term])
                                                 .page(params[:page])
                                                 .order(:tcc, created_at: :desc)
                                                 .with_relationships
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, external_members_examination_board_path
  end

  private

  def set_examination_board
    @examination_board = current_external_member.examination_boards
                                                .with_relationships
                                                .find(params[:id])
  end

  def set_examination_board_note
    @examination_board_note = @examination_board.find_note_by_external_member(
      current_external_member
    )
    @examination_board_note = ExaminationBoardNote.new if @examination_board_note.blank?
  end
end
