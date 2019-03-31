class AddIdentifierToRoles < ActiveRecord::Migration[5.2]
  change_table :roles, bulk: true do |t|
    t.text :identifier, unique: true, index: true
  end
end
