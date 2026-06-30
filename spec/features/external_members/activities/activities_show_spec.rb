require 'rails_helper'

describe 'Activity::show' do
  let(:external_member) { create(:external_member) }
  let(:calendar)        { create(:calendar, :current, :tcc_one) }
  let(:activity)        { create(:project_activity, calendar: calendar) }
  let(:orientation_one) { create(:orientation, calendar_ids: [calendar.id]) }
  let(:orientation_two) { create(:orientation, calendar_ids: [calendar.id]) }

  before do
    create(:academic_activity, academic: orientation_one.academic, activity:)

    login_as(external_member, scope: :external_member)
    visit external_members_calendar_activity_path(calendar, activity)
  end

  it_behaves_like 'activity show basic information'

  context 'with responses' do
    it 'show all' do
      expect_activity_responses(show_response_links: false)
    end
  end
end
