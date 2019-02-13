require 'rails_helper'

describe 'Academics', type: :feature do
  describe '#index' do
    it 'show all academics with options', js: true do
      professor = create(:professor)
      login_as(professor, scope: :professor)

      academics = create_list(:academic, 3)

      visit professors_academics_path

      academics.each do |a|
        expect(page).to have_content(a.name)
        expect(page).to have_content(a.email)
        expect(page).to have_content(a.ra)
      end
    end
  end
end
