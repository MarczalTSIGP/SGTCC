class AddFaIconToPosts < ActiveRecord::Migration[5.2]
  change_table :posts, bulk: true do |t|
    t.string :fa_icon
  end
end
