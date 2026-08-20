require 'rails_helper'

describe 'Activity::show' do
  let(:professor)       { create(:professor) }
  let(:calendar)        { create(:calendar, :current, :tcc_one) }
  let(:activity)        { create(:activity, :project, calendar: calendar) }
  let(:orientation_one) { create(:orientation, calendar_ids: [calendar.id]) }
  let(:orientation_two) { create(:orientation, calendar_ids: [calendar.id]) }

  before do
    create(:academic_activity, academic: orientation_one.academic, activity:)

    login_as(professor, scope: :professor)
    visit professors_calendar_activity_path(calendar, activity)
  end

  it_behaves_like 'activity show basic information'

  context 'with responses' do
    it 'show all' do
      expect_activity_responses(show_response_links: false)
    end
  end
end
