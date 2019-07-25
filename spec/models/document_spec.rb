require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:document_type) }
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
  end

  describe '#all_signed?' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns true' do
      before do
        orientation.signatures.each(&:sign)
      end

      let(:document) { orientation.signatures.first.document }

      it 'returns true' do
        expect(document.all_signed?).to eq(true)
      end
    end

    context 'when returns false' do
      let(:document) { orientation.signatures.first.document }

      it 'returns false' do
        expect(document.all_signed?).to eq(false)
      end
    end
  end

  describe '#after_create' do
    let!(:responsible) { create(:responsible) }
    let!(:orientation) { create(:orientation) }
    let!(:document_tdo) { create(:document_tdo, orientation_id: orientation.id) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns the tdo signatures' do
      let(:signatures) { orientation.signatures.where(document_id: document_tdo.id) }
      let(:responsible_signature) { signatures.find_by(user_type: :professor_responsible) }
      let(:advisor_signature) { signatures.find_by(user_type: :advisor) }
      let(:advisor) { advisor_signature.user }

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document_tdo.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Responsible signature' do
        attributes = { user_type: 'professor_responsible', user_id: responsible.id,
                       status: false, document_id: document_tdo.id,
                       orientation_id: orientation.id }
        expect(responsible_signature).to have_attributes(attributes)
      end
    end

    context 'when returns the unique code' do
      let(:document) { orientation.signatures.first.document }

      it 'returns the code with Timestamps and document id' do
        code = Time.now.to_i + document.id
        expect(document.code).to eq(code.to_s)
      end
    end
  end

  describe '#save_to_json' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when update content data' do
      let(:document) { orientation.signatures.first.document }

      it 'returns true' do
        expect(document.save_to_json).to eq(true)
      end
    end
  end

  describe '#term_json_data' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns the json content' do
      let(:signatures) { orientation.signatures }
      let(:document) { signatures.first.document }
      let(:advisor) { signatures.where(user_type: :advisor).first.user }
      let(:academic) { signatures.where(user_type: :academic).first.user }
      let(:institution) { orientation.institution }

      let(:orientation_data) do
        { id: orientation.id, title: orientation.title,
          created_at: I18n.l(orientation.created_at, format: :document) }
      end

      let(:academic_data) do
        { id: academic.id, name: academic.name, ra: academic.ra }
      end

      let(:advisor_data) do
        { id: advisor.id, name: "#{advisor.scholarity.abbr} #{advisor.name}",
          label: I18n.t("signatures.advisor.labels.#{advisor.gender}") }
      end

      let(:institution_data) do
        { id: institution.id, trade_name: institution.trade_name,
          responsible: institution.external_member&.name }
      end

      let(:document_data) do
        { id: document.id }
      end

      let(:term_json_data) do
        { orientation: orientation_data, advisor: advisor_data,
          title: document.document_type.name.upcase, document: document_data,
          academic: academic_data, institution: institution_data,
          professorSupervisors: orientation.professor_supervisors_to_document,
          externalMemberSupervisors: orientation.external_member_supervisors_to_document }
      end

      it 'returns the term json data' do
        expect(document.term_json_data).to eq(term_json_data)
      end
    end
  end

  describe '#create_tdo' do
    before do
      create(:document_type_tdo)
      create(:responsible)
    end

    context 'when document is created' do
      let!(:professor) { create(:professor) }
      let!(:orientation) { create(:orientation, advisor_id: professor.id) }

      it 'returns true' do
        params = { orientation_id: orientation.id, justification: 'justification' }
        document = DocumentType.find_by(identifier: :tdo).documents.new(params)
        document.request = { requester: { id: professor.id, name: professor.name,
                                          type: 'advisor', justification: 'justification' } }
        expect(Document.new_tdo(professor, params).to_json).to eq(document.to_json)
      end
    end
  end

  describe '#status_table' do
    let(:orientation) { create(:orientation) }
    let(:signature) { orientation.signatures.first }

    before do
      orientation.signatures << Signature.all
    end

    it 'returns the status table' do
      document = signature.document
      result = document.signatures.map do |signature|
        { name: signature.user.name, status: signature.status }
      end
      document_status_table = document.status_table
      expect(document_status_table.first[:name]).to eq(result.first[:name])
      expect(document_status_table.first[:status]).to eq(result.first[:status])
    end
  end

  describe '#mark' do
    let(:orientation) { create(:orientation) }
    let(:signatures) { orientation.signatures }
    let(:document) { signatures.first.document }

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
      orientation.signatures << Signature.all
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
      expect(document.mark).to match_array(signatures_mark)
    end
  end
end
