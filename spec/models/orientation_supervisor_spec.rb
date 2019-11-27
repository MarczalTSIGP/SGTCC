require 'rails_helper'

RSpec.describe OrientationSupervisor, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }

    it 'is expected to belongs to' do
      is_expected.to belong_to(:professor_supervisor).with_foreign_key('professor_supervisor_id')
    end

    it 'is expected to belong to' do
      external_member_fk = 'external_member_supervisor_id'
      is_expected.to belong_to(:external_member_supervisor).with_foreign_key(external_member_fk)
    end

    it { is_expected.to have_many(:examination_boards).through(:orientation) }
  end
end
