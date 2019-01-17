require 'rails_helper'

describe 'Academics', type: :feature do
  describe '#index' do
    it 'show all academics with options' do
      admin = create(:admin)
      login_as(admin, scope: :admin)

      academics = create_list(:academic, 3)

      visit admins_academics_path

      academics.each do |a|
        expect(page).to have_content(a.name)
        expect(page).to have_content(a.email)
        expect(page).to have_content(a.ra)
        expect(page).to have_content(complete_date(a.created_at))

        expect(page).to have_link(href: edit_admins_academic_path(a))
        destroy_link = "a[href='#{admins_academic_path(a)}'][data-method='delete']"
        expect(page).to have_css(destroy_link)
      end
    end
  end
end

