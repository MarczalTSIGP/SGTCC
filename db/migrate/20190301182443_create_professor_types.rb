class CreateProfessorTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :professor_types do |t|
      t.string :name, unique: true
      t.timestamps
    end
  end
end
