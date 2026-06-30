require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe Document do
  describe '#save_to_json' do
    let(:orientation) { create(:orientation) }

    before do
      orientation.signatures << Signature.all
    end

    context 'when update content data' do
      let(:document) { orientation.signatures.first.document }

      it 'returns true' do
        expect(document.save_to_json).to be(true)
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
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
