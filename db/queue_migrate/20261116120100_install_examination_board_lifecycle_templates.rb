class InstallExaminationBoardLifecycleTemplates < ActiveRecord::Migration[8.1]
  def up
    Notifications::ExaminationBoards::Templates.install!
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
