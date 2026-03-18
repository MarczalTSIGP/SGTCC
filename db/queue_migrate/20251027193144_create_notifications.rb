class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, index: true, null: false

      t.string :event_key
      t.string :notification_type, null: false
      t.text :data, default: '{}'
      t.datetime :sent_at
      t.integer :attempts, default: 0, null: false
      t.integer :max_attempts, default: 3, null: false
      t.string :status, default: 'pending' # pending, sent, failed
      t.datetime :scheduled_at
      t.datetime :last_attempted_at

      t.timestamps
    end
  end
end
