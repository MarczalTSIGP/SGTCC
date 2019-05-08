require 'rails_helper'

describe 'ExternalMember::create', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { ExternalMember.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_external_member_path
    end

    context 'when external member is valid', js: true do
      it 'create an external member' do
        attributes = attributes_for(:external_member)
        fill_in 'external_member_name', with: attributes[:name]
        fill_in 'external_member_email', with: attributes[:email]
        fill_in 'external_member_password', with: attributes[:password]
        fill_in 'external_member_password_confirmation', with: attributes[:password_confirmation]
        fill_in 'external_member_personal_page', with: attributes[:personal_page]
        find('span', text: ExternalMember.human_genders.first[0]).click
        find('.fa-bold').click
        selectize(Scholarity.first.name, from: 'external_member_scholarity_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_external_members_path
        success_message = I18n.t('flash.actions.create.m',
                                 resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when external member is not valid', js: true do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))

        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.external_member_name')
        expect(page).to have_message(message_blank_error, in: 'div.external_member_email')
        expect(page).to have_message(message_blank_error, in: 'div.external_member_gender')
        expect(page).to have_message(message_blank_error, in: 'div.external_member_personal_page')
        expect(page).to have_message(message_blank_error, in: 'div.external_member_working_area')
      end
    end
  end
end
