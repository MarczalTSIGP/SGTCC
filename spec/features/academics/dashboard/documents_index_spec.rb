require 'rails_helper'

describe 'Document::index', type: :feature, js: true do
  let(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, academic: academic) }

  before do
    login_as(academic, scope: :academic)
    visit academics_root_path
  end

  describe '#index' do
    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_contents([document.orientation.short_title,
                                         document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
      end
    end
  end
end
