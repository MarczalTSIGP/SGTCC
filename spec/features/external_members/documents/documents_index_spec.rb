require 'rails_helper'

describe 'Document::index', type: :feature do
  let(:orientation) { create(:orientation) }
  let(:external_member) { orientation.external_member_supervisors.first }

  before do
    orientation.signatures << Signature.all
    login_as(external_member, scope: :external_member)
  end

  describe '#index', js: true do
    let(:documents) do
      orientation.documents.where(signatures: { user_type: :external_member_supervisor })
    end

    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        index_url = external_members_documents_pending_path
        visit index_url

        documents.each do |document|
          expect(page).to have_link(document.orientation.short_title, href: external_members_document_path(document))
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
        index_url = external_members_documents_signed_path
        visit index_url

        documents.each do |document|
          expect(page).to have_link(document.orientation.short_title, href: external_members_document_path(document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
          expect(page).to have_selector("a[href='#{index_url}'].active")
        end
      end
    end
  end
end
