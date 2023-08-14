require 'rails_helper'

describe 'Document::index', type: :feature, js: true do
  let(:professor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor: professor) }

  before do
    login_as(professor, scope: :professor)
    visit professors_root_path
  end

  describe '#index' do
    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title, href: professors_document_path(document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
      end
    end
  end
end
