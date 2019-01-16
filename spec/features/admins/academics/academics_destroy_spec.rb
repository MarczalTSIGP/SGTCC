require 'rails_helper'

describe 'Academics::destroy', type: :feature do
  let(:admin) { create(:admin) }
  let(:resource_name) { Academic.model_name.human }

  before(:each) do
    login_as(admin, scope: :admin)
  end

  describe '#destroy' do
    it 'academic' do
      academic = create(:academic)
      visit admins_academics_path

      within first('.destroy').click

      expect(page).to have_selector('div.alert.alert-success',
                                    text: I18n.t('flash.actions.destroy.m',
                                                 resource_name: resource_name))
      within('table tbody') do
        expect(page).not_to have_content(academic.name)
      end
    end
  end
end
