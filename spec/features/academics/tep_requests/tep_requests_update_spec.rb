require 'rails_helper'

describe 'TepRequest::update', :js do
  let!(:academic) { create(:academic) }
  let!(:orientation) { create(:orientation, academic: academic) }
  let!(:document_tep) { create(:document_tep, orientation_id: orientation.id) }
  let(:resource_name) { request_resource_name }

  before do
    login_as(academic, scope: :academic)
  end

  describe '#update' do
    let(:new_justification) { "**#{document_tep.request['requester']['justification']}" }

    before do
      visit edit_academics_tep_request_path(document_tep)
    end

    context 'when request is valid' do
      it 'updates the justification of the term of extension' do
        find('.fa-italic').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_document_path(document_tep)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([academic.name,
                                       document_tep.document_type.name.upcase,
                                       new_justification])
      end
    end

    context 'when the request can t be edited' do
      before do
        document_tep.signature_by_user(academic, :academic).sign
        visit edit_academics_tep_request_path(document_tep)
      end

      it 'redirect to the tep requests page' do
        expect(page).to have_current_path academics_tep_requests_path
        expect(page).to have_flash(:warning, text: document_academic_not_allowed_message)
      end
    end
  end
end
