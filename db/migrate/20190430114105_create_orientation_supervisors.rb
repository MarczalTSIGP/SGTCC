class CreateOrientationSupervisors < ActiveRecord::Migration[5.2]
  def change
    create_table :orientation_supervisors do |t|
      t.references :orientation, foreign_key: true
      t.references :professor_supervisor, foreign_key: { to_table: :professors }, null: true
      t.references :external_member_supervisor, foreign_key: { to_table: :professors }, null: true

      t.timestamps
    end
  end
end
