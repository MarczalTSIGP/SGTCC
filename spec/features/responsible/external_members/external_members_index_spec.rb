require 'rails_helper'

describe 'ExternalMember::index', type: :feature do
  describe '#index' do
    context 'when shows all external members' do
      it 'shows all external members with options', js: true do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        external_members = create_list(:external_member, 3)

        visit responsible_external_members_path

        external_members.each do |e|
          expect(page).to have_contents([e.name,
                                         e.email,
                                         e.created_at.strftime('%d/%m/%Y')])
        end
      end
    end
  end
end
