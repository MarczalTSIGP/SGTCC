class AddTitleToExternalMembers < ActiveRecord::Migration[5.2]
  change_table :external_members do |t|
    t.belongs_to :professor_title, index: true, foreign_key: true
  end
end
