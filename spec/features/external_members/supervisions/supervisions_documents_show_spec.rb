require 'rails_helper'

describe 'Supervision::documents show', :js do
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:document) { orientation.documents.first }
  let(:active_link) { external_members_supervisions_tcc_one_path }

  before do
    orientation.external_member_supervisors << external_member
    orientation.documents.each(&:save_to_json)
    login_as(external_member, scope: :external_member)
    visit external_members_supervision_document_path(orientation, document)
  end

  it_behaves_like 'orientation document show page'
end
