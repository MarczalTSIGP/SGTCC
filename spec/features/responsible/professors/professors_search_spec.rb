require 'rails_helper'

describe 'Professor::search', type: :feature do
  let(:responsible) { create(:professor) }
  let(:professors) { create_list(:professor, 25) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_professors_path
  end

  describe '#search' do
    context 'when finds the professor' do
      it 'finds the professor by the name', js: true do
        professor = professors.first

        fill_in 'term', with: professor.name
        first('#search').click

        expect(page).to have_content(professor.name)
        expect(page).to have_content(professor.email)
        expect(page).to have_content(professor.username)
        expect(page).to have_content(professor.created_at.strftime('%d/%m/%Y'))
      end
    end

    context 'when the result is not found' do
      it 'returns not found message', js: true do
        fill_in 'term', with: 'a1#23123rere'
        first('#search').click

        not_found_message = I18n.t('helpers.no_results')

        within('table tbody') do
          expect(page).to have_content(not_found_message)
        end
      end
    end
  end
end
