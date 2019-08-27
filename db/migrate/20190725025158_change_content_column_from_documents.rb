class ChangeContentColumnFromDocuments < ActiveRecord::Migration[5.2]
  def change
    change_column_null(:documents, :content, true)
  end
end
