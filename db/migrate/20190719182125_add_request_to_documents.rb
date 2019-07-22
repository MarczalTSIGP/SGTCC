class AddRequestToDocuments < ActiveRecord::Migration[5.2]
  change_table :documents, bulk: true do |t|
    t.json :request, null: true
  end
end
