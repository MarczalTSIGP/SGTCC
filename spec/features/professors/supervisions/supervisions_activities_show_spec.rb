require 'rails_helper'

describe 'Supervision::activities', :js do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:academic) { orientation.academic }
  let(:calendar) { orientation.current_calendar }
  let(:active_link) { professors_supervisions_tcc_one_path }

  before do
    orientation.professor_supervisors << professor
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when show the activity by orientation' do
      let!(:activity) { create(:activity, calendar: calendar) }
      let(:academic_activity) { create(:academic_activity, academic:, activity: activity) }

      before do
        academic_activity
        visit professors_supervision_calendar_activity_path(orientation, calendar, activity)
      end

      it_behaves_like 'orientation activity show page'
    end
  end
end
