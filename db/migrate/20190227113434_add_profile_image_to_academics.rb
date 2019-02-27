class AddProfileImageToAcademics < ActiveRecord::Migration[5.2]
  def change
    add_column :academics, :profile_image, :string
  end
end
