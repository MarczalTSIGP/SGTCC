require 'rails_helper'

RSpec.describe ExternalMember do
  subject(:em) { build(:external_member) }

  describe '#current_supervision_tcc_one' do
    let(:external_member) { create(:external_member) }
    let(:orientation_tcc_one) { create(:orientation, :current, :tcc_one) }

    it 'returns the current supervision by tcc one' do
      orientation_tcc_one.external_member_supervisors << external_member
      expect(external_member.current_supervision_tcc_one).to eq(orientation_tcc_one)
    end
  end

  describe '#current_supervision_tcc_two' do
    let(:external_member) { create(:external_member) }
    let(:orientation_tcc_two) { create(:orientation, :current, :tcc_two) }

    it 'returns the current supervision by tcc two' do
      orientation_tcc_two.external_member_supervisors << external_member
      expect(external_member.current_supervision_tcc_two).to eq(orientation_tcc_two)
    end
  end
end
