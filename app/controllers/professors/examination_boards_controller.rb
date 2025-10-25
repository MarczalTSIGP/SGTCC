class Professors::ExaminationBoardsController < Professors::BaseController
  before_action :set_examination_board, only: [:show,
                                               :defense_minutes,
                                               :non_attendance_defense_minutes]
  before_action :set_examination_board_note, only: :show
  before_action :set_can_edit_note, only: :show

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

  def defense_minutes
    respond_to do |format|
      if @examination_board.defense_minutes.present?
        flash.now[:sweet_error] = I18n.t('json.messages.defense_minutes.existent')
        format.turbo_stream { render 'shared/sweet_alert' }
        format.json { render json: { message: I18n.t('json.messages.defense_minutes.existent'), status: :error } }
      elsif !@examination_board.all_evaluated?
        flash.now[:sweet_error] = I18n.t('json.messages.defense_minutes.not_evaluated')
        format.turbo_stream { render 'shared/sweet_alert' }
        format.json { render json: { message: I18n.t('json.messages.defense_minutes.not_evaluated'), status: :error } }
      else
        @examination_board.create_defense_minutes
        flash.now[:sweet_success] = I18n.t('json.messages.defense_minutes.success')
        format.turbo_stream
        format.json { render json: { message: I18n.t('json.messages.defense_minutes.success'), status: :success, id: @examination_board.defense_minutes.id } }
      end
    end
  end

  def non_attendance_defense_minutes
    respond_to do |format|
      if @examination_board.defense_minutes.present?
        flash.now[:sweet_error] = I18n.t('json.messages.defense_minutes.existent')
        format.turbo_stream { render 'shared/sweet_alert' }
        format.json { render json: { message: I18n.t('json.messages.defense_minutes.existent'), status: :error } }
      else
        @examination_board.create_non_attendance_defense_minutes
        flash.now[:sweet_success] = I18n.t('json.messages.defense_minutes.success')
        format.turbo_stream
        format.json { render json: { message: I18n.t('json.messages.defense_minutes.success'), status: :success, id: @examination_board.defense_minutes.id } }
      end
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
