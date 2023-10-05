class AddAppointmentTextToExaminationBoardNotes < ActiveRecord::Migration[5.2]
  def change
    add_column :examination_board_notes, :appointment_text, :text
  end
end
