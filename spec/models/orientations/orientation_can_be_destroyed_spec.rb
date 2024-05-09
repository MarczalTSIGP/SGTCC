require 'rails_helper'

RSpec.describe Orientation do
  describe '#can_be_destroyed?' do
    let(:orientation) { create(:orientation) }

    context 'with true' do
      it 'when none sign the documents' do
        expect(orientation.can_be_destroyed?).to be(true)
      end

      it 'the document is signed but the proposal defense minute is no generate' do
        orientation.signatures << Signature.all
        orientation.signatures.each(&:sign)

        expect(orientation.can_be_destroyed?).to be(true)
      end
    end

    context 'with false' do
      before do
        create(:document_type_adpp)
        create(:document_type_adpj)
        create(:document_type_admg)
      end

      it 'when the proposal defense minute is generated' do
        eb = create(:proposal_examination_board, orientation:)
        eb.create_defense_minutes

        expect(orientation.can_be_destroyed?).to be(false)
      end

      it 'when the project defense minute is generated' do
        eb = create(:project_examination_board, orientation:)
        eb.create_defense_minutes

        expect(orientation.can_be_destroyed?).to be(false)
      end

      it 'when the monograpth defense minute is generated' do
        eb = create(:monograph_examination_board, orientation:)
        eb.create_defense_minutes

        expect(orientation.can_be_destroyed?).to be(false)
      end
    end
  end
end
