require 'rails_helper'

describe 'Academic::create', type: :feature do
  let(:responsible) { create(:professor) }
  let(:resource_name) { Academic.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_academic_path
    end

    context 'when academic is valid', js: true do
      it 'create an academic' do
        attributes = attributes_for(:academic)
        fill_in 'academic_name',   with: attributes[:name]
        fill_in 'academic_email',  with: attributes[:email]
        fill_in 'academic_ra',     with: attributes[:ra]
        find('span', text: Professor.human_genders.first[0]).click

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_academics_path

        success_message = I18n.t('flash.actions.create.m', resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when academic is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))

        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.academic_name')
        expect(page).to have_message(message_blank_error, in: 'div.academic_email')
        expect(page).to have_message(message_blank_error, in: 'div.academic_ra')
        expect(page).to have_message(message_blank_error, in: 'div.academic_gender')
      end
    end
  end
end
