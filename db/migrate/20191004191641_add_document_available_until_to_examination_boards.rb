class AddDocumentAvailableUntilToExaminationBoards < ActiveRecord::Migration[5.2]
  change_table :examination_boards, bulk: true do |t|
    t.timestamp :document_available_until
  end
end
