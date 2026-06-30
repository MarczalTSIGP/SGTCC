require 'rails_helper'

RSpec.describe Academic do
  describe '#documents_signed' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    before do
      orientation.signatures.find_by(user_type: :academic).sign
    end

    it 'returns the signed documents' do
      conditions = { user_id: academic.id, user_type: 'AC', status: true }
      documents = Document.joins(:signatures).where(signatures: conditions)
      expect(academic.documents_signed).to match_array(documents)
    end
  end

  describe '#documents_pending' do
    let(:orientation) { create(:orientation) }
    let(:academic) { orientation.academic }

    it 'returns the pending documents' do
      conditions = { user_id: academic.id, user_type: 'AC', status: false }
      documents = Document.joins(:signatures).where(signatures: conditions)
      expect(academic.documents_pending).to match_array(documents)
    end
  end
end
