require 'rails_helper'

describe 'Activity::destroy', type: :feature, js: true do
  let(:responsible) { create(:responsible) }
  let!(:activity) { create(:activity) }
  let(:resource_name) { Activity.model_name.human }

  before do
    login_as(responsible, scope: :professor)
    visit responsible_calendar_activities_path(activity.calendar)
  end

  describe '#destroy' do
    context 'when activity is destroyed' do
      it 'show success message' do
        within first('.destroy').click
        accept_alert
        expect(page).to have_flash(:success, text: flash_message('destroy.f', resource_name))
        expect(page).not_to have_content(activity.name)
      end
    end
  end
end
