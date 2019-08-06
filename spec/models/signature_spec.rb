require 'rails_helper'

RSpec.describe Signature, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to belong_to(:document) }
  end

  describe '#sign' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    it 'returns the new status of the signature' do
      signature = orientation.signatures.first
      signature.sign
      expect(signature.status).to eq(true)
    end
  end

  describe '#document_filename' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns the filename' do
      let(:signature) { orientation.signatures.first }

      it 'returns the document file_name' do
        document_type = signature.document.document_type.identifier
        academic_name = I18n.transliterate(orientation.academic.name.tr(' ', '_'))
        calendar = orientation.calendar.year_with_semester.tr('/', '_')
        document_filename = "SGTCC_#{document_type}_#{academic_name}_#{calendar}".upcase
        expect(signature.document_filename).to eq(document_filename)
      end
    end
  end

  describe '#term_of_commitement?' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns if is the term of commitment' do
      let(:signature_tco) { orientation.signatures.first }
      let(:signature_tcai) { orientation.signatures.last }

      it 'returns true' do
        expect(signature_tco.term_of_commitment?).to eq(true)
      end

      it 'returns false' do
        expect(signature_tcai.term_of_commitment?).to eq(false)
      end
    end
  end

  describe '#term_of_accept_institution?' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns if is the term of accept institution' do
      let(:signature_tco) { orientation.signatures.first }
      let(:signature_tcai) { orientation.signatures.last }

      it 'returns true' do
        expect(signature_tcai.term_of_accept_institution?).to eq(true)
      end

      it 'returns false' do
        expect(signature_tco.term_of_accept_institution?).to eq(false)
      end
    end
  end

  describe '#confirm' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when professor confirm' do
      let(:signature) { orientation.signatures.where(user_type: :advisor).first }
      let(:professor) { signature.user }
      let(:params) { { login: professor.username, password: 'password' } }

      it 'returns true if the professors login is correct' do
        expect(signature.confirm(professor, professor.username, params)). to eq(true)
      end

      it 'returns false if the professors login is not correct' do
        params = { login: professor.username, password: '231' }
        expect(signature.confirm(professor, professor.username, params)). to eq(false)
      end
    end

    context 'when academic confirm' do
      let(:signature) { orientation.signatures.where(user_type: :academic).first }
      let(:academic) { signature.user }
      let(:params) { { login: academic.ra, password: 'password' } }

      it 'returns true if the academics login is correct' do
        expect(signature.confirm(academic, academic.ra, params)). to eq(true)
      end

      it 'returns false if the academics login is not correct' do
        params = { login: academic.ra, password: '231' }
        expect(signature.confirm(academic, academic.ra, params)). to eq(false)
      end
    end

    context 'when external member confirm' do
      let(:signature) do
        orientation.signatures.where(user_type: :external_member_supervisor).first
      end
      let(:external_member) { signature.user }
      let(:params) { { login: external_member.email, password: 'password' } }

      it 'returns true if the external member login is correct' do
        expect(signature.confirm(external_member, external_member.email, params)). to eq(true)
      end

      it 'returns false if the external member login is not correct' do
        params = { login: external_member.email, password: '231' }
        expect(signature.confirm(external_member, external_member.email, params)). to eq(false)
      end
    end
  end

  describe '#confirm_and_sign' do
    let(:orientation) { create(:orientation) }
    let(:signature) { orientation.signatures.where(user_type: :advisor).first }
    let(:professor) { signature.user }
    let(:params) { { login: professor.username, password: 'password' } }

    it 'returns true for the confirm and sign' do
      expect(signature.confirm_and_sign(professor, professor.username, params)). to eq(true)
      expect(signature.status). to eq(true)
    end

    it 'returns false if the confirm and sign' do
      params = { login: professor.username, password: '231' }
      expect(signature.confirm_and_sign(professor, professor.username, params)). to eq(false)
      expect(signature.status). to eq(false)
    end
  end

  describe '#user' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns the user of the signature' do
      let(:signatures) { orientation.signatures }

      let(:academic_signature) { signatures.where(user_type: :academic).first }
      let(:professor_signature) { signatures.where(user_type: :advisor).first }
      let(:external_member_signature) do
        signatures.where(user_type: :external_member_supervisor).first
      end

      let(:professor) { professor_signature.user }
      let(:academic) { academic_signature.user }
      let(:external_member) { external_member_signature.user }

      it 'returns the Professor user' do
        expect(professor_signature.user).to eq(Professor.find(professor.id))
      end

      it 'returns the Academic user' do
        expect(academic_signature.user).to eq(Academic.find(academic.id))
      end

      it 'returns the External Member user' do
        expect(external_member_signature.user).to eq(ExternalMember.find(external_member.id))
      end
    end

    describe '#user_table' do
      let(:orientation) { create(:orientation) }
      let(:signatures) { orientation.signatures }

      before do
        orientation.signatures << Signature.all
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
