class AddDocumentAvailableUntilToExaminationBoards < ActiveRecord::Migration[5.2]
  def up
    unless column_exists?(:examination_boards, :document_available_until)
      add_column :examination_boards, :document_available_until, :timestamp
    end

    execute <<-SQL.squish
      UPDATE examination_boards
      SET document_available_until = date
    SQL
  end

  def down
    return unless column_exists?(:examination_boards, :document_available_until)

    remove_column :examination_boards, :document_available_until
  end
end
