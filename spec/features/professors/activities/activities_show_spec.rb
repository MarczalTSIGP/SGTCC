require 'rails_helper'

describe 'Activity::show', type: :feature do
  let(:professor) { create(:professor) }
  let(:activity) { create(:activity) }

  describe '#show' do
    before do
      login_as(professor, scope: :professor)
      visit professors_calendar_activity_path(activity.calendar, activity)
    end

    context 'when shows the activity' do
      it 'shows the activity' do
        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       activity.deadline,
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at)])
      end
    end
  end
end
