require 'rails_helper'

describe 'Academic::update', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:academic) { create(:academic) }

    before do
      visit edit_responsible_academic_path(academic)
    end

    context 'when data is valid' do
      it 'updates the academic' do
        attributes = attributes_for(:academic)
        new_name = 'Teste'
        fill_in 'academic_name', with: new_name
        fill_in 'academic_email', with: attributes[:email]

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_academic_path(academic)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_content(new_name)
      end
    end

    context 'when the academic is not valid' do
      it 'show errors' do
        fill_in 'academic_name', with: ''
        fill_in 'academic_email', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.academic_name')
        expect(page).to have_message(blank_error_message, in: 'div.academic_email')
      end
    end
  end
end
