class CreateOrientations < ActiveRecord::Migration[5.2]
  def change
    create_table :orientations do |t|
      t.string :title
      t.references :calendar, foreign_key: true
      t.references :academic, foreign_key: true
      t.references :advisor, foreign_key: { to_table: :professors }
      t.references :institution, foreign_key: true, null: true

      t.timestamps
    end
  end
end
