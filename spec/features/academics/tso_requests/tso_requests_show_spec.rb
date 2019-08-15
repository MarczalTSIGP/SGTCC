require 'rails_helper'

describe 'TsoRequest::show', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let!(:document) do
    create(:document_tso, orientation_id: orientation.id, advisor_id: advisor.id)
  end

  before do
    login_as(academic, scope: :academic)
    visit academics_tso_request_path(document)
  end

  describe '#show' do
    context 'when shows the tso request' do
      it 'shows the tso request' do
        expect(page).to have_contents([document.request['requester']['justification'],
                                       complete_date(document.created_at),
                                       complete_date(document.updated_at)])
      end
    end
  end
end
