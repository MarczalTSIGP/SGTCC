require 'rails_helper'

RSpec.describe Document do
  describe '#all_signed?' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns true' do
      before do
        orientation.signatures.each(&:sign)
      end

      let(:document) { orientation.signatures.first.document }

      it 'returns true' do
        expect(document.all_signed?).to be(true)
      end
    end

    context 'when returns false' do
      let(:document) { orientation.signatures.first.document }

      it 'returns false' do
        expect(document.all_signed?).to be(false)
      end
    end
  end

  describe '#signature_by_user' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic:) }
    let(:document) { described_class.first }

    context 'when returns the pending signature' do
      let(:pending_signature) do
        document.signatures.find_by(user_id: academic.id,
                                    user_type: :academic,
                                    status: false)
      end

      it 'returns the pending signature' do
        expect(document.signature_by_user(academic.id, :academic)).to eq(pending_signature)
      end
    end

    context 'when returns the signed signature' do
      let(:signed_signature) do
        document.signatures.find_by(user_id: academic.id,
                                    user_type: :academic,
                                    status: true)
      end

      let(:academic_signature) do
        orientation.signatures.find_by(user_id: academic.id,
                                       user_type: :academic)
      end

      before do
        document.signatures.each(&:sign)
      end

      it 'returns the signed signature' do
        expect(document.signature_by_user(academic.id, :academic)).to eq(signed_signature)
      end
    end
  end

  describe '#academic_signed?' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic:) }
    let!(:document) { create(:document_tep, orientation_id: orientation.id) }

    context 'when the document is not signed' do
      it 'returns false' do
        expect(document.academic_signed?(academic)).to be(false)
      end
    end

    context 'when the document is signed' do
      before do
        document.signatures.each(&:sign)
      end

      it 'returns true' do
        expect(document.academic_signed?(academic)).to be(true)
      end
    end
  end

  describe '#professor_signed?' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

    context 'when the document is not signed' do
      it 'returns false' do
        expect(document.professor_signed?(professor)).to be(false)
      end
    end

    context 'when the document is signed' do
      before do
        document.signatures.each(&:sign)
      end

      it 'returns true' do
        expect(document.professor_signed?(professor)).to be(true)
      end
    end
  end
end
