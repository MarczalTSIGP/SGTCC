require 'rails_helper'

describe 'Supervision::documents index', :js do
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:orientation, :current, :tcc_one) }
  let(:active_link) { external_members_supervisions_tcc_one_path }

  before do
    orientation.external_member_supervisors << external_member
    orientation.documents.each(&:save_to_json)
    login_as(external_member, scope: :external_member)
    visit external_members_supervision_documents_path(orientation)
  end

  it 'shows all the documents' do
    orientation.documents.each do |document|
      expect(page).to have_link(document.orientation.short_title,
                                href: external_members_supervision_document_path(orientation,
                                                                                 document))
      expect(page).to have_text(document.orientation.academic.name)
      expect(page).to have_text(document.document_type.identifier.upcase)
    end

    expect(page).to have_css("a[href='#{active_link}'].active")
  end
end
