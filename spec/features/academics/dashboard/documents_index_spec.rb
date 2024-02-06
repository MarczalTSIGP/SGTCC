require 'rails_helper'

describe 'Document::index' do
  let!(:orientation) { create(:orientation) }

  before do
    login_as(orientation.academic, scope: :academic)
    visit academics_root_path
  end

  describe '#index' do
    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title,
                                    href: academics_document_path(document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
      end
    end
  end
end
