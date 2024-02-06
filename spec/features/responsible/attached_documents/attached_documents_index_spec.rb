require 'rails_helper'

describe 'AttachedDocument::index', :js do
  let(:responsible) { create(:responsible) }
  let!(:attached_documents) { create_list(:attached_document, 3) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#index' do
    context 'when shows all attached_documents' do
      it 'shows all attached_documents with options' do
        visit responsible_attached_documents_path
        attached_documents.each do |attached_document|
          expect(page).to have_link(attached_document.name, href: attached_document.file.url)
          expect(page).to have_contents([short_date(attached_document.created_at)])
        end
      end
    end
  end
end
