require 'rails_helper'

describe 'Page::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:site_page) { create(:page) }
  let(:resource_name) { Page.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_pages_path
  end

  describe '#destroy' do
    context 'when academic is destroyed' do
      it 'show success message' do
        click_on_destroy_link(responsible_page_path(site_page))
        accept_alert
        expect(page).to have_flash(:success, text: message('destroy.m'))
        expect(page).not_to have_content(site_page.menu_title)
      end
    end
  end
end
