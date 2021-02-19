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
    let!(:coordinator) { create(:coordinator) }
    let!(:responsible) { create(:responsible) }
    let!(:orientation) { create(:current_orientation_tcc_two) }

    context 'when returns the tdo signatures' do
      let!(:document) { create(:document_tdo, orientation_id: orientation.id) }
      let(:signatures) { document.signatures }
      let(:responsible_signature) { signatures.find_by(user_type: :professor_responsible) }
      let(:advisor_signature) { signatures.find_by(user_type: :advisor) }
      let(:advisor) { advisor_signature.user }

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Responsible signature' do
        attributes = { user_type: 'professor_responsible', user_id: responsible.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(responsible_signature).to have_attributes(attributes)
      end
    end

    context 'when returns the tep signatures' do
      let!(:document) { create(:document_tep, orientation_id: orientation.id) }
      let(:signatures) { document.signatures }
      let(:responsible_signature) { signatures.find_by(user_type: :professor_responsible) }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }
      let(:coordinator_signature) { signatures.find_by(user_type: :coordinator) }
      let(:academic) { academic_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Responsible signature' do
        attributes = { user_type: 'professor_responsible', user_id: responsible.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(responsible_signature).to have_attributes(attributes)
      end

      it 'returns the Coordinator signature' do
        attributes = { user_type: 'coordinator', user_id: coordinator.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(coordinator_signature).to have_attributes(attributes)
      end
    end

    context 'when returns the tso signatures' do
      let!(:new_advisor) { create(:professor) }

      let(:new_orientation) do
        { advisor: { id: new_advisor.id, name: new_advisor.name },
          professorSupervisors: {},
          externalMemberSupervisors: {} }
      end

      let(:request) do
        { requester: { justificatio: 'just' }, new_orientation: new_orientation }
      end

      let!(:document) do
        create(:document_tso, orientation_id: orientation.id,
                              advisor_id: new_advisor.id, request: request)
      end

      let(:signatures) { document.signatures }
      let(:responsible_signature) { signatures.find_by(user_type: :professor_responsible) }
      let(:advisor_signature) { signatures.find_by(user_type: :advisor) }
      let(:new_advisor_signature) { signatures.where(user_type: :new_advisor).last }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }
      let(:advisor) { advisor_signature.user }
      let(:academic) { academic_signature.user }

      it 'returns the Academic signature' do
        attributes = { user_type: 'academic', user_id: academic.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(academic_signature).to have_attributes(attributes)
      end

      it 'returns the Advisor signature' do
        attributes = { user_type: 'advisor', user_id: advisor.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(advisor_signature).to have_attributes(attributes)
      end

      it 'returns the new Advisor signature' do
        attributes = { user_type: 'new_advisor', user_id: new_advisor.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(new_advisor_signature).to have_attributes(attributes)
      end

      it 'returns the Responsible signature' do
        attributes = { user_type: 'professor_responsible', user_id: responsible.id,
                       status: false, document_id: document.id,
                       orientation_id: orientation.id }
        expect(responsible_signature).to have_attributes(attributes)
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
        { id: orientation.id, title: orientation.title }
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
        { id: document.id, created_at: I18n.l(document.created_at, format: :document) }
      end

      let(:term_json_data) do
        { orientation: orientation_data, advisor: advisor_data,
          title: document.document_type.name.upcase, document: document_data,
          academic: academic_data, institution: institution_data,
          professorSupervisors: orientation.professor_supervisors_to_document,
          externalMemberSupervisors: orientation.external_member_supervisors_to_document,
          examination_board: nil }
      end

      it 'returns the term json data' do
        expect(document.term_json_data).to eq(term_json_data)
      end
    end
  end

  describe '#new_tdo' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor_id: professor.id) }

    before do
      create(:document_type_tdo)
      create(:responsible)
    end

    it 'returns true' do
      params = { orientation_id: orientation.id, justification: 'justification' }
      document = DocumentType.find_by(identifier: :tdo).documents.new(params)
      document.request = { requester: { id: professor.id, name: professor.name,
                                        type: 'advisor', justification: 'justification' } }
      expect(described_class.new_tdo(professor, params).to_json).to eq(document.to_json)
    end
  end

  describe '#new_tep' do
    let!(:academic) { create(:academic) }

    let!(:orientation) do
      create(:current_orientation_tcc_two, academic_id: academic.id)
    end

    before do
      create(:document_type_tep)
      create(:responsible)
    end

    it 'returns true' do
      params = { orientation_id: orientation.id, justification: 'justification' }
      document = DocumentType.find_by(identifier: :tep).documents.new(params)
      document.request = { requester: { id: academic.id, name: academic.name,
                                        type: 'academic', justification: 'justification' } }
      expect(described_class.new_tep(academic, params).to_json).to eq(document.to_json)
    end
  end

  describe '#new_tso' do
    let!(:academic) { create(:academic) }
    let!(:professor) { create(:professor) }

    let!(:orientation) do
      create(:current_orientation_tcc_two, advisor: professor, academic: academic)
    end

    let(:requester_data) do
      { id: academic.id, name: academic.name,
        type: 'academic', justification: 'justification' }
    end

    let(:new_orientation_data) do
      { advisor: { id: professor.id, name: professor.name_with_scholarity },
        professorSupervisors: [], externalMemberSupervisors: [] }
    end

    let(:params) do
      { orientation_id: orientation.id, justification: 'justification',
        advisor_id: professor.id, professor_supervisor_ids: [''],
        external_member_supervisor_ids: [''] }
    end

    before do
      create(:document_type_tso)
      create(:responsible)
    end

    it 'returns true' do
      document = DocumentType.find_by(identifier: :tso).documents.new(params)
      document.request = { requester: requester_data, new_orientation: new_orientation_data }
      expect(described_class.new_tso(academic, params).to_json).to eq(document.to_json)
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
        { name: signature.user.name, status: signature.status,
          role: I18n.t("signatures.users.roles.#{signature.user.gender}.#{signature.user_type}") }
      end
      document_status_table = document.status_table
      expect(document_status_table.first[:name]).to eq(result.first[:name])
      expect(document_status_table.first[:status]).to eq(result.first[:status])
    end
  end

  describe '#mark' do
    let(:orientation) { create(:orientation) }
    let(:document) { orientation.signatures.first.document }
    let(:signatures) { document.signatures }

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
      document.signatures.each { |s| s.update(status: true) }
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

  describe '#filename' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns the filename' do
      let(:signature) { orientation.signatures.first }

      it 'returns the document file_name' do
        document_type = signature.document.document_type.identifier
        academic_name = I18n.transliterate(orientation.academic.name.tr(' ', '_'))
        calendar = orientation.current_calendar.year_with_semester.tr('/', '_')
        document_filename = "SGTCC_#{document_type}_#{academic_name}_#{calendar}".upcase
        expect(signature.document.filename).to eq(document_filename)
      end
    end
  end

  describe '#signature_by_user' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic: academic) }
    let(:document) { described_class.first }

    context 'when returns the pending signature' do
      let(:pending_signature) do
        document.signatures.find_by(user_id: academic.id,
                                    user_type: :academic,
                                    status: false)
      end

      it 'returns the pending signature' do
        expect(document.signature_by_user(academic.id, :academic)).to eq(pending_signature)
      end
    end

    context 'when returns the signed signature' do
      let(:signed_signature) do
        document.signatures.find_by(user_id: academic.id,
                                    user_type: :academic,
                                    status: true)
      end

      let(:academic_signature) do
        orientation.signatures.find_by(user_id: academic.id,
                                       user_type: :academic)
      end

      before do
        document.signatures.each(&:sign)
      end

      it 'returns the signed signature' do
        expect(document.signature_by_user(academic.id, :academic)).to eq(signed_signature)
      end
    end
  end

  describe '#save_judgment' do
    let!(:professor) { create(:responsible) }
    let!(:orientation) { create(:orientation) }
    let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

    let(:params) do
      { justification: 'justification', accept: true }
    end

    let(:json_judgment) do
      { responsible: { id: professor.id,
                       accept: params[:accept],
                       justification: params[:justification] } }
    end

    it 'returns true' do
      expect(document.save_judgment(professor, params)).to eq(true)
    end
  end

  describe '#academic_signed?' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic: academic) }
    let!(:document) { create(:document_tep, orientation_id: orientation.id) }

    context 'when the document is not signed' do
      it 'returns false' do
        expect(document.academic_signed?(academic)).to eq(false)
      end
    end

    context 'when the document is signed' do
      before do
        document.signatures.each(&:sign)
      end

      it 'returns true' do
        expect(document.academic_signed?(academic)).to eq(true)
      end
    end
  end

  describe '#professor_signed?' do
    let!(:professor) { create(:professor) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

    context 'when the document is not signed' do
      it 'returns false' do
        expect(document.professor_signed?(professor)).to eq(false)
      end
    end

    context 'when the document is signed' do
      before do
        document.signatures.each(&:sign)
      end

      it 'returns true' do
        expect(document.professor_signed?(professor)).to eq(true)
      end
    end
  end

  describe '#update_requester_justification' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic: academic) }
    let!(:document) { create(:document_tep, orientation_id: orientation.id) }
    let(:params) { { justification: 'new_justification' } }

    it 'returns true when is updated' do
      expect(document.update_requester_justification(params)).to eq(true)
    end

    it 'returns when the justification is empty' do
      params = { justification: nil }
      expect(document.update_requester_justification(params)).to eq(true)
    end
  end

  describe '#tdo_for_review?' do
    let!(:professor) { create(:responsible) }
    let!(:orientation) { create(:orientation, advisor: professor) }
    let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

    context 'when the advisor not signed' do
      it 'returns false' do
        expect(document.tdo_for_review?).to eq(false)
      end
    end

    context 'when the advisor already signed' do
      let(:advisor_signature) { document.signatures.find_by(user_type: :advisor) }

      before do
        advisor_signature.sign
      end

      it 'returns true' do
        expect(document.tdo_for_review?).to eq(true)
      end
    end
  end

  describe '#tep_for_review?' do
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic: academic) }
    let!(:document) { create(:document_tep, orientation_id: orientation.id) }

    context 'when the academic not signed' do
      it 'returns false' do
        expect(document.tep_for_review?).to eq(false)
      end
    end

    context 'when the academic already signed' do
      let(:signatures) { document.signatures }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }

      before do
        academic_signature.sign
      end

      it 'returns true' do
        expect(document.tep_for_review?).to eq(true)
      end
    end
  end

  describe '#tso_for_review?' do
    let!(:advisor) { create(:professor) }
    let!(:academic) { create(:academic) }
    let!(:orientation) { create(:orientation, academic: academic) }
    let(:new_orientation) do
      { advisor: { id: advisor.id, name: advisor.name },
        professorSupervisors: {},
        externalMemberSupervisors: {} }
    end

    let(:request) do
      { requester: { justification: 'just' }, new_orientation: new_orientation }
    end

    let!(:document) do
      create(:document_tso, orientation_id: orientation.id,
                            request: request, advisor_id: advisor.id)
    end

    context 'when the academic not signed' do
      it 'returns false' do
        expect(document.tso_for_review?).to eq(false)
      end
    end

    context 'when the academic signed' do
      let(:signatures) { document.signatures }
      let(:academic_signature) { signatures.find_by(user_type: :academic) }

      before do
        academic_signature.sign
      end

      it 'returns true' do
        expect(document.tso_for_review?).to eq(true)
      end
    end
  end
end
