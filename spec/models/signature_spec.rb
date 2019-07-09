require 'rails_helper'

RSpec.describe Signature, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:orientation) }
    it { is_expected.to belong_to(:document) }
  end

  describe '#sign' do
    let(:signature) { create(:signature) }

    it 'returns the new status of the signature' do
      signature.sign
      expect(signature.status).to eq(true)
    end
  end

  describe '#term_of_commitement?' do
    let(:document_type) { create(:document_type_tco) }
    let(:document_type_tcai) { create(:document_type_tcai) }
    let(:document_tcai) { create(:document, document_type: document_type_tcai) }
    let(:document) { create(:document, document_type: document_type) }
    let(:signature_tco) { create(:signature, document: document) }
    let(:signature) { create(:signature, document: document_tcai) }

    it 'returns true' do
      expect(signature_tco.term_of_commitment?).to eq(true)
    end

    it 'returns false' do
      expect(signature.term_of_commitment?).to eq(false)
    end
  end

  describe '#term_of_accept_institution?' do
    let(:document_type) { create(:document_type_tcai) }
    let(:document_type_tco) { create(:document_type_tco) }
    let(:document_tco) { create(:document, document_type: document_type_tco) }
    let(:document) { create(:document, document_type: document_type) }
    let(:signature_tcai) { create(:signature, document: document) }
    let(:signature) { create(:signature, document: document_tco) }

    it 'returns true' do
      expect(signature_tcai.term_of_accept_institution?).to eq(true)
    end

    it 'returns false' do
      expect(signature.term_of_accept_institution?).to eq(false)
    end
  end

  describe '#confirm' do
    context 'when professor confirm' do
      let!(:signature) { create(:signature) }
      let!(:professor) { create(:professor) }
      let(:params) { { login: professor.username, password: professor.password } }

      it 'returns true if the professors login is correct' do
        expect(signature.confirm(Professor, 'username', params)). to eq(true)
      end

      it 'returns false if the professors login is not correct' do
        params = { login: professor.username, password: '231' }
        expect(signature.confirm(Professor, 'username', params)). to eq(false)
      end
    end

    context 'when academic confirm' do
      let!(:signature) { create(:signature) }
      let!(:academic) { create(:academic) }
      let(:params) { { login: academic.ra, password: academic.password } }

      it 'returns true if the academics login is correct' do
        expect(signature.confirm(Academic, 'ra', params)). to eq(true)
      end

      it 'returns false if the academics login is not correct' do
        params = { login: academic.ra, password: '231' }
        expect(signature.confirm(Academic, 'ra', params)). to eq(false)
      end
    end

    context 'when external member confirm' do
      let!(:signature) { create(:signature) }
      let!(:external_member) { create(:external_member) }
      let(:params) { { login: external_member.email, password: external_member.password } }

      it 'returns true if the external member login is correct' do
        expect(signature.confirm(ExternalMember, 'email', params)). to eq(true)
      end

      it 'returns false if the external member login is not correct' do
        params = { login: external_member.email, password: '231' }
        expect(signature.confirm(ExternalMember, 'email', params)). to eq(false)
      end
    end
  end

  describe '#confirm_and_sign' do
    let!(:signature) { create(:signature) }
    let!(:professor) { create(:professor) }
    let(:params) { { login: professor.username, password: professor.password } }

    it 'returns true for the confirm and sign' do
      expect(signature.confirm_and_sign(Professor, 'username', params)). to eq(true)
      expect(signature.status). to eq(true)
    end

    it 'returns false if the confirm and sign' do
      params = { login: professor.username, password: '231' }
      expect(signature.confirm_and_sign(Professor, 'username', params)). to eq(false)
      expect(signature.status). to eq(false)
    end
  end

  describe '#user' do
    let!(:academic) { create(:academic) }
    let!(:professor) { create(:professor) }
    let!(:external_member) { create(:external_member) }
    let!(:academic_signature) { create(:academic_signature, user_id: academic.id) }
    let!(:professor_signature) { create(:signature, user_id: professor.id) }
    let!(:external_member_signature) do
      create(:external_member_signature, user_id: external_member.id)
    end

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
    it 'returns the Academic table' do
      academic_signature = create(:academic_signature)
      expect(academic_signature.user_table).to eq(Academic)
    end

    it 'returns the ExternalMember table' do
      external_member_signature = create(:external_member_signature)
      expect(external_member_signature.user_table).to eq(ExternalMember)
    end

    context 'when returns the Professor table' do
      it 'returns the Professor table when the user is advisor' do
        signature = create(:signature)
        expect(signature.user_table).to eq(Professor)
      end

      it 'returns the Professor table when the user is professor supervisor' do
        signature = create(:professor_supervisor_signature)
        expect(signature.user_table).to eq(Professor)
      end
    end
  end

  describe '#by_orientation_and_document_t' do
    let(:document_type) { create(:document_type_tco) }
    let(:document) { create(:document, document_type: document_type) }
    let(:signature_tco) { create(:signature, document: document) }
    let(:signature) { create(:signature) }

    it 'returns the result by condition and document type' do
      orientation_id = signature.orientation.id
      result = Signature.joins(:document).where(orientation_id: orientation_id,
                                                documents: { document_type_id: document_type.id })

      signature_by_condition = Signature.by_orientation_and_document_t(
        orientation_id, document_type.id
      )
      expect(signature_by_condition).to match_array(result)
    end
  end

  describe '#status_table' do
    let!(:document_type) { create(:document_type_tco) }
    let!(:document) { create(:document, document_type: document_type) }
    let!(:professor) { create(:professor) }
    let!(:signature) { create(:signature, document: document, user_id: professor.id) }

    it 'returns the status table' do
      signatures = Signature.joins(:document)
                            .where(orientation_id: signature.orientation.id,
                                   documents: { document_type_id: document_type.id })
      result = signatures.map do |signature|
        { name: signature.user.name, status: signature.status }
      end
      signature_status_table = Signature.status_table(signature.orientation.id, document_type.id)
      expect(signature_status_table.first[:name]).to eq(result.first[:name])
      expect(signature_status_table.first[:status]).to eq(result.first[:status])
    end
  end

  describe '#mark' do
    let!(:professor) { create(:professor) }
    let!(:supervisor) { create(:professor) }
    let!(:academic) { create(:academic) }
    let!(:external_member) { create(:external_member) }
    let!(:orientation) { create(:orientation, advisor: professor, academic: academic) }
    let!(:document_type) { create(:document_type_tco) }
    let!(:document) { create(:document, document_type: document_type) }

    let!(:signature_signed) do
      create(:signature_signed, document: document,
                                orientation_id: orientation.id,
                                user_id: professor.id)
    end

    let!(:professor_signature_signed) do
      create(:signature_signed, orientation_id: orientation.id,
                                document: document,
                                user_id: supervisor.id)
    end

    let!(:academic_signature_signed) do
      create(:academic_signature_signed, document: document,
                                         orientation_id: orientation.id,
                                         user_id: academic.id)
    end

    let!(:external_member_signature_signed) do
      create(:external_member_signature_signed, orientation_id: orientation.id,
                                                document: document,
                                                user_id: external_member.id)
    end

    let(:roles) do
      'signatures.users.roles'
    end

    let(:supervisor_role) do
      I18n.t("#{roles}.#{supervisor.gender}.#{professor_signature_signed.user_type}")
    end

    let(:external_member_role) do
      I18n.t("#{roles}.#{external_member.gender}.#{external_member_signature_signed.user_type}")
    end

    let(:academic_role) do
      I18n.t("#{roles}.#{academic.gender}.#{academic_signature_signed.user_type}")
    end

    let(:professor_role) do
      I18n.t("#{roles}.#{professor.gender}.#{signature_signed.user_type}")
    end

    before do
      orientation.external_member_supervisors << external_member
      orientation.professor_supervisors << supervisor
    end

    it 'returns the signatures mark' do
      signatures_mark = [
        { name: supervisor.name,
          role: supervisor_role,
          date: I18n.l(professor_signature_signed.updated_at, format: :short),
          time: I18n.l(professor_signature_signed.updated_at, format: :time) },
        { name: external_member.name,
          role: external_member_role,
          date: I18n.l(external_member_signature_signed.updated_at, format: :short),
          time: I18n.l(external_member_signature_signed.updated_at, format: :time) },
        { name: academic.name,
          role: academic_role,
          date: I18n.l(academic_signature_signed.updated_at, format: :short),
          time: I18n.l(academic_signature_signed.updated_at, format: :time) },
        { name: professor.name,
          role: professor_role,
          date: I18n.l(signature_signed.updated_at, format: :short),
          time: I18n.l(signature_signed.updated_at, format: :time) }
      ]
      signature_mark = Signature.mark(signature_signed.orientation.id, document_type.id)
      expect(signature_mark).to match_array(signatures_mark)
    end
  end
end
