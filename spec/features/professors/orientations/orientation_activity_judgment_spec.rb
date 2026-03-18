require 'rails_helper'

describe 'Orientation::activity_update_judgment', :js do
  let(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:calendar) { orientation.current_calendar }
  let(:activity) { create(:project_activity, calendar: calendar) }
  let(:resource_name) { Activity.model_name.human }

  before do
    create(:academic_activity, activity:, academic: orientation.academic)
    login_as(professor, scope: :professor)
  end

  describe '#view' do
    context 'when the activity can receive advisor judgment' do
      it 'renders the advisor-judgment component with correct endpoint' do
        calendar = orientation.current_calendar
        visit professors_orientation_calendar_activity_path(orientation,
                                                            calendar,
                                                            activity)

        update_url = professors_orientation_activity_update_judgment_path(orientation,
                                                                          calendar,
                                                                          activity)

        expect(page).to have_css("advisor-judgment[url='#{update_url}']", visible: :all)
      end
    end
  end
end
