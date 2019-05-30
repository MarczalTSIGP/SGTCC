require 'rails_helper'

describe 'Orientation::renew', type: :feature do
  let(:responsible) { create(:responsible) }
  let(:current_calendar_tcc_two) { create(:current_calendar_tcc_two) }
  let(:current_orientation_tcc_two) { create(:orientation, calendar: current_calendar_tcc_two) }
  let(:resource_name) { Orientation.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_orientation_path(current_orientation_tcc_two)
  end

  describe '#show', js: true do
    context 'when the renew the tcc two orientation is valid' do
      before do
        calendar = current_calendar_tcc_two
        year = calendar.year
        if calendar.semester == 'one'
          create(:calendar_tcc_two, semester: 2, year: year)
        else
          create(:calendar_tcc_two, semester: 1, year: year.to_i + 1)
        end
      end

      it 'show success message and update the status' do
        find('button[id="renew_justification"]', text: 'Renovar orientação').click
        fill_in 'orientation_renewal_justification', with: 'Teste'
        find('button[id="save_justification"]', text: 'Salvar').click
        expect(page).to have_flash(:success, text: message('update.f'))
        current_orientation_tcc_two.reload
        status = Orientation.statuses[current_orientation_tcc_two.status]
        expect(page).to have_content(status)
      end
    end

    context 'when the renew the tcc two orientation is invalid' do
      it 'show blank error message' do
        find('button[id="renew_justification"]', text: 'Renovar orientação').click
        find('button[id="save_justification"]', text: 'Salvar').click
        expect(page).to have_message(blank_error_message,
                                     in: 'div.orientation_renewal_justification')
      end

      it 'show calendar error message' do
        find('button[id="renew_justification"]', text: 'Renovar orientação').click
        fill_in 'orientation_renewal_justification', with: 'Teste'
        find('button[id="save_justification"]', text: 'Salvar').click
        expect(page).to have_message(orientation_renew_calendar_error_message,
                                     in: 'div.orientation_renewal_justification')
      end
    end
  end
end
