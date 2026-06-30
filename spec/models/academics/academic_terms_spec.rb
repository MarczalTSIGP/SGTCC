require 'rails_helper'

RSpec.describe Academic do
  describe '#tsos' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      create(:document_type_tso)
    end

    it 'returns the tsos' do
      tsos = academic.documents([true, false], DocumentType.tso.first)
      expect(academic.tsos).to match_array(tsos)
    end
  end

  describe '#teps' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      create(:document_type_tep)
    end

    it 'returns the teps' do
      teps = academic.documents([true, false], DocumentType.tep.first)
      expect(academic.teps).to match_array(teps)
    end
  end
end
