require 'rails_helper'

RSpec.describe Signature do
  describe '#user' do
    describe '#user_table' do
      let(:orientation) { create(:orientation) }
      let(:signatures) { orientation.signatures }

      before do
        orientation.signatures << described_class.all
      end

      it 'returns the Academic table' do
        academic_signature = signatures.find_by(user_type: :academic)
        expect(academic_signature.user_table).to eq(Academic)
      end

      it 'returns the ExternalMember table' do
        external_member_signature = signatures.find_by(user_type: :external_member_supervisor)
        expect(external_member_signature.user_table).to eq(ExternalMember)
      end

      it 'returns the Professor table when the user is advisor' do
        signature = signatures.find_by(user_type: :advisor)
        expect(signature.user_table).to eq(Professor)
      end

      it 'returns the Professor table when the user is professor supervisor' do
        signature = signatures.find_by(user_type: :professor_supervisor)
        expect(signature.user_table).to eq(Professor)
      end
    end
  end
end
