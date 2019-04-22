require 'rails_helper'

describe 'ExternalMember::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { ExternalMember.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#destroy' do
    context 'when external member is destroyed', js: true do
      it 'show success message' do
        external_member = create(:external_member)
        visit responsible_external_members_path

        url = responsible_external_member_path(external_member)
        destroy_link = "a[href='#{url}'][data-method='delete']"
        find(destroy_link).click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        success_message = I18n.t('flash.actions.destroy.m',
                                 resource_name: resource_name)

        expect(page).to have_flash(:success, text: success_message)
        expect(page).not_to have_content(external_member.name)
      end
    end

    context 'when external member has associations', js: true do
      it 'shows alert message' do
        institution = create(:institution)
        visit responsible_external_members_path

        url = responsible_external_member_path(institution.external_member)
        destroy_link = "a[href='#{url}'][data-method='delete']"
        find(destroy_link).click

        alert = page.driver.browser.switch_to.alert
        alert.accept
        sleep 2.seconds

        alert_message = I18n.t('flash.actions.destroy.bond',
                               resource_name: resource_name)
        expect(page).to have_flash(:warning, text: alert_message)
        expect(page).to have_content(institution.external_member.name)
      end
    end
  end
end
