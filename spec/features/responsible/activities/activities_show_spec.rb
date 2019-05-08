require 'rails_helper'

describe 'Activity::show', type: :feature do
  let(:responsible) { create(:responsible) }
  let!(:activity) { create(:activity) }

  before do
    login_as(responsible, scope: :professor)
  end

  describe '#show' do
    context 'when shows the activity' do
      it 'shows the activity' do
        visit responsible_calendar_activity_path(activity.calendar, activity)
        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       activity.deadline,
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at)])
      end
    end
  end
end
