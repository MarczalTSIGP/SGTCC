require 'rails_helper'

describe 'Academics::pagination', type: :feature, js: true do
  let(:responsible) { create(:responsible) }

  before do
    login_as(responsible, scope: :professor)
    create_list(:academic, 30)
    visit responsible_academics_path
  end

  describe '#pagination' do
    context 'when finds the last academic on second page' do
      it 'finds the last academic' do
        academic = Academic.order(:name).last
        click_link(2)
        expect(page).to have_contents([academic.name,
                                       academic.email,
                                       academic.ra,
                                       academic.created_at.strftime('%d/%m/%Y')])
      end
    end
  end
end
