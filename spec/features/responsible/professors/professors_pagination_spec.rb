require 'rails_helper'

describe 'Professor::pagination', type: :feature do
  describe '#pagination' do
    context 'when finds the last professor on second page' do
      it 'finds the last professor', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        create_list(:professor, 30)
        visit responsible_professors_path
        professor = Professor.order(:name).last

        click_link(2)

        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.username,
                                       professor.created_at.strftime('%d/%m/%Y')])
      end
    end
  end
end
