require 'rails_helper'

describe 'Academics::search', type: :feature do
  let(:professor) { create(:professor) }
  let(:academics) { create_list(:academic, 25) }

  before do
    login_as(professor, scope: :professor)
    visit responsible_academics_path
  end

  describe '#search' do
    context 'when finds the academic' do
      it 'finds the academic by the name', js: true do
        academic = academics.first

        fill_in 'term', with: academic.name
        first('#search').click

        expect(page).to have_content(academic.name)
        expect(page).to have_content(academic.email)
        expect(page).to have_content(academic.ra)
        expect(page).to have_content(academic.created_at.strftime('%d/%m/%Y'))
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
