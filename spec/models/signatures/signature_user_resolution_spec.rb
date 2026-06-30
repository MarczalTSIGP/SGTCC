require 'rails_helper'

RSpec.describe Signature do
  describe '#user' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << described_class.all
    end

    context 'when returns the user of the signature' do
      let(:signatures) { orientation.signatures }

      let(:academic_signature) { signatures.where(user_type: :academic).first }
      let(:professor_signature) { signatures.where(user_type: :advisor).first }
      let(:external_member_signature) do
        signatures.where(user_type: :external_member_supervisor).first
      end

      it 'returns the Professor user' do
        professor = professor_signature.user
        expect(professor_signature.user).to eq(Professor.find(professor.id))
      end

      it 'returns the Academic user' do
        academic = academic_signature.user
        expect(academic_signature.user).to eq(Academic.find(academic.id))
      end

      it 'returns the External Member user' do
        external_member = external_member_signature.user
        expect(external_member_signature.user).to eq(ExternalMember.find(external_member.id))
      end
    end
  end
end
