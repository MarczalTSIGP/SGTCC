require 'rails_helper'

describe 'Orientation::destroy', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:orientation) { create(:orientation_tcc_one) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientations_tcc_one_path
  end

  describe '#destroy' do
    context 'when orientation is destroyed', js: true do
      it 'show the success message' do
        click_on_destroy_link(responsible_orientation_path(orientation))
        accept_alert

        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(orientation.short_title)
      end
    end
  end
end
