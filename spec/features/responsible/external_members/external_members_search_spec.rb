require 'rails_helper'

describe 'ExternalMember::search', :js do
  let(:responsible) { create(:responsible) }
  let(:external_members) { create_list(:external_member, 10) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_external_members_path
  end

  describe '#search' do
    context 'when finds the external member' do
      it 'finds the external member by the name' do
        external_member = external_members.first

        fill_in 'term', with: external_member.name
        first('#search').click

        expect(page).to have_link(external_member.name,
                                  href: responsible_external_member_path(external_member))
        expect(page).to have_contents([external_member.email,
                                       short_date(external_member.created_at)])
        expect(page).to have_selector(link(external_member.personal_page))
      end
    end

    it_behaves_like 'responsible search with no results', 'a1#23123rere'
  end
end
