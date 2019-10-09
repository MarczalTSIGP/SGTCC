class AddDocumentAvailableUntilToExaminationBoards < ActiveRecord::Migration[5.2]
  change_table :examination_boards, bulk: true do |t|
    t.timestamp :document_available_until
  end

  ExaminationBoard.all.each do |examination_board|
    examination_board.update(document_available_until: examination_board.date)
  end
end
