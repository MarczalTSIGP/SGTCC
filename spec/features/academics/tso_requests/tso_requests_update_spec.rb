require 'rails_helper'

describe 'TsoRequest::update', type: :feature, js: true do
  let(:resource_name) { request_resource_name }
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let!(:orientation) { create(:orientation, academic: academic) }

  let!(:document_tso) do
    create(:document_tso, orientation_id: orientation.id, advisor_id: advisor.id)
  end

  before do
    create(:responsible)
    login_as(academic, scope: :academic)
  end

  describe '#update' do
    let(:new_justification) { "**#{document_tso.request['requester']['justification']}" }

    before do
      visit edit_academics_tep_request_path(document_tso)
    end

    context 'when request is valid' do
      it 'updates the justification of the term of substitution' do
        find('.fa-italic').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_document_path(document_tso)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([academic.name,
                                       document_tso.document_type.name.upcase,
                                       new_justification])
      end
    end

    context 'when the request can t be edited' do
      before do
        document_tso.signature_by_user(academic, :academic).sign
        visit edit_academics_tso_request_path(document_tso)
      end

      it 'redirect to the tep requests page' do
        expect(page).to have_current_path academics_tso_requests_path
        expect(page).to have_flash(:warning, text: document_academic_not_allowed_message)
      end
    end
  end
end