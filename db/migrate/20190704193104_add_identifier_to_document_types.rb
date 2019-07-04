class AddIdentifierToDocumentTypes < ActiveRecord::Migration[5.2]
  change_table :document_types, bulk: true do |t|
    t.text :identifier, unique: true, index: true
  end
end
