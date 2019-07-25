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
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when returns the unique code' do
      let(:time) { Time.now.to_i }
      let(:document) { orientation.signatures.first.document }

      it 'returns the code with Timestamps and document id' do
        code = time + document.id
        expect(document.code).to eq(code.to_s)
      end
    end
  end

  describe '#update_content_data' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when update content data' do
      let(:document) { orientation.signatures.first.document }

      it 'returns true' do
        expect(document.update_content_data).to eq(true)
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
end
