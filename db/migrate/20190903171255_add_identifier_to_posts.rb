class AddIdentifierToPosts < ActiveRecord::Migration[5.2]
  change_table :posts, bulk: true do |t|
    t.integer :identifier, null: true
  end
end
