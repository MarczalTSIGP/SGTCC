require 'rails_helper'

describe 'Academic::create', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_academic_path
    end

    context 'when academic is valid' do
      it 'create an academic' do
        attributes = attributes_for(:academic)
        fill_in 'academic_name',   with: attributes[:name]
        fill_in 'academic_email',  with: attributes[:email]
        fill_in 'academic_ra',     with: attributes[:ra]
        click_on_label(Professor.human_genders.first[0], in: 'academic_gender')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_academics_path
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when academic is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.academic_name')
        expect(page).to have_message(blank_error_message, in: 'div.academic_email')
        expect(page).to have_message(blank_error_message, in: 'div.academic_gender')
        expect(page).to have_message(blank_error_message, in: 'div.academic_ra')
      end
    end
  end
end
