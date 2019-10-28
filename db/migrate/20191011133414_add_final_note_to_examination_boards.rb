class AddFinalNoteToExaminationBoards < ActiveRecord::Migration[5.2]
  change_table :examination_boards, bulk: true do |t|
    t.integer :final_note, null: true
  end
end
