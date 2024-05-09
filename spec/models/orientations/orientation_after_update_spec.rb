require 'rails_helper'

RSpec.describe Orientation do
  before do
    create(:document_type_tco)
    create(:document_type_tcai)
  end

  describe '#after_update' do
    let(:orientation) { create(:orientation) }
    let!(:tco_id) { orientation.tco.id }
    let!(:tcai_id) { orientation.tcai.id }

    context 'when tcc one with no defense minutes' do
      it 'recreate tco and tcai' do
        orientation.update!(title: 'New title')

        expect(orientation.tco.id).not_to eq(tco_id)
        expect(orientation.tcai).not_to eq(tcai_id)
      end

      it 'recreate tco and tcai can not be nil' do
        orientation.update(title: 'New title')

        expect(orientation.tco).not_to be_nil
        expect(orientation.tcai).not_to be_nil
      end
    end

    context 'when tcc one with defense minutes' do
      before do
        create(:document_type_adpp)
        create(:document_type_adpj)
        create(:document_type_admg)
      end

      it 'not recreate tco and tcai with adpp' do
        eb = create(:proposal_examination_board, orientation:)
        eb.create_defense_minutes

        orientation.update(title: 'New title')

        expect(orientation.tco.id).to eq(tco_id)
        expect(orientation.tcai.id).to eq(tcai_id)
      end

      it 'not recreate tco and tcai with adpj' do
        eb = create(:project_examination_board, orientation:)
        eb.create_defense_minutes

        orientation.update(title: 'New title')

        expect(orientation.tco.id).to eq(tco_id)
        expect(orientation.tcai.id).to eq(tcai_id)
      end

      it 'not recreate tco and tcai with admg' do
        eb = create(:monograph_examination_board, orientation:)
        eb.create_defense_minutes

        orientation.update(title: 'New title')

        expect(orientation.tco.id).to eq(tco_id)
        expect(orientation.tcai.id).to eq(tcai_id)
      end
    end
  end
end
