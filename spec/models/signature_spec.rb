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
end
