require 'rails_helper'

describe 'Academic::index', type: :feature do
  describe '#index' do
    context 'when shows all academics' do
      it 'shows all academics with options', js: true do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        academics = create_list(:academic, 3)

        visit responsible_academics_path

        academics.each do |a|
          expect(page).to have_contents([a.name,
                                         a.email,
                                         a.ra,
                                         short_date(a.created_at)])
        end
      end
    end
  end
end
