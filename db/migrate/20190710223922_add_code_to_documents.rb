class AddCodeToDocuments < ActiveRecord::Migration[5.2]
  change_table :documents, bulk: true do |t|
    t.string :code, index: true, unique: true
  end
end
