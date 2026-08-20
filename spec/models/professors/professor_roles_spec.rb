require 'rails_helper'

RSpec.describe Professor do
  subject(:professor) { described_class.new }

  describe '#role?' do
    let(:responsible) { create(:responsible) }

    it 'returns true if the professor has role' do
      expect(responsible.role?('responsible')).to be(true)
    end

    it 'returns false if the professor has not role' do
      expect(responsible.role?('tcc_one')).to be(false)
    end
  end

  describe '#current_responsible' do
    before do
      create(:responsible)
    end

    it 'is equal current responsible' do
      responsible = described_class.joins(:roles).find_by('roles.identifier': :responsible)
      expect(described_class.current_responsible).to eq(responsible)
    end
  end

  describe '#current_coordinator' do
    before do
      create(:coordinator)
    end

    it 'is equal current coordinator' do
      coordinator = described_class.joins(:roles).find_by('roles.identifier': :coordinator)
      expect(described_class.current_coordinator).to eq(coordinator)
    end
  end

  describe '#responsible?' do
    let(:responsible) { create(:responsible) }
    let(:professor) { create(:professor) }

    it 'returns true' do
      expect(responsible.responsible?).to be(true)
    end

    it 'returns false' do
      expect(professor.responsible?).to be(false)
    end
  end

  describe '#effective' do
    let(:professor_type) { create(:professor_type, name: 'Efetivo') }
    let(:professor) { create(:professor, professor_type:) }

    it 'returns the effective professors' do
      expect(described_class.effective).to eq([professor])
    end
  end

  describe '#temporary' do
    let(:professor_type) { create(:professor_type, name: 'Temporário') }
    let(:professor) { create(:professor, professor_type:) }

    it 'returns the temporary professors' do
      expect(described_class.temporary).to eq([professor])
    end
  end
end
