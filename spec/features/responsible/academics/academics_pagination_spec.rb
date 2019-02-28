require 'rails_helper'

describe 'Academics::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last academic on second page' do
      it 'finds the last academic', js: true do
        professor = create(:professor)
        login_as(professor, scope: :professor)

        create_list(:academic, 30)
        visit responsible_academics_path
        academic = Academic.order(:name).last

        click_link(2)

        expect(page).to have_content(academic.name)
        expect(page).to have_content(academic.email)
        expect(page).to have_content(academic.ra)
        expect(page).to have_content(academic.created_at.strftime('%d/%m/%Y'))
      end
    end
  end
end
