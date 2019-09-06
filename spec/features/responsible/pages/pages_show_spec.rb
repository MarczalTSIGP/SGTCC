require 'rails_helper'

describe 'Page::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:site_page) { create(:page) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_page_path(site_page)
  end

  describe '#show' do
    it 'shows the page' do
      expect(page).to have_contents([site_page.menu_title,
                                     site_page.url,
                                     site_page.fa_icon,
                                     complete_date(site_page.created_at),
                                     complete_date(site_page.updated_at)])
    end
  end
end
