require 'rails_helper'

RSpec.describe ExternalMember do
  subject(:em) { build(:external_member) }

  describe '#documents_signed' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }

    before do
      orientation.signatures.find_by(user_type: :external_member_supervisor).sign
    end

    it 'returns the signed documents' do
      conditions = { user_id: external_member.id, user_type: 'ES', status: true }
      documents = Document.joins(:signatures).where(signatures: conditions)
      expect(external_member.documents_signed).to match_array(documents)
    end
  end

  describe '#documents_pending' do
    let(:orientation) { create(:orientation) }
    let(:external_member) { orientation.external_member_supervisors.first }

    it 'returns the pending documents' do
      conditions = { user_id: external_member.id, user_type: 'ES', status: false }
      documents = Document.joins(:signatures).where(signatures: conditions)
      expect(external_member.documents_pending).to match_array(documents)
    end
  end
end
