class CreateExaminationBoardAttendees < ActiveRecord::Migration[5.2]
  def change
    create_table :examination_board_attendees do |t|
      t.references :examination_board, foreign_key: true
      t.references :professor, foreign_key: true, null: true
      t.references :external_member, foreign_key: true, null: true

      t.timestamps
    end
  end
end
