require 'rails_helper'

describe 'TsoRequest::create', :js do
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let(:resource_name) { request_resource_name }

  before do
    create(:responsible)
    login_as(academic, scope: :academic)
  end

  describe '#create' do
    let!(:document_type) { create(:document_type_tso) }

    before do
      create(:current_orientation_tcc_one, advisor:, academic:)
      visit new_academics_tso_request_path
    end

    context 'when request is valid' do
      it 'create a term of substitution' do
        selectize(advisor.name, from: 'document_advisor_id')
        find('.fa-bold').click
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_document_path(Document.last)
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_contents([academic.name,
                                       document_type.name.upcase])
      end
    end

    context 'when request is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_message(blank_error_message, in: 'div.document_advisor_id')
        expect(page).to have_message(blank_error_message, in: 'div.document_justification')
      end
    end
  end
end
