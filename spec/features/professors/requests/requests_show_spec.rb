require 'rails_helper'

describe 'Request::show', type: :feature, js: true do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor: professor) }
  let!(:document) { create(:document_tdo, orientation_id: orientation.id) }

  before do
    login_as(professor, scope: :professor)
    visit professors_request_path(document)
  end

  describe '#show' do
    context 'when shows the tdo request' do
      it 'shows the tdo request' do
        expect(page).to have_contents([document.request['requester']['justification'],
                                       document.orientation.title,
                                       document.orientation.academic_with_calendar,
                                       complete_date(document.created_at),
                                       complete_date(document.updated_at)])
      end
    end
  end
end
