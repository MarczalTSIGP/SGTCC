require 'rails_helper'

RSpec.describe Orientations::TcoTcaiService do
  before do
    create(:document_type_tco) if DocumentType.tco.empty?
    create(:document_type_tcai) if DocumentType.tcai.empty?
  end

  describe '.create' do
    let(:orientation) { create(:orientation) }

    it 'creates a TCO document for the orientation' do
      expect(orientation.tco).not_to be_nil
    end

    it 'creates a TCAI document when institution is present' do
      expect(orientation.tcai).not_to be_nil
    end

    it 'does not create TCAI when institution is absent' do
      orientation_without_institution = create(:orientation)
      # Must bypass callbacks: a normal update would fire the after_update
      # recreate callback and destroy/recreate tco/tcai before this test's
      # own destroy_document call, defeating the point of the test.
      # rubocop:disable Rails/SkipsModelValidations
      orientation_without_institution.update_columns(institution_id: nil)
      # rubocop:enable Rails/SkipsModelValidations
      orientation_without_institution.destroy_document(orientation_without_institution.tcai)
      orientation_without_institution.reload

      described_class.create(orientation_without_institution)

      expect(orientation_without_institution.reload.tcai).to be_nil
    end
  end

  describe '.recreate' do
    let(:orientation) { create(:orientation) }

    context 'when orientation is TCC one and can be edited' do
      it 'destroys and recreates TCO and TCAI' do
        old_tco_id = orientation.tco.id
        old_tcai_id = orientation.tcai.id

        described_class.recreate(orientation)

        expect(orientation.reload.tco.id).not_to eq(old_tco_id)
        expect(orientation.reload.tcai.id).not_to eq(old_tcai_id)
      end
    end

    context 'when orientation cannot be edited' do
      before do
        create(:document_type_adpp)
        create(:document_type_adpj)
        create(:document_type_admg)
        eb = create(:examination_board, :proposal, orientation:)
        eb.create_defense_minutes
      end

      it 'does not recreate TCO and TCAI' do
        old_tco_id = orientation.tco.id

        described_class.recreate(orientation)

        expect(orientation.reload.tco.id).to eq(old_tco_id)
      end
    end

    context 'when orientation is TCC two' do
      let(:orientation) { create(:orientation, :tcc_two, :approved_tcc_one) }

      it 'does not recreate TCO and TCAI' do
        old_tco_id = orientation.tco.id

        described_class.recreate(orientation)

        expect(orientation.reload.tco.id).to eq(old_tco_id)
      end
    end
  end
end
