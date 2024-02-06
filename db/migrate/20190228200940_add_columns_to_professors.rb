class AddColumnsToProfessors < ActiveRecord::Migration[5.2]
  change_table :professors, bulk: true do |t|
    t.string :lattes
    t.string :gender, limit: 1
    t.boolean :is_active, default: false, null: false
    t.boolean :available_advisor, default: false, null: false
  end
end
