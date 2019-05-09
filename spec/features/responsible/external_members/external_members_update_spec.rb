require 'rails_helper'

describe 'ExternalMember::update', type: :feature, js: true do
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

    context 'when data is valid' do
      it 'updates the external_member' do
        new_name = 'Teste'

        fill_in 'external_member_name', with: new_name
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_external_member_path(external_member)
        expect(page).to have_flash(:success, text: flash_message('update.m', resource_name))
        expect(page).to have_content(new_name)
      end
    end

    context 'when data is not valid' do
      it 'show errors' do
        fill_in 'external_member_name', with: ''
        fill_in 'external_member_email', with: ''

        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: I18n.t('flash.actions.errors'))
        expect_page_has_content(message_blank_error, in: 'div.external_member_name')
        expect_page_has_content(message_blank_error, in: 'div.external_member_email')
      end
    end
  end
end
