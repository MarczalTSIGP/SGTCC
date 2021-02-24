require 'rails_helper'

describe 'Professor::pagination', type: :feature, js: true do
  let(:responsible) { create(:responsible) }

  before do
    login_as(responsible, scope: :professor)
    create_list(:professor, 30)
    visit responsible_professors_path
  end

  describe '#pagination' do
    context 'when finds the last professor on second page' do
      it 'finds the last professor' do
        professor = Professor.order(:name).last
        click_link('2')
        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       professor.username,
                                       short_date(professor.created_at)])
        expect(page).to have_selector(link(professor.lattes))
      end
    end
  end
end
