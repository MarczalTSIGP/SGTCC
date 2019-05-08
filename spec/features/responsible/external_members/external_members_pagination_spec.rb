require 'rails_helper'

describe 'ExternalMember::pagination', type: :feature do
  let(:responsible) { create(:responsible) }

  before do
    login_as(responsible, scope: :professor)
    create_list(:external_member, 30)
    visit responsible_external_members_path
  end

  describe '#pagination' do
    context 'when finds the last external member on second page' do
      it 'finds the last external member', js: true do
        external_member = ExternalMember.order(:name).last
        click_link(2)
        expect(page).to have_contents([external_member.name,
                                       external_member.email,
                                       short_date(external_member.created_at)])
      end
    end
  end
end
