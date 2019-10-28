class AddSituationToExaminationBoards < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE TYPE examination_board_situations AS ENUM ('approved', 'reproved', 'not_appear', 'under_evaluation');
      ALTER TABLE examination_boards ADD situation examination_board_situations DEFAULT 'under_evaluation';
    SQL
  end

  def down
    remove_column :examination_boards, :situation
    execute <<-SQL
      DROP TYPE examination_board_situations;
    SQL
  end
end
