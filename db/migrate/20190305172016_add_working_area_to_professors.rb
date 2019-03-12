class AddWorkingAreaToProfessors < ActiveRecord::Migration[5.2]
  change_table :professors, bulk: true do |t|
    t.text :working_area
  end
end
