class CreateProfessorRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :professor_roles do |t|
      t.string :name, unique: true
    end
  end
end
