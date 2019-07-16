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

  describe '#document_filename' do
    let(:signature) { create(:signature) }
    let(:orientation) { signature.orientation }

    it 'returns the document file_name' do
      document_type = signature.document.document_type.identifier
      academic_name = I18n.transliterate(orientation.academic.name.tr(' ', '_'))
      calendar = orientation.calendar.year_with_semester.tr('/', '_')
      document_filename = "SGTCC_#{document_type}_#{academic_name}_#{calendar}".upcase
      expect(signature.document_filename).to eq(document_filename)
    end
  end

  describe '#term_of_commitement?' do
    let(:orientation) { create(:orientation) }
    let(:signature_tco) { orientation.signatures.first }
    let(:signature_tcai) { orientation.signatures.last }

    it 'returns true' do
      expect(signature_tco.term_of_commitment?).to eq(true)
    end

    it 'returns false' do
      expect(signature_tcai.term_of_commitment?).to eq(false)
    end
  end

  describe '#term_of_accept_institution?' do
    let(:orientation) { create(:orientation) }
    let(:signature_tco) { orientation.signatures.first }
    let(:signature_tcai) { orientation.signatures.last }

    it 'returns true' do
      expect(signature_tcai.term_of_accept_institution?).to eq(true)
    end

    it 'returns false' do
      expect(signature_tco.term_of_accept_institution?).to eq(false)
    end
  end

  describe '#confirm' do
    context 'when professor confirm' do
      let(:orientation) { create(:orientation) }
      let(:signature) { orientation.signatures.where(user_type: :advisor).first }
      let(:professor) { signature.user }
      let(:params) { { login: professor.username, password: 'password' } }

      it 'returns true if the professors login is correct' do
        expect(signature.confirm(Professor, 'username', params)). to eq(true)
      end

      it 'returns false if the professors login is not correct' do
        params = { login: professor.username, password: '231' }
        expect(signature.confirm(Professor, 'username', params)). to eq(false)
      end
    end

    context 'when academic confirm' do
      let(:orientation) { create(:orientation) }
      let(:signature) { orientation.signatures.where(user_type: :academic).first }
      let(:academic) { signature.user }
      let(:params) { { login: academic.ra, password: 'password' } }

      it 'returns true if the academics login is correct' do
        expect(signature.confirm(Academic, 'ra', params)). to eq(true)
      end

      it 'returns false if the academics login is not correct' do
        params = { login: academic.ra, password: '231' }
        expect(signature.confirm(Academic, 'ra', params)). to eq(false)
      end
    end

    context 'when external member confirm' do
      let(:orientation) { create(:orientation) }
      let(:signature) do
        orientation.signatures.where(user_type: :external_member_supervisor).first
      end
      let(:external_member) { signature.user }
      let(:params) { { login: external_member.email, password: 'password' } }

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
    let(:orientation) { create(:orientation) }
    let(:signature) { orientation.signatures.where(user_type: :advisor).first }
    let(:professor) { signature.user }
    let(:params) { { login: professor.username, password: 'password' } }

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
    let(:orientation) { create(:orientation) }
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
    let(:orientation) { create(:orientation) }
    let(:signature) { orientation.signatures.first }
    let(:document_type) { signature.document.document_type }

    it 'returns the result by condition and document type' do
      result = Signature.joins(:document)
                        .where(orientation_id: orientation.id,
                               documents: { document_type_id: document_type.id })

      signature_by_condition = Signature.by_orientation_and_document_t(
        orientation.id, document_type.id
      )
      expect(signature_by_condition).to match_array(result)
    end
  end

  describe '#status_table' do
    let(:orientation) { create(:orientation) }
    let(:signature) { orientation.signatures.first }

    it 'returns the status table' do
      document_type_id = signature.document.document_type.id
      signatures = Signature.joins(:document)
                            .where(orientation_id: orientation.id,
                                   documents: { document_type_id: document_type_id })
      result = signatures.map do |signature|
        { name: signature.user.name, status: signature.status }
      end
      signature_status_table = Signature.status_table(orientation.id, document_type_id)
      expect(signature_status_table.first[:name]).to eq(result.first[:name])
      expect(signature_status_table.first[:status]).to eq(result.first[:status])
    end
  end

  describe '#mark' do
    let(:orientation) { create(:orientation) }
    let(:signatures) { orientation.signatures }
    let(:document_type) { signatures.first.document.document_type }

    let(:professor_signature_signed) do
      signatures.where(user_type: :advisor).first
    end

    let(:supervisor_signature_signed) do
      signatures.where(user_type: :professor_supervisor).first
    end

    let(:academic_signature_signed) do
      signatures.where(user_type: :academic).first
    end

    let(:external_member_signature_signed) do
      signatures.where(user_type: :external_member_supervisor).first
    end

    let(:professor) { professor_signature_signed.user }
    let(:supervisor) { supervisor_signature_signed.user }
    let(:academic) { academic_signature_signed.user }
    let(:external_member) { external_member_signature_signed.user }

    let(:roles) do
      'signatures.users.roles'
    end

    let(:supervisor_role) do
      I18n.t("#{roles}.#{supervisor.gender}.#{supervisor_signature_signed.user_type}")
    end

    let(:external_member_role) do
      I18n.t("#{roles}.#{external_member.gender}.#{external_member_signature_signed.user_type}")
    end

    let(:academic_role) do
      I18n.t("#{roles}.#{academic.gender}.#{academic_signature_signed.user_type}")
    end

    let(:professor_role) do
      I18n.t("#{roles}.#{professor.gender}.#{professor_signature_signed.user_type}")
    end

    before do
      orientation.signatures.each { |s| s.update(status: true) }
    end

    it 'returns the signatures mark' do
      signatures_mark = [
        { name: supervisor.name,
          role: supervisor_role,
          date: I18n.l(supervisor_signature_signed.updated_at, format: :short),
          time: I18n.l(supervisor_signature_signed.updated_at, format: :time) },
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
          date: I18n.l(professor_signature_signed.updated_at, format: :short),
          time: I18n.l(professor_signature_signed.updated_at, format: :time) }
      ]
      signature_mark = Signature.mark(orientation.id, document_type.id)
      expect(signature_mark).to match_array(signatures_mark)
    end
  end
end
