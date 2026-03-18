class AddConfirmToExaminationBoards < ActiveRecord::Migration[7.2]
  def change
    add_column :examination_boards, :confirmed, :boolean, default: false, null: false
  end
end
