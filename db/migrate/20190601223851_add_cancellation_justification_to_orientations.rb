class AddCancellationJustificationToOrientations < ActiveRecord::Migration[5.2]
  change_table :orientations, bulk: true do |t|
    t.text :cancellation_justification, null: true
  end
end
