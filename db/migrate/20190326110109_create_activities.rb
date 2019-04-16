class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.string :name, unique: true
      t.references :activity_type, foreign_key: true

      t.timestamps
    end
  end
end
