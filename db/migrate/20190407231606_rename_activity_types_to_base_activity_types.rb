class RenameActivityTypesToBaseActivityTypes < ActiveRecord::Migration[5.2]
  def change
    rename_table :activity_types, :base_activity_types
  end
end
