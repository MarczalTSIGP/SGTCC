require 'rails_helper'

describe 'ExternalMember::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:external_members) { create_list(:external_member, 3) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_external_members_path
  end

  describe '#index' do
    context 'when shows all external members' do
      it 'shows all external members with options' do
        external_members.each do |external_member|
          expect(page).to have_link(external_member.name,
                                    href: responsible_external_member_path(external_member))
          expect(page).to have_contents([external_member.email,
                                         short_date(external_member.created_at)])
          expect(page).to have_selector(link(external_member.personal_page))
        end
      end
    end
  end
end
