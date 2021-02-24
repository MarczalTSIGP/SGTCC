require 'rails_helper'

describe 'Page::create', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Page.model_name.human }

  before do
    create(:site)
    login_as(responsible, scope: :professor)
  end

  describe '#create' do
    before do
      visit new_responsible_page_path
    end

    context 'when page is valid' do
      it 'create a page' do
        attributes = attributes_for(:page)
        fill_in 'page_menu_title', with: attributes[:menu_title]
        fill_in 'page_url', with: attributes[:url]
        fill_in 'page_fa_icon', with: attributes[:fa_icon]
        find('.fa-bold').click ## fill markdown editor

        submit_form('input[name="commit"]')

        expect(page).to have_current_path responsible_pages_path
        expect(page).to have_flash(:success, text: message('create.m'))
        expect(page).to have_message(attributes[:name], in: 'table tbody')
      end
    end

    context 'when page is not valid' do
      it 'show errors' do
        submit_form('input[name="commit"]')
        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.page_menu_title')
        expect(page).to have_message(blank_error_message, in: 'div.page_url')
        expect(page).to have_message(blank_error_message, in: 'div.page_fa_icon')
        expect(page).to have_message(blank_error_message, in: 'div.page_content')
      end
    end
  end
end
