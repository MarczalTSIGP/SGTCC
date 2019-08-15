require 'rails_helper'

describe 'Request::update', type: :feature, js: true do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:orientation, advisor: professor) }
  let!(:document) { create(:document_tdo, orientation_id: orientation.id) }
  let(:resource_name) { request_resource_name }

  before do
    login_as(professor, scope: :professor)
  end

  describe '#update' do
    let!(:new_orientation) { create(:orientation, advisor: professor) }
    let(:new_justification) { "**#{document.request['requester']['justification']}" }

    before do
      visit edit_professors_request_path(document)
    end

    context 'when request is valid' do
      it 'updates the term of abandonment' do
        selectize(new_orientation.academic_with_calendar, from: 'document_orientation_id')
        find('.fa-italic').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_document_path(new_orientation.documents.last)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([professor.name,
                                       document.document_type.name.upcase,
                                       new_justification])
      end
    end
  end
end
