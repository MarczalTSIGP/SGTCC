class AddSidebarToSites < ActiveRecord::Migration[5.2]
  change_table :sites, bulk: true do |t|
    t.json :sidebar, null: true
  end
end
