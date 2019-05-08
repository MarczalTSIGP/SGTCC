require 'rails_helper'

describe 'ExternalMember::index', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:external_members) { create_list(:external_member, 3) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_external_members_path
  end

  describe '#index' do
    context 'when shows all external members' do
      it 'shows all external members with options', js: true do
        external_members.each do |e|
          expect(page).to have_contents([e.name,
                                         e.email,
                                         short_date(e.created_at)])
          expect(page).to have_selector("a[href='#{e.personal_page}']")
        end
      end
    end
  end
end
