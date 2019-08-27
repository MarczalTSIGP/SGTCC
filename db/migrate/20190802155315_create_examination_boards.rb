class CreateExaminationBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :examination_boards do |t|
      t.timestamp :date
      t.string :place
      t.references :orientation, foreign_key: true

      t.timestamps
    end
  end
end
