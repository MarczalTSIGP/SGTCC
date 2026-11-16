class CreateExaminationBoardNotificationStates < ActiveRecord::Migration[8.1]
  def change
    create_table :examination_board_notification_states do |t|
      t.bigint :examination_board_id, null: false, index: { unique: true }
      t.jsonb :snapshot
      t.jsonb :targets, null: false, default: {}
      t.integer :revision, null: false, default: 0
      t.timestamps
    end
  end
end
