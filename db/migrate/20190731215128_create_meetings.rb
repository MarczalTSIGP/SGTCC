class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.string :title
      t.text :content
      t.references :orientation, foreign_key: true

      t.timestamps
    end
  end
end
