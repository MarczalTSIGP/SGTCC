require 'rails_helper'

describe 'Activity::show', type: :feature do
  describe '#show' do
    context 'when shows the activity' do
      it 'shows the activity' do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        calendar = create(:calendar_tcc_one)
        activity = create(:activity_tcc_one, calendar: calendar)
        visit responsible_calendar_activity_path(calendar.id, activity)

        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at)])
      end
    end
  end
end
