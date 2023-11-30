class CreateSignatures < ActiveRecord::Migration[5.2]
  def change
    create_table :signatures do |t|
      t.references :orientation, foreign_key: true
      t.references :document, foreign_key: true
      t.integer :user_id
      t.string :user_type, limit: 2
      t.boolean :status, default: false, null: false

      t.timestamps
    end
  end
end
