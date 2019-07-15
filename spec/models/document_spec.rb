require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'validates' do
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:document_type) }
    it { is_expected.to have_many(:signatures).dependent(:destroy) }
  end

  describe '#all_signed?' do
    let(:document) { create(:document) }

    context 'when returns true' do
      let(:signature_signed) { create(:signature_signed) }

      before do
        document.signatures << signature_signed
      end

      it 'returns true' do
        expect(document.all_signed?).to eq(true)
      end
    end

    context 'when returns false' do
      let(:signature) { create(:signature) }

      before do
        document.signatures << signature
      end

      it 'returns false' do
        expect(document.all_signed?).to eq(false)
      end
    end
  end

  describe '#after_create' do
    let(:document) { create(:document) }

    it 'returns the code with Timestamps and document id' do
      code = Time.now.to_i + document.id
      expect(document.code).to eq(code.to_s)
    end
  end

  describe '#update_content_data' do
    let(:orientation) { create(:orientation) }
    let(:document) { orientation.signatures.first.document }

    it 'returns true' do
      expect(document.update_content_data).to eq(true)
    end
  end

  describe '#term_json_data' do
    let(:orientation) { create(:orientation) }
    let(:signatures) { orientation.signatures }
    let(:document) { signatures.first.document }
    let(:advisor) { signatures.where(user_type: :advisor).first.user }
    let(:institution) { orientation.institution }

    let(:orientation_data) do
      { id: orientation.id, title: orientation.title,
        date: I18n.l(orientation.created_at, format: :document) }
    end

    let(:advisor_data) do
      { name: "#{advisor.scholarity.abbr} #{advisor.name}",
        label: I18n.t("signatures.advisor.labels.#{advisor.gender}") }
    end

    let(:institution_data) do
      { trade_name: institution.trade_name, responsible: institution.external_member&.name }
    end

    let(:term_json_data) do
      { orientation: orientation_data, advisor: advisor_data,
        title: document.document_type.name.upcase,
        academic: orientation.academic, institution: institution_data,
        professorSupervisors: orientation.professor_supervisors_to_document,
        externalMemberSupervisors: orientation.external_member_supervisors_to_document }
    end

    it 'returns the term json data' do
      expect(document.term_json_data).to eq(term_json_data)
    end
  end
end
