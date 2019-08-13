require 'rails_helper'

describe 'Orientation::substitution', type: :feature do
  let!(:academic) { create(:academic) }
  let!(:advisor) { create(:professor) }
  let!(:orientation) do
    create(:current_orientation_tcc_one, advisor: advisor, academic: academic)
  end
  let!(:document_type) { create(:document_type_tso) }
  let(:resource_name) { request_resource_name }

  before do
    create(:responsible)
    login_as(academic, scope: :academic)
  end

  describe '#create' do
    before do
      visit new_academics_tso_request_path
    end

    context 'when request is valid', js: true do
      it 'create a term of substitution' do
        selectize(advisor.name, from: 'document_advisor_id')
        fill_in 'document_justification', with: 'justification'
        submit_form('input[name="commit"]')

        expect(page).to have_current_path academics_tso_requests_path
        expect(page).to have_flash(:success, text: message('create.f'))
        expect(page).to have_contents([orientation.title,
                                       document_type.identifier.upcase])
      end
    end

    context 'when request is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_message(blank_error_message, in: 'div.document_advisor_id')
        expect(page).to have_message(blank_error_message, in: 'div.document_justification')
      end
    end
  end
end