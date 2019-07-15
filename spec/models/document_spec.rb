require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:document_type) }
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
  end

  describe '#all_signed?' do
    let(:document) { create(:document) }

    context 'when returns true' do
      let(:signature_signed) { create(:signature_signed) }

      before do
        document.signatures << signature_signed
      end

      it 'returns true' do
        expect(document.all_signed?).to eq(true)
      end
    end

    context 'when returns false' do
      let(:signature) { create(:signature) }

      before do
        document.signatures << signature
      end

      it 'returns false' do
        expect(document.all_signed?).to eq(false)
      end
    end
  end

  describe '#after_create' do
    let(:document) { create(:document) }

    it 'returns the code with Timestamps and document id' do
      code = Time.now.to_i + document.id
      expect(document.code).to eq(code.to_s)
    end
  end
end
