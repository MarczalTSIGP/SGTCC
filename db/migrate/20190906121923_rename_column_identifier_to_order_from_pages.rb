class RenameColumnIdentifierToOrderFromPages < ActiveRecord::Migration[5.2]
  def change
    rename_column :pages, :identifier, :order
  end
end
