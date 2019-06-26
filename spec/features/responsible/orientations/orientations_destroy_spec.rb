require 'rails_helper'

describe 'Orientation::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Orientation.model_name.human }
  let(:signature) { create(:signature) }
  let!(:orientation) { create(:orientation_tcc_one) }

  before do
    login_as(responsible, scope: :professor)
    orientation.signatures << signature
    visit responsible_orientations_tcc_one_path
  end

  describe '#destroy' do
    context 'when orientation is destroyed' do
      it 'show the success message' do
        click_on_destroy_link(responsible_orientation_path(orientation))
        accept_alert

        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(orientation.short_title)
      end
    end

    context 'when the orientation cant be destroyed' do
      before do
        visit responsible_orientations_tcc_one_path
      end

      it 'redirect to the orientations page' do
        click_on_destroy_link(responsible_orientation_path(orientation))
        signature.status = true
        signature.save
        accept_alert

        expect(page).to have_current_path responsible_orientations_tcc_one_path
        expect(page).to have_flash(:warning, text: orientation_destroy_signed_warning_message)
      end
    end
  end
end
