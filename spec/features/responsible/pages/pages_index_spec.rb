require 'rails_helper'

describe 'Page::index', type: :feature, js: true do
  let(:responsible) { create(:responsible) }

  before do
    login_as(responsible, scope: :professor)
    create_list(:page, 3)
    visit responsible_pages_path
  end

  describe '#index' do
    context 'when shows all pages' do
      it 'shows all pages with options' do
        Page.all do |page|
          expect(page).to have_contents([page.menu_title,
                                         short_date(page.created_at),
                                         short_date(page.updated_at)])
        end
      end
    end
  end
end
