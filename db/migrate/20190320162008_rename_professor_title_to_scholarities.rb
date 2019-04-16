class RenameProfessorTitleToScholarities < ActiveRecord::Migration[5.2]
  def change
    rename_table :professor_titles, :scholarities
  end
end
