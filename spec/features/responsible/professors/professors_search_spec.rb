require 'rails_helper'

describe 'Professor::search', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:professors) { create_list(:professor_tcc_one, 25) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#search' do
    context 'when finds the professor' do
      it 'finds the professor by the name' do
        fill_in 'term', with: responsible.name
        first('#search').click

        expect(page).to have_contents([responsible.name,
                                       responsible.email,
                                       short_date(responsible.created_at)])
        expect(page).to have_selector(link(responsible.lattes))
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#23123rere'
        first('#search').click
        expect(page).to have_message(no_results_message, in: 'table tbody')
      end
    end
  end
end
