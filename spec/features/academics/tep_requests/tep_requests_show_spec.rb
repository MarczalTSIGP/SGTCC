require 'rails_helper'

describe 'TepRequest::show', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let!(:document) { create(:document_tep, orientation_id: orientation.id) }

  before do
    login_as(academic, scope: :academic)
    visit academics_tep_request_path(document)
  end

  describe '#show' do
    context 'when shows the tep request' do
      it 'shows the tep request' do
        expect(page).to have_contents([document.request['requester']['justification'],
                                       complete_date(document.created_at),
                                       complete_date(document.updated_at)])
      end
    end
  end
end
