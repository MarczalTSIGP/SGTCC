class CreateAttachedDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :attached_documents do |t|
      t.string :name
      t.string :file

      t.timestamps
    end
  end
end
