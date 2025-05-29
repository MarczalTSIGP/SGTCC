class AddCodeToDocuments < ActiveRecord::Migration[5.2]
  def change
    change_table :documents, bulk: true do |t|
      t.string :code
    end

    add_index :documents, :code, unique: true
  end
end
