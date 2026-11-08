require 'rails_helper'

RSpec.describe Orientations::EditabilityPolicy do
  subject(:policy) { described_class.new(orientation) }

  let(:orientation) { create(:orientation) }

  describe '#editable?' do
    context 'when no protected documents exist' do
      it { is_expected.to be_editable }
    end

    context 'when a proposal defense minute exists' do
      before do
        create(:document_type_adpp)
        eb = create(:examination_board, :proposal, orientation:)
        eb.create_defense_minutes
      end

      it { is_expected.not_to be_editable }
    end

    context 'when a project defense minute exists' do
      before do
        create(:document_type_adpj)
        eb = create(:examination_board, :project, orientation:)
        eb.create_defense_minutes
      end

      it { is_expected.not_to be_editable }
    end

    context 'when a monograph defense minute exists' do
      before do
        create(:document_type_admg)
        eb = create(:examination_board, :monograph, orientation:)
        eb.create_defense_minutes
      end

      it { is_expected.not_to be_editable }
    end
  end

  describe '#destroyable?' do
    it 'delegates to editable?' do
      expect(policy.destroyable?).to eq(policy.editable?)
    end
  end
end
