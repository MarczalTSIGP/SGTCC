class AddDeviseToExternalMembers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :external_members, bulk: true do |t|
      ## Database authenticatable
      t.string :encrypted_password, null: true

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at
    end

    add_index :external_members, :reset_password_token, unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
