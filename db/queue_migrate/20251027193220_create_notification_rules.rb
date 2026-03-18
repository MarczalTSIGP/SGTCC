class CreateNotificationRules < ActiveRecord::Migration[7.2]
  def change
    create_table :notification_rules do |t|
      t.references :notification_template, null: false, foreign_key: true
      t.integer :days_before, default: 0, null: false
      t.integer :max_retries, default: 1, null: false
      t.integer :hours_before, default: 0, null: false
      t.integer :hours_after, default: 0, null: false
      t.integer :retry_interval_hours, default: 0, null: false
      t.string :extra_notes

      t.timestamps
    end
  end
end
