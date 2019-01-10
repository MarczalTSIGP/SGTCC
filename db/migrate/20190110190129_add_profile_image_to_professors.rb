class AddProfileImageToProfessors < ActiveRecord::Migration[5.2]
  def change
    add_column :professors, :profile_image, :string
  end
end
