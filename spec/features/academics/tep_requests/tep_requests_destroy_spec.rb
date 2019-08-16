require 'rails_helper'

describe 'TepRequest::destroy', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let!(:document_tep) { create(:document_tep, orientation_id: orientation.id) }
  let(:resource_name) { request_resource_name }

  before do
    login_as(academic, scope: :academic)
    visit academics_tep_requests_path
  end

  describe '#destroy' do
    context 'when tep request is destroyed' do
      it 'show success message' do
        click_on_destroy_link(academics_tep_request_path(document_tep))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(orientation.title)
      end
    end
  end
end
