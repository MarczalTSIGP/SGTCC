require 'rails_helper'

describe 'TsoRequest::destroy', type: :feature, js: true do
  let(:resource_name) { request_resource_name }
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let!(:document) do
    create(:document_tso, orientation_id: orientation.id, advisor_id: advisor.id)
  end

  before do
    login_as(academic, scope: :academic)
    visit academics_tso_requests_path
  end

  describe '#destroy' do
    context 'when tso request is destroyed' do
      it 'show success message' do
        click_on_destroy_link(academics_tso_request_path(document))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(orientation.title)
      end
    end
  end
end
