require 'rails_helper'

describe 'Document::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation, advisor: responsible) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_root_path
  end

  describe '#index' do
    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_content(document.orientation.short_title)
          expect(page).to have_content(document.orientation.academic.name)
          expect(page).to have_content(document.document_type.identifier.upcase)
        end
      end
    end
  end
end
