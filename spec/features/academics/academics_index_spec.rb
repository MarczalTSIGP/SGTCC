require 'rails_helper'

describe 'Academics', type: :feature do
  describe '#index' do
    it 'show all academics with options' do
      admin = create(:admin)
      login_as(admin, scope: :admin)

      academics = create_list(:academic, 3)

      visit academics_path

      academics.each do |a|
        expect(page).to have_content(a.name)

        expect(page).to have_link(href: edit_academic_path(a))
        destroy_link = "a[href='#{academic_path(a)}'][data-method='delete']"
        expect(page).to have_css(destroy_link)
      end
    end
  end
end

