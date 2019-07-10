class AddSignatureCodeIdToDocuments < ActiveRecord::Migration[5.2]
  change_table :documents do |t|
    t.belongs_to :signature_code, index: true, foreign_key: true
  end
end
