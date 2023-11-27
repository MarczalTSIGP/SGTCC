class Professors::ExaminationBoardsController < Professors::BaseController
  before_action :set_examination_board, only: [:show,
                                               :defense_minutes,
                                               :non_attendance_defense_minutes]
  before_action :set_examination_board_note, only: :show
  before_action :set_can_edit_note, only: :show

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.index'),
                 :professors_examination_boards_path

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.one.index'),
                 :responsible_examination_boards_tcc_one_path,
                 only: :tcc_one

  add_breadcrumb I18n.t('breadcrumbs.examination_boards.tcc.two.index'),
                 :responsible_examination_boards_tcc_two_path,
                 only: :tcc_two

  def index
    redirect_to action: :tcc_one
  end

  def tcc_one
    data = current_professor.examination_boards_by_tcc_one_list(params[:page],
                                                                params[:term],
                                                                params[:status])
    @examination_boards = Kaminari.paginate_array(data).page(params[:page])
    @search_url = professors_examination_boards_tcc_one_search_path
    render :index
  end

  def tcc_two
    data = current_professor.examination_boards_by_tcc_two_list(params[:page],
                                                                params[:term],
                                                                params[:status])
    @examination_boards = Kaminari.paginate_array(data).page(params[:page])
    @search_url = professors_examination_boards_tcc_two_search_path
    render :index
  end

  def show
    @title = I18n.t("breadcrumbs.examination_boards.tcc.#{@examination_board.tcc}.show")
    add_breadcrumb @title, professors_examination_board_path
  end

  def defense_minutes
    if @examination_board.defense_minutes.present?
      render json: { message: I18n.t('json.messages.defense_minutes.existent'), status: :error }
    elsif !@examination_board.all_evaluated?
      render json: { message: I18n.t('json.messages.defense_minutes.not_evaluated'),
                     status: :error }
    else
      document = @examination_board.create_defense_minutes
      render json: { message: I18n.t('json.messages.defense_minutes.success'),
                     status: :success, id: document.id }
    end
  end

  def non_attendance_defense_minutes
    if @examination_board.defense_minutes.present?
      render json: { message: I18n.t('json.messages.defense_minutes.existent'), status: :error }
    else
      document = @examination_board.create_non_attendance_defense_minutes
      render json: { message: I18n.t('json.messages.defense_minutes.success'),
                     status: :success, id: document.id }
    end
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
    @can_edit_note = false if @examination_board.defense_minutes.present?
  end
end
