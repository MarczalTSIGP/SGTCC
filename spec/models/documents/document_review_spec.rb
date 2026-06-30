require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe Document do
  describe '#tdo_for_review?' do
    let!(:professor) { create(:responsible) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

    context 'when the advisor not signed' do
      it 'returns false' do
        expect(document.tdo_for_review?).to be(false)
      end
    end

    context 'when the advisor already signed' do
      let(:advisor_signature) { document.signatures.find_by(user_type: :advisor) }

      before do
        advisor_signature.sign
      end

      it 'returns true' do
        expect(document.tdo_for_review?).to be(true)
      end
    end
  end

  describe '#tep_for_review?' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic:) }
    let!(:document) { create(:document_tep, orientation_id: orientation.id) }

    context 'when the academic not signed' do
      it 'returns false' do
        expect(document.tep_for_review?).to be(false)
      end
    end

    context 'when the academic already signed' do
      let(:signatures) { document.signatures }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }

      before do
        academic_signature.sign
      end

      it 'returns true' do
        expect(document.tep_for_review?).to be(true)
      end
    end
  end

  describe '#tso_for_review?' do
    let!(:advisor) { create(:professor) }
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic:) }
    let(:new_orientation) do
      { advisor: { id: advisor.id, name: advisor.name },
        professorSupervisors: {},
        externalMemberSupervisors: {} }
    end

    let(:request) do
      { requester: { justification: 'just' }, new_orientation: }
    end

    let!(:document) do
      create(:document_tso, orientation_id: orientation.id,
                            request:, advisor_id: advisor.id)
    end

    context 'when the academic not signed' do
      it 'returns false' do
        expect(document.tso_for_review?).to be(false)
      end
    end

    context 'when the academic signed' do
      let(:signatures) { document.signatures }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }

      before do
        academic_signature.sign
      end

      it 'returns true' do
        expect(document.tso_for_review?).to be(true)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
