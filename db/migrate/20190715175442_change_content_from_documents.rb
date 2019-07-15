class ChangeContentFromDocuments < ActiveRecord::Migration[5.2]
  def change
    change_column :documents, :content, 'json USING CAST(content AS json)'
  end
end
