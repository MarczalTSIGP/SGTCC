require 'rails_helper'

describe 'Supervision::documents', type: :feature, js: true do
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:current_orientation_tcc_one) }

  before do
    orientation.external_member_supervisors << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_supervision_documents_path(orientation)
  end

  describe '#index' do
    context 'when shows all the orientation documents' do
      let(:active_link) { external_members_supervisions_tcc_one_path }

      it 'shows all the documents' do
        orientation.documents.each do |document|
          expect(page).to have_contents([document.orientation.short_title,
                                         document.orientation.academic.name,
                                         document.document_type.identifier.upcase])
        end
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end
  end
end
