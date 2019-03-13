class CreateExternalMemberTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :external_member_types do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end
