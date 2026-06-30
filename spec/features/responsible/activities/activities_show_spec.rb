require 'rails_helper'

describe 'Activity::show' do
  let(:responsible)     { create(:responsible) }
  let(:calendar)        { create(:calendar, :current, :tcc_one) }
  let!(:activity)       { create(:activity, calendar: calendar) }
  let(:orientation_one) { create(:orientation, calendar_ids: [calendar.id]) }
  let(:orientation_two) { create(:orientation, calendar_ids: [calendar.id]) }

  before do
    create(:academic_activity, academic: orientation_one.academic, activity:)

    login_as(responsible, scope: :professor)
    visit responsible_calendar_activity_path(calendar, activity)
  end

  it_behaves_like 'activity show basic information'

  context 'with responses' do
    it 'show all' do
      expect_activity_responses
    end

    it 'has link when sent' do
      url = responsible_orientation_calendar_activity_path(orientation_one, calendar,
                                                           activity)
      expect_sent_activity_response_link(url)
    end

    it 'has no link when no sent' do
      url = responsible_orientation_calendar_activity_path(orientation_two, calendar,
                                                           activity)

      expect_no_sent_activity_response_link(url)
    end
  end
end
