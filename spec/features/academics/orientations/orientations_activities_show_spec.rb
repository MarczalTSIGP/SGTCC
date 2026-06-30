require 'rails_helper'

describe 'Orientation::activities show', :js do
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:academic) { orientation.academic }
  let(:calendar) { orientation.current_calendar }
  let(:active_link) { academics_calendars_path }
  let(:activity) { create(:activity, calendar: calendar) }
  let(:academic_activity) { create(:academic_activity, academic:, activity:) }

  before do
    academic_activity
    login_as(academic, scope: :academic)
    visit academics_calendar_orientation_activity_path(calendar, orientation, activity)
  end

  it_behaves_like 'orientation activity show page'
end
