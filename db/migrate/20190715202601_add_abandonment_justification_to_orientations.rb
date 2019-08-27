class AddAbandonmentJustificationToOrientations < ActiveRecord::Migration[5.2]
  change_table :orientations, bulk: true do |t|
    t.text :abandonment_justification, null: true
  end
end
