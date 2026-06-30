require 'rails_helper'

RSpec.describe Orientation do
  subject(:orientation) { described_class.new }

  describe '#cancel' do
    context 'when the orientation is cancelled' do
      let(:orientation) { create(:orientation) }

      it 'is status equal cancelled' do
        orientation.cancel('Justification')
        orientation.reload
        expect(orientation.status).to eq('cancelada')
      end
    end
  end
end
