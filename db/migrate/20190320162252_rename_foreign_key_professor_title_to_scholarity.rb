class RenameForeignKeyProfessorTitleToScholarity < ActiveRecord::Migration[5.2]
  def change
    rename_column :professors, :professor_title_id, :scholarity_id
    rename_column :external_members, :professor_title_id, :scholarity_id
  end
end
