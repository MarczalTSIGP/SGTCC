class UpdateExternalMemberSupervisorIdToOrientationSupervisors < ActiveRecord::Migration[5.2]
  def change
    change_table :orientation_supervisors do |t|
      t.remove_references :external_member_supervisor
      t.references :external_member_supervisor,
                   foreign_key: { to_table: :external_members },
                   null: true
    end
  end
end
