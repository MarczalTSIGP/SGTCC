class ExternalMembers::ExaminationBoardsController < ExternalMembers::BaseController
  before_action :set_examination_board, only: :show
  before_action :set_examination_board_note, only: :show
  before_action :set_can_edit_note, only: :show

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :external_members_examination_boards_path

  def index
    @examination_boards = current_external_member
                          .examination_boards
                          .search(params[:term])
                          .page(params[:page])
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, external_members_examination_board_path
  end

  private

  def set_examination_board
    @examination_board = current_external_member
                         .examination_boards
                         .with_relationships
                         .find_by(id: params[:id])
    return if @examination_board.present?

    @examination_board = current_external_member
                         .supervision_examination_boards
                         .with_relationships
                         .find_by(id: params[:id])
  end

  def set_examination_board_note
    @examination_board_note = @examination_board.find_note_by_external_member(
      current_external_member
    )
    @examination_board_note = ExaminationBoardNote.new if @examination_board_note.blank?
  end

  def set_can_edit_note
    @can_edit_note = true
    @can_edit_note = false if @examination_board.defense_minutes.present?
  end
end
