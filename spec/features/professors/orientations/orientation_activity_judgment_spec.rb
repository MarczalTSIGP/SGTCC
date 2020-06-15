require 'rails_helper'

describe 'Orientation::activity_update_judgment', type: :feature, js: true do
  let(:orientation) { create(:orientation) }
  let(:activity) { orientation.calendar.activities.first }
  let(:professor) { orientation.advisor }
  let(:resource_name) { Activity.model_name.human }

  before do
    create(:academic_activity, activity: activity, academic: orientation.academic)
    login_as(professor, scope: :professor)
  end

  describe '#view' do
    context 'when mark as viewed the activity' do
      it 'shows success message' do
        visit professors_orientation_activity_path(orientation, activity)

        click_on_label(confirm_judgment_label, in: 'academic_activity_judgment')
        expect(page).to have_alert(text: 'Você tem certeza que deseja dar ciência nessa atividade?')

        find('.swal-button--danger', match: :first).click
        expect(page).to have_alert(text: message('update.f'))
      end
    end
  end
end
