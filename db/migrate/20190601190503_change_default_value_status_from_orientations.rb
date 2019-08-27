class ChangeDefaultValueStatusFromOrientations < ActiveRecord::Migration[5.2]
  change_column_default(:orientations, :status, 'IN_PROGRESS')
end
