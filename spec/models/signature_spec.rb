require 'rails_helper'

RSpec.describe Signature, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to belong_to(:document) }
  end

  describe '#sign' do
    let(:signature) { create(:signature) }

    it 'returns the new status of the signature' do
      signature.sign
      expect(signature.status).to eq(true)
    end
  end

  describe '#by_professor_and_status' do
    let(:professor) { create(:professor) }
    let(:signature) { create(:signature, user_id: professor.id) }

    it 'returns the signature by professor and status' do
      signatures = Signature.where(user_id: professor.id, user_type: 'P', status: false)
      expect(Signature.by_professor_and_status(professor, false)).to eq(signatures)
    end
  end

  describe '#by_external_member_and_status' do
    let(:external_member) { create(:external_member) }
    let(:signature) { create(:signature, user_id: external_member.id) }

    it 'returns the signature by external_member and status' do
      signatures = Signature.where(user_id: external_member.id, user_type: 'E', status: false)
      expect(Signature.by_external_member_and_status(external_member, false)).to eq(signatures)
    end
  end

  describe '#by_academic_and_status' do
    let(:academic) { create(:academic) }
    let(:signature) { create(:signature, user_id: academic.id) }

    it 'returns the signature by academic and status' do
      signatures = Signature.where(user_id: academic.id, user_type: 'A', status: false)
      expect(Signature.by_academic_and_status(academic, false)).to eq(signatures)
    end
  end
end
