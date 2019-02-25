class AddNameAndUsernameToProfessor < ActiveRecord::Migration[5.2]
  def change
    change_table :professors, bulk: true do |t|
      t.column :username, :string, unique: true
      t.column :name, :string
    end

    add_index :professors, :username, unique: true
  end
end
