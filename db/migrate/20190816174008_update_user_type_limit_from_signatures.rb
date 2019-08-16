class UpdateUserTypeLimitFromSignatures < ActiveRecord::Migration[5.2]
  def change
    change_column :signatures, :user_type, :string, limit: 3
  end
end
