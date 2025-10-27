class CreateNotificationTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :notification_templates do |t|
      t.string  :title, null: false
      t.string :key, null: false, index: { unique: true }
      t.string :subject, null: false
      t.text :body, null: false
      t.string :channel, null: false, default: 'email'
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
