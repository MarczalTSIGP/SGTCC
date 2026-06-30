require 'rails_helper'

describe 'Page::update', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Page.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:site_page) { create(:page) }

    before do
      visit edit_responsible_page_path(site_page)
    end

    context 'when data is valid' do
      it 'updates the page' do
        attributes = attributes_for(:page)
        fill_in 'page_menu_title', with: attributes[:menu_title]
        fill_in 'page_url', with: attributes[:url]
        fill_in 'page_fa_icon', with: attributes[:fa_icon]

        find('label[for="page_fa_icon"]').click
        expect(page).to have_no_css('.preview-container .previewer', visible: :visible, wait: 1)

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_page_path(site_page)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:menu_title],
                                       attributes[:url]])
      end
    end

    context 'when the page is not valid' do
      it_behaves_like 'responsible update blank errors',
                      fields: %w[page_menu_title page_url],
                      selectors: [
                        ['div.page_menu_title'],
                        ['div.page_url']
                      ]
    end
  end
end
