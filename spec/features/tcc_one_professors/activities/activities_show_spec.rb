require 'rails_helper'

describe 'Activity::show' do
  let(:professor_tcc_one) { create(:professor_tcc_one) }
  let(:calendar)          { create(:calendar, :current, :tcc_one) }
  let!(:activity)         { create(:activity, calendar: calendar) }
  let(:orientation_one)   { create(:orientation, calendar_ids: [calendar.id]) }
  let(:orientation_two)   { create(:orientation, calendar_ids: [calendar.id]) }

  before do
    create(:academic_activity, academic: orientation_one.academic, activity:)

    login_as(professor_tcc_one, scope: :professor)
    visit tcc_one_professors_calendar_activity_path(calendar, activity)
  end

  it_behaves_like 'activity show basic information'

  context 'with responses' do
    it 'show all' do
      expect_activity_responses
    end

    it 'has link when sent' do
      url = tcc_one_professors_orientation_calendar_activity_path(orientation_one, calendar,
                                                                  activity)
      expect_sent_activity_response_link(url)
    end

    it 'has no link when no sent' do
      url = tcc_one_professors_orientation_calendar_activity_path(orientation_two, calendar,
                                                                  activity)

      expect_no_sent_activity_response_link(url)
    end
  end
end
