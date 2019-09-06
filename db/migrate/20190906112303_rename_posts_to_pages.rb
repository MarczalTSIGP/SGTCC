class RenamePostsToPages < ActiveRecord::Migration[5.2]
  def change
    rename_table :posts, :pages
  end
end
