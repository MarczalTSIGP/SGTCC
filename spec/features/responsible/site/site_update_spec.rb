require 'rails_helper'

describe 'Site::update', :js do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Site.model_name.human }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#update' do
    let(:site) { create(:site) }

    before do
      visit edit_responsible_site_path(site)
    end

    context 'when data is valid' do
      it 'updates the site' do
        attributes = attributes_for(:site)
        fill_in 'site_title', with: attributes[:title]
        submit_form('input[name="commit"]')

        expect(page).to have_current_path edit_responsible_site_path(site)
        expect(page).to have_flash(:success, text: message('update.m'))
      end
    end

    context 'when the site is not valid' do
      it 'show errors' do
        fill_in 'site_title', with: ''
        submit_form('input[name="commit"]')

        expect(page).to have_flash(:danger, text: errors_message)
        expect(page).to have_message(blank_error_message, in: 'div.site_title')
      end
    end
  end
end
