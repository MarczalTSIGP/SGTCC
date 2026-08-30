require 'rails_helper'

RSpec.describe Document do
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
