require 'rails_helper'

describe 'ExternalMember::update', :js do
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
        attributes = attributes_for(:external_member_inactive)
        fill_in 'external_member_name', with: attributes[:name]
        fill_in 'external_member_email', with: attributes[:email]
        fill_in 'external_member_personal_page', with: attributes[:personal_page]
        gender = I18n.t("enums.genders.#{attributes[:gender]}")
        click_on_label(gender, in: 'external_member_gender')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_external_member_path(external_member)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:name],
                                       attributes[:email],
                                       attributes[:personal_page],
                                       gender])
      end
    end

    context 'when data is not valid' do
      it 'show errors' do
        fill_in 'external_member_name', with: ''
        fill_in 'external_member_email', with: ''

        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.external_member_name')
        expect(page).to have_message(blank_error_message, in: 'div.external_member_email')
      end
    end
  end
end
