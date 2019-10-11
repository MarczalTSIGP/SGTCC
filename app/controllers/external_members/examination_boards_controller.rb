class ExternalMembers::ExaminationBoardsController < ExternalMembers::BaseController
  before_action :set_examination_board, only: :show
  before_action :set_examination_board_note, only: :show
  before_action :set_can_edit_note, only: :show

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :external_members_examination_boards_path

  def index
    data = current_external_member.current_examination_boards(params[:term])
    @examination_boards = Kaminari.paginate_array(data).page(params[:page])
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, external_members_examination_board_path
  end

  private

  def set_examination_board
    @examination_board = current_semester(current_external_member.examination_boards)
    return if @examination_board.present?
    @examination_board = current_semester(current_external_member.supervision_examination_boards)
  end

  def current_semester(data)
    return if data.blank?
    data.current_semester.with_relationships.find(params[:id])
  end

  def set_examination_board_note
    @examination_board_note = @examination_board.find_note_by_external_member(
      current_external_member
    )
    @examination_board_note = ExaminationBoardNote.new if @examination_board_note.blank?
  end

  def set_can_edit_note
    @can_edit_note = true

    @can_edit_note = false if @examination_board.external_member_evaluator_sign?(
      current_external_member
    )
  end
end
