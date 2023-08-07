require 'rails_helper'

describe 'Document::index', type: :feature do
  let(:orientation) { create(:orientation) }
  let(:academic) { orientation.academic }

  before do
    orientation.signatures << Signature.all
    login_as(academic, scope: :academic)
  end

  describe '#index', js: true do
    let(:documents) { orientation.documents.where(signatures: { user_type: :academic }) }

    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        index_url = academics_documents_pending_path
        visit index_url

        documents.each do |document|
          expect(page).to have_link(document.orientation.short_title, href: academics_document_path(document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
          expect(page).to have_selector("a[href='#{index_url}'].active")
        end
      end
    end

    context 'when shows all the signed documents' do
      before do
        documents.each do |document|
          document.signatures.each(&:sign)
        end
      end

      it 'shows all the documents' do
        index_url = academics_documents_signed_path
        visit index_url

        documents.each do |document|
          expect(page).to have_link(document.orientation.short_title, href: academics_document_path(document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
          expect(page).to have_selector("a[href='#{index_url}'].active")
        end
      end
    end
  end
end
