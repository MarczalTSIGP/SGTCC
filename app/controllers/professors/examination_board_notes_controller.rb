class Professors::ExaminationBoardNotesController < Professors::BaseController
  before_action :set_examination_board, only: [:create, :update]
  before_action :set_examination_board_note, only: :update
  before_action :can_edit_note, only: [:create, :update]

  def create
    @examination_board_note = ExaminationBoardNote.new(examination_board_note_params)
    @examination_board_note.validate_note = true;


    if @examination_board_note.save
      feminine_success_create_message
      redirect_to professors_examination_board_path(@examination_board)
    else
      error_message
      render 'professors/examination_boards/show'
    end
  end

  def update
    @examination_board_note.validate_note = true;

    if @examination_board_note.update(examination_board_note_params)
      feminine_success_update_message
      redirect_to professors_examination_board_path(@examination_board)
    else
      error_message
      render 'professors/examination_boards/show'
    end
  end

  private

  def set_examination_board
    @examination_board = ExaminationBoard.with_relationships.find(params[:id])
  end

  def set_examination_board_note
    @examination_board_note = @examination_board.examination_board_notes.find(params[:note_id])
  end

  def examination_board_note_params
    params.require(:examination_board_note).permit(:note, :professor_id, :examination_board_id)
  end

  def can_edit_note
    @can_edit_note = true
    return if @examination_board.defense_minutes.blank?

    @can_edit_note = false
    flash[:alert] = I18n.t('flash.examination_board_note.errors.edit')
    redirect_to professors_examination_board_path(@examination_board)
  end
end
