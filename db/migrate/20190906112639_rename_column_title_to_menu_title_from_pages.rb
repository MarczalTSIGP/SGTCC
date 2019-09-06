class RenameColumnTitleToMenuTitleFromPages < ActiveRecord::Migration[5.2]
  def change
    rename_column :pages, :title, :menu_title
  end
end
