require 'rails_helper'

describe 'ExternalMember::create', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { ExternalMember.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_external_member_path
    end

    context 'when external member is valid' do
      it 'create an external member' do
        attributes = attributes_for(:external_member)
        fill_in 'external_member_name', with: attributes[:name]
        fill_in 'external_member_email', with: attributes[:email]
        fill_in 'external_member_password', with: attributes[:password]
        fill_in 'external_member_password_confirmation', with: attributes[:password_confirmation]
        fill_in 'external_member_personal_page', with: attributes[:personal_page]
        click_on_label(ExternalMember.human_genders.first[0],
                       in: 'external_member_gender')
        click_on_label(ExternalMember.human_attribute_name('is_active'),
                       in: 'external_member_is_active')
        find('.fa-bold').click
        selectize(Scholarity.first.name, from: 'external_member_scholarity_id')
        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_external_members_path
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when external member is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.external_member_name')
        expect(page).to have_message(blank_error_message, in: 'div.external_member_email')
        expect(page).to have_message(blank_error_message, in: 'div.external_member_gender')
        expect(page).to have_message(blank_error_message, in: 'div.external_member_working_area')
      end
    end
  end
end
