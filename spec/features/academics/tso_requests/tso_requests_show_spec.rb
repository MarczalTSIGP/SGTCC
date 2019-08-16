require 'rails_helper'

describe 'TsoRequest::show', type: :feature, js: true do
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let(:new_orientation) do
    { advisor: { id: advisor.id, name: advisor.name },
      professorSupervisors: {},
      externalMemberSupervisors: {} }
  end

  let(:request) do
    { requester: { justificatio: 'just' }, new_orientation: new_orientation }
  end

  let!(:document) do
    create(:document_tso, orientation_id: orientation.id,
                          advisor_id: advisor.id, request: request)
  end

  before do
    login_as(academic, scope: :academic)
    visit academics_tso_request_path(document)
  end

  describe '#show' do
    context 'when shows the tso request' do
      it 'shows the tso request' do
        expect(page).to have_contents([document.request['requester']['justification'],
                                       document.orientation.title,
                                       document.orientation.advisor.name,
                                       complete_date(document.created_at),
                                       complete_date(document.updated_at)])

        document.request['new_orientation']['professorSupervisors'].each do |supervisor|
          expect(page).to have_content(supervisor['name'])
        end

        document.request['new_orientation']['externalMemberSupervisors'].each do |supervisor|
          expect(page).to have_content(supervisor['name'])
        end
      end
    end
  end
end
