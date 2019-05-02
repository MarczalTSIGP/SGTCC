require 'rails_helper'

describe 'Calendar::show', type: :feature do
  describe '#show' do
    context 'when shows the calendar' do
      it 'shows the calendar' do
        responsible = create(:responsible)
        login_as(responsible, scope: :professor)

        calendar = create(:calendar)
        visit responsible_calendar_path(calendar)

        calendar.activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         short_date(activity.created_at)])
        end
      end
    end
  end
end
