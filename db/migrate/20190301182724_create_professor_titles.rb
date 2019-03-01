class CreateProfessorTitles < ActiveRecord::Migration[5.2]
  def change
    create_table :professor_titles do |t|
      t.string :name, unique:true
      t.string :abbr, unique: true
    end
  end
end
