require 'rails_helper'

describe 'Orientation::search', type: :feature do
  let(:professor) { create(:professor) }
  let(:orientations) { create_list(:orientation, 2) }

  before do
    login_as(professor, scope: :professor)
    visit professors_orientations_path
  end

  describe '#search', js: true do
    context 'when finds the orientation' do
      it 'finds the orientation by the title' do
        orientation = orientations.first
        fill_in 'term', with: orientation.title
        first('#search').click

        expect(page).to have_contents([orientation.title,
                                       orientation.advisor.name,
                                       orientation.academic.name,
                                       short_date(orientation.created_at)])
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
