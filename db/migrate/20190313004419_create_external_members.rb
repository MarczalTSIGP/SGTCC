class CreateExternalMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :external_members do |t|
      t.string :name
      t.string :email, unique: true
      t.boolean :is_active, default: false, null: false
      t.string :gender, limit: 1

      t.text :working_area

      t.timestamps
    end
  end
end
