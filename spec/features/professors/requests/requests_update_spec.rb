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
      it 'updates the term of abandonment with orientation' do
        selectize(new_orientation.academic_with_calendar, from: 'document_orientation_id')
        find('.fa-italic').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_document_path(new_orientation.documents.last)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([professor.name,
                                       document.document_type.name.upcase,
                                       new_justification])
      end

      it 'updates the justification of the term of abandonment' do
        find('.fa-italic').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path professors_document_path(document)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([professor.name,
                                       document.document_type.name.upcase,
                                       new_justification])
      end
    end

    context 'when the request can t be edited' do
      before do
        document.signature_by_user(professor.id, professor.user_types).sign
        visit edit_professors_request_path(document)
      end

      it 'redirect to the tep requests page' do
        expect(page).to have_current_path professors_requests_path
        expect(page).to have_flash(:warning, text: document_professor_not_allowed_message)
      end
    end
  end
end
