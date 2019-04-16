require 'rails_helper'

describe 'ExternalMember::update', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { ExternalMember.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:external_member) { create(:external_member) }

    before do
      visit edit_responsible_external_member_path(external_member)
    end

    context 'when data is valid', js: true do
      it 'updates the external_member' do
        new_name = 'Teste'

        fill_in 'external_member_name', with: new_name
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_external_member_path(external_member)
        success_message = I18n.t('flash.actions.update.m',
                                 resource_name: resource_name)
        expect(page).to have_flash(:success, text: success_message)
        expect(page).to have_content(new_name)
      end
    end

    context 'when data is not valid', js: true do
      it 'show errors' do
        fill_in 'external_member_name', with: ''
        fill_in 'external_member_email', with: ''

        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))

        message_blank_error = I18n.t('errors.messages.blank')
        expect(page).to have_message(message_blank_error, in: 'div.external_member_name')
        expect(page).to have_message(message_blank_error, in: 'div.external_member_email')
      end
    end
  end
end
