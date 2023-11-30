class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.text :content
      t.timestamp :date
      t.boolean :viewed, default: false, null: false
      t.references :orientation, foreign_key: true

      t.timestamps
    end
  end
end
