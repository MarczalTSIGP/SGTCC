require 'rails_helper'

describe 'Academics::search', :js do
  let(:responsible) { create(:responsible) }
  let(:academics) { create_list(:academic, 10) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_academics_path
  end

  describe '#search' do
    context 'when finds the academic' do
      it 'finds the academic by the name' do
        academic = academics.first

        fill_in 'term', with: academic.name
        first('#search').click

        expect(page).to have_link(academic.name, href: responsible_academic_path(academic))
        expect(page).to have_contents([academic.email,
                                       academic.ra,
                                       short_date(academic.created_at)])
      end
    end

    it_behaves_like 'responsible search with no results', 'a1#\231/ere'
  end
end
