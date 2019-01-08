class CreateAcademics < ActiveRecord::Migration[5.2]
  def change
    create_table :academics do |t|
      t.string :name
      t.string :email
      t.integer :ra
      t.string :gender, limit: 1

      t.timestamps
    end
  end
end
