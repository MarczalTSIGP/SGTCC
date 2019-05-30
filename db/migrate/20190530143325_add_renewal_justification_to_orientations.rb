class AddRenewalJustificationToOrientations < ActiveRecord::Migration[5.2]
  change_table :orientations, bulk: true do |t|
    t.text :renewal_justification, null: true
  end
end
