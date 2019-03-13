class AddExternalMemberTypeToExternalMembers < ActiveRecord::Migration[5.2]
  def change
    add_reference :external_members, :external_member_type, foreign_key: true
  end
end
