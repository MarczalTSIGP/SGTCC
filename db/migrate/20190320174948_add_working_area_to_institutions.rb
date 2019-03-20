class AddWorkingAreaToInstitutions < ActiveRecord::Migration[5.2]
  change_table :institutions, bulk: true do |t|
    t.text :working_area, null: true
  end
end
