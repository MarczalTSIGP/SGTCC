class RemoveAbandonmentJustificationFromOrientations < ActiveRecord::Migration[5.2]
  def up
    remove_column :orientations, :abandonment_justification
  end

  def down
    add_column :orientations, :abandonment_justification, :text
  end
end
