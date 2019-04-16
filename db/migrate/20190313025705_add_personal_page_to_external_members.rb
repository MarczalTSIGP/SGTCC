class AddPersonalPageToExternalMembers < ActiveRecord::Migration[5.2]
  change_table :external_members, bulk: true do |t|
    t.string :personal_page, null: true
  end
end
