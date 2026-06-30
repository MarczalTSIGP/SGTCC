require 'rails_helper'

describe 'Orientation::activities', :js do
  let!(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:academic) { orientation.academic }
  let(:activities) { orientation.current_calendar.activities }
  let(:active_link) { professors_orientations_tcc_one_path }

  before do
    create(:project_activity, calendar: orientation.current_calendar)
    login_as(professor, scope: :professor)
  end

  describe '#show' do
    context 'when show the activity by orientation' do
      let(:activity) { activities.first }
      let(:academic_activity) { create(:academic_activity, academic:, activity:) }

      before do
        academic_activity
        visit professors_orientation_calendar_activity_path(orientation,
                                                            orientation.current_calendar,
                                                            activity)
      end

      it_behaves_like 'orientation activity show page'
    end
  end
end
