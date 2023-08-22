require 'rails_helper'

describe 'Academic::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:academics) { create_list(:academic, 3) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#index' do
    context 'when shows all academics' do
      it 'shows all academics with options' do
        visit responsible_academics_path
        academics.each do |academic|
          expect(page).to have_link(academic.name, href: responsible_academic_path(academic))
          expect(page).to have_contents([academic.email,
                                         academic.ra,
                                         short_date(academic.created_at)])
        end
      end
    end
  end
end
