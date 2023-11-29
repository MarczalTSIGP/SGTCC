require 'rails_helper'

describe 'Request::destroy', :js do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor: professor) }
  let!(:document_tdo) { create(:document_tdo, orientation_id: orientation.id) }
  let(:resource_name) { request_resource_name }

  before do
    login_as(professor, scope: :professor)
    visit professors_requests_path
  end

  describe '#destroy' do
    context 'when the request is destroyed' do
      it 'show success message' do
        click_on_destroy_link(professors_request_path(document_tdo))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(orientation.title)
      end
    end
  end
end
