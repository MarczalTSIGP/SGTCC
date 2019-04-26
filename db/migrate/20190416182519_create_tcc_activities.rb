class CreateTccActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :tcc_activities do |t|
      t.string :name
      t.references :base_activity_type, foreign_key: true
      t.integer :tcc

      t.timestamps
    end
  end
end
