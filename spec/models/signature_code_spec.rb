require 'rails_helper'

RSpec.describe SignatureCode, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_uniqueness_of(:code) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
  end

  describe '#all_signed?' do
    let(:signature_code) { create(:signature_code) }

    context 'when returns true' do
      let(:signature_signed) { create(:signature_signed) }

      before do
        signature_code.signatures << signature_signed
      end

      it 'returns true' do
        expect(signature_code.all_signed?).to eq(true)
      end
    end

    context 'when returns false' do
      let(:signature) { create(:signature) }

      before do
        signature_code.signatures << signature
      end

      it 'returns false' do
        expect(signature_code.all_signed?).to eq(false)
      end
    end
  end
end
