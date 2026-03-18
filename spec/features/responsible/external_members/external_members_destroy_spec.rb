require 'rails_helper'

describe 'ExternalMember::destroy', :js do
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
        click_on_destroy_link(responsible_external_member_path(external_member))
        accept_alert

        expect(page).to have_flash(:success, text: message('destroy.m'))
        expect(page).to have_no_content(external_member.name)
      end
    end

    context 'when external member has associations' do
      it 'shows alert message' do
        click_on_destroy_link(responsible_external_member_path(institution.external_member))
        accept_alert

        expect(page).to have_flash(:warning, text: message('destroy.bond'))
        expect(page).to have_content(institution.external_member.name)
      end
    end
  end
end
