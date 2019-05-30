require 'rails_helper'

describe 'Orientation::renew', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:calendar) { create(:calendar_tcc_two, semester: 1) }
  let(:current_orientation_tcc_two) { create(:orientation, calendar: calendar) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientation_path(current_orientation_tcc_two)
  end

  describe '#show', js: true do
    context 'when the renew the tcc two orientation is valid' do
      before do
        create(:calendar_tcc_two, semester: 2, year: calendar.year)
      end

      it 'show success message and update the status' do
        find('button[id="renew_justification"]', text: orientation_renew_button).click
        fill_in 'orientation_renewal_justification', with: 'Justification'
        find('button[id="save_justification"]', text: save_button).click
        expect(page).to have_flash(:success, text: message('update.f'))
        current_orientation_tcc_two.reload
        status = Orientation.statuses[current_orientation_tcc_two.status]
        expect(page).to have_content(status)
      end
    end

    context 'when the renew the tcc two orientation is invalid' do
      it 'show blank error message' do
        find('button[id="renew_justification"]', text: orientation_renew_button).click
        find('button[id="save_justification"]', text: save_button).click
        expect(page).to have_message(blank_error_message,
                                     in: 'div.orientation_renewal_justification')
      end

      it 'show calendar error message' do
        find('button[id="renew_justification"]', text: orientation_renew_button).click
        fill_in 'orientation_renewal_justification', with: 'Justification'
        find('button[id="save_justification"]', text: save_button).click
        expect(page).to have_message(orientation_renew_calendar_error_message,
                                     in: 'div.orientation_renewal_justification')
      end
    end
  end
end
