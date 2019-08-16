require 'rails_helper'

describe 'Document::index', type: :feature do
  let(:professor) { create(:responsible) }
  let!(:orientation) { create(:orientation, advisor: professor) }
  let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

  before do
    document.signatures.find_by(user_type: :advisor).sign
    login_as(professor, scope: :professor)
  end

  describe '#index', js: true do
    context 'when shows all the reviewing documents' do
      it 'shows all the documents' do
        index_url = professors_documents_reviewing_path
        visit index_url

        expect(page).to have_contents([document.orientation.short_title,
                                       document.orientation.academic.name,
                                       document.document_type.identifier.upcase])
        expect(page).to have_selector("a[href='#{index_url}'].active")
      end
    end
  end
end
