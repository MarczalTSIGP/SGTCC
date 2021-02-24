require 'rails_helper'

describe 'Orientation::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let(:resource_name) { Orientation.model_name.human }
  let!(:orientation) { create(:orientation_tcc_one) }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientations_tcc_one_path
  end

  describe '#destroy' do
    context 'when orientation is destroyed' do
      it 'show the success message' do
        find('table.table tbody a[data-toggle="dropdown"] i').click

        click_on_destroy_link(responsible_orientation_path(orientation))
        accept_confirm

        expect(page).to have_flash(:success, text: message('destroy.f'))
        expect(page).not_to have_content(orientation.short_title)
      end
    end

    context 'when the orientation cant be destroyed' do
      before do
        orientation.signatures << Signature.all
        orientation.signatures.each(&:sign)
        visit responsible_orientations_tcc_one_path
      end

      it 'redirect to the orientations page' do
        # TODO: need a request test to test the controller answer
        find('table.table tbody a[data-toggle="dropdown"] i').click
        href = "a[href='#{responsible_orientation_path(orientation)}'][data-method='delete']"
        expect(page).not_to have_selector(:css, href)
      end
    end
  end
end
