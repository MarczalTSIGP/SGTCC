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

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_page_path(site_page)
        expect(page).to have_flash(:success, text: message('update.m'))
        expect(page).to have_contents([attributes[:menu_title],
                                       attributes[:url]])
      end
    end

    context 'when the page is not valid' do
      it 'show errors' do
        fill_in 'page_menu_title', with: ''
        fill_in 'page_url', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.page_menu_title')
        expect(page).to have_message(blank_error_message, in: 'div.page_url')
      end
    end
  end
end
