require 'rails_helper'

describe 'Document::index', type: :feature, js: true do
  let!(:orientation) { create(:orientation) }
  let(:external_member) { orientation.external_member_supervisors.first }

  before do
    login_as(external_member, scope: :external_member)
    visit external_members_root_path
  end

  describe '#index' do
    context 'when shows all the pending documents' do
      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_link(document.orientation.short_title,
                                    href: external_members_document_path(document))
          expect(page).to have_contents([document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
      end
    end
  end
end
