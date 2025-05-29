class AddDocumentAvailableUntilToExaminationBoards < ActiveRecord::Migration[5.2]
  def up
    add_column :examination_boards, :document_available_until, :timestamp

    execute <<-SQL.squish
      UPDATE examination_boards
      SET document_available_until = date
    SQL
  end

  def down
    remove_column :examination_boards, :document_available_until
  end
end
