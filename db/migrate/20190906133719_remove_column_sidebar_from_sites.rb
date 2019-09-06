class RemoveColumnSidebarFromSites < ActiveRecord::Migration[5.2]
  def up
    remove_column :sites, :sidebar
  end

  def down
    add_column :sites, :sidebar, :json
  end
end
