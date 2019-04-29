require 'rails_helper'

describe 'Orientation::search', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:orientations) { create_list(:orientation, 2) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientations_path
  end

  describe '#search', js: true do
    context 'when finds the orientation' do
      it 'finds the orientation by the title' do
        orientation = orientations.first
        fill_in 'term', with: orientation.title
        first('#search').click

        expect(page).to have_contents([orientation.title,
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
