class AddIdentifierToRoles < ActiveRecord::Migration[5.2]
  def change
    change_table :roles, bulk: true do |t|
      t.text :identifier
    end

    add_index :roles, :identifier, unique: true
  end
end
