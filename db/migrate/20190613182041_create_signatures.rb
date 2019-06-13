class CreateSignatures < ActiveRecord::Migration[5.2]
  def change
    create_table :signatures do |t|
      t.references :orientation, foreign_key: true
      t.references :document, foreign_key: true
      t.integer :user_id
      t.string :user_type, limit: 1
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
