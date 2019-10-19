class Professors::ExaminationBoardFilesController < Professors::BaseController
  before_action :set_examination_board, only: [:create, :update]
  before_action :set_examination_board_note, only: :update
  before_action :can_edit_note, only: [:create, :update]

  def create
    @examination_board_note = ExaminationBoardNote.new(examination_board_note_params)

    if @examination_board_note.save
      success_create_message
      redirect_to professors_examination_board_path(@examination_board)
    else
      error_message
      render 'professors/examination_boards/show'
    end
  end

  def update
    if @examination_board_note.update(examination_board_note_params)
      success_update_message
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
    params.require(:examination_board_note)
          .permit(:appointment_file, :appointment_file_cache,
                  :professor_id, :examination_board_id)
  end

  def model_human
    ExaminationBoardNote.human_attribute_name('appointment_file')
  end

  def can_edit_note
    @can_edit_note = true
    return if @examination_board.defense_minutes.blank?
    @can_edit_note = false
  end
end
