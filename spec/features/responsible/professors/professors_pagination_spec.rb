require 'rails_helper'

describe 'Professor::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last professor on second page' do
      it 'finds the last professor', js: true do
        responsible = create(:professor)
        login_as(responsible, scope: :professor)

        create_list(:professor, 30)
        visit responsible_professors_path
        professor = Professor.order(:name).last

        click_link(2)

        expect(page).to have_content(professor.name)
        expect(page).to have_content(professor.email)
        expect(page).to have_content(professor.username)
        expect(page).to have_content(professor.created_at.strftime('%d/%m/%Y'))
      end
    end
  end
end
