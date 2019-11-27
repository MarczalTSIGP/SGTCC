class AddIdentifierToExaminationBoards < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE examination_board_identifiers AS ENUM ('proposal', 'project', 'monograph');
      ALTER TABLE examination_boards ADD identifier examination_board_identifiers;
    SQL
  end

  def down
    remove_column :examination_boards, :identifier
    execute <<-SQL
      DROP TYPE examination_board_identifiers;
    SQL
  end
end
