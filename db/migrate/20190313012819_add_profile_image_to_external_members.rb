class AddProfileImageToExternalMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :external_members, :profile_image, :string
  end
end
