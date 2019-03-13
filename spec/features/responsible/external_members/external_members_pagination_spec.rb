require 'rails_helper'

describe 'ExternalMember::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last external member on second page' do
      it 'finds the last external member', js: true do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        create_list(:external_member, 30)
        visit responsible_external_members_path
        external_member = ExternalMember.order(:name).last
        click_link(2)

        expect(page).to have_contents([external_member.name,
                                       external_member.email,
                                       external_member.created_at.strftime('%d/%m/%Y')])
      end
    end
  end
end
