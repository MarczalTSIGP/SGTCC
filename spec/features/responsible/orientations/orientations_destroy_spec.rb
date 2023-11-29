require 'rails_helper'

describe 'Orientation::destroy', :js do
  let(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation_tcc_one) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientations_tcc_one_path
  end

  describe '#destroy' do
    context 'when orientation is destroyed' do
      it 'shows the success message' do
        within('table.table tbody tr', text: orientation.academic.name) do
          find('.dropdown').click
          click_link('Remover', match: :first)
          page.driver.browser.switch_to.alert.accept
        end

        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(orientation.short_title)
      end
    end
  end
end
