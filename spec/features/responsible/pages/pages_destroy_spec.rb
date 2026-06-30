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
      let(:destroy_path) { responsible_page_path(site_page) }
      let(:destroyed_record_name) { site_page.menu_title }

      it_behaves_like 'responsible destroy success flow', message_key: 'destroy.m'
    end
  end
end
