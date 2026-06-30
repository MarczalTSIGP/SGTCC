require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe Document do
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
      create(:current_orientation_tcc_two, advisor: professor, academic:)
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
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
