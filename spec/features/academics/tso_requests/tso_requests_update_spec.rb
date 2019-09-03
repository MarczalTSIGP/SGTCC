require 'rails_helper'

describe 'TsoRequest::update', type: :feature, js: true do
  let(:resource_name) { request_resource_name }
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let!(:supervisor) { create(:professor) }
  let!(:orientation) { create(:current_orientation_tcc_one, academic: academic) }

  let!(:new_orientation) do
    { advisor: { id: advisor.id, name: advisor.name },
      professorSupervisors:  [{ id: supervisor.id, name: supervisor.name }],
      externalMemberSupervisors: [] }
  end

  let(:request) do
    { requester: { justification: 'just' }, new_orientation: new_orientation }
  end

  let!(:document_tso) do
    create(:document_tso, orientation_id: orientation.id,
                          advisor_id: advisor.id, request: request)
  end

  before do
    login_as(academic, scope: :academic)
  end

  describe '#update' do
    let!(:new_advisor) { create(:professor) }
    let(:new_justification) { "**#{document_tso.request['requester']['justification']}" }

    before do
      visit edit_academics_tso_request_path(document_tso)
    end

    context 'when request is valid' do
      it 'updates the justification of the term of substitution' do
        find('.fa-bold').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_document_path(document_tso)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([academic.name,
                                       document_tso.document_type.name.upcase,
                                       new_justification])
      end

      it 'updates the new advisor of the term of substitution' do
        selectize(new_advisor.name, from: 'document_advisor_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_document_path(Document.last)
        expect(page).to have_flash(:success, text: message('update.f'))
        expect(page).to have_contents([academic.name,
                                       document_tso.document_type.name.upcase,
                                       new_advisor.name])
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
