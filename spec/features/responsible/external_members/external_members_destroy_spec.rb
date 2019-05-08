require 'rails_helper'

describe 'ExternalMember::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:external_member) { create(:external_member) }
  let!(:institution) { create(:institution) }
  let(:resource_name) { ExternalMember.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_external_members_path
  end

  describe '#destroy' do
    context 'when external member is destroyed' do
      it 'show success message' do
        url = responsible_external_member_path(external_member)
        destroy_link = "a[href='#{url}'][data-method='delete']"
        find(destroy_link).click

        accept_alert
        expect(page).to have_flash(:success, text: flash_message('destroy.m', resource_name))
        expect(page).not_to have_content(external_member.name)
      end
    end

    context 'when external member has associations' do
      it 'shows alert message' do
        url = responsible_external_member_path(institution.external_member)
        destroy_link = "a[href='#{url}'][data-method='delete']"
        find(destroy_link).click

        accept_alert
        expect(page).to have_flash(:warning, text: flash_message('destroy.bond', resource_name))
        expect(page).to have_content(institution.external_member.name)
      end
    end
  end
end
