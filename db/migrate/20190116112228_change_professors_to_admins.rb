class ChangeProfessorsToAdmins < ActiveRecord::Migration[5.2]
  def change
    rename_table :professors, :admins
  end
end
