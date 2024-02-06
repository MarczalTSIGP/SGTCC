require 'rails_helper'

describe 'Activity::show' do
  let(:academic) { create(:academic) }
  let!(:activity) { create(:activity) }

  before do
    login_as(academic, scope: :academic)
    visit academics_calendar_activity_path(activity.calendar, activity)
  end

  describe '#show' do
    context 'when shows the activity' do
      it 'shows the activity' do
        expect(page).to have_contents([activity.name, activity.deadline])
      end
    end
  end
end
