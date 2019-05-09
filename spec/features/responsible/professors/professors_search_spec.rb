require 'rails_helper'

describe 'Professor::search', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:professors) { create_list(:professor, 25) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#search' do
    context 'when finds the professor' do
      it 'finds the professor by the name' do
        professor = professors.first

        fill_in 'term', with: professor.name
        first('#search').click

        expect(page).to have_contents([professor.name,
                                       professor.email,
                                       short_date(professor.created_at)])

        expect(page).to have_selector("a[href='#{professor.lattes}']")
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#23123rere'
        first('#search').click

        expect_page_has_content(I18n.t('helpers.no_results'), in: 'table tbody')
      end
    end
  end
end
