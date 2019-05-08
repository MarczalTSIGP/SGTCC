require 'rails_helper'

describe 'Academics::search', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:academics) { create_list(:academic, 25) }

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

        expect(page).to have_contents([academic.name,
                                       academic.email,
                                       academic.ra,
                                       academic.created_at.strftime('%d/%m/%Y')])
      end
    end

    context 'when the result is not found' do
      it 'returns not found message' do
        fill_in 'term', with: 'a1#\231/ere'
        first('#search').click

        expect(page).to have_message(I18n.t('helpers.no_results'), in: 'table tbody')
      end
    end
  end
end
