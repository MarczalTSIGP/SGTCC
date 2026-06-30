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
      let(:destroy_path) { responsible_external_member_path(external_member) }
      let(:destroyed_record_name) { external_member.name }

      it_behaves_like 'responsible destroy success flow', message_key: 'destroy.m'
    end

    context 'when external member has associations' do
      it 'shows alert message' do
        click_on_destroy_link(responsible_external_member_path(institution.external_member))
        accept_alert

        expect(page).to have_flash(:warning, text: message('destroy.bond'))
        expect(page).to have_text(institution.external_member.name)
      end
    end
  end
end
