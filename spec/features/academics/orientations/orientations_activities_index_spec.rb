require 'rails_helper'

describe 'Orientation::activities index', :js do
  let!(:orientation) { create(:orientation, :current, :tcc_one) }
  let(:academic) { orientation.academic }
  let(:calendar) { orientation.current_calendar }
  let(:activities) { calendar.activities }
  let(:active_link) { academics_calendars_path }

  before do
    login_as(academic, scope: :academic)
    visit academics_calendar_orientation_activities_path(calendar, orientation)
  end

  it 'shows all the activities' do
    activities.each do |activity|
      expect(page).to have_link(activity.name,
                                href: academics_calendar_orientation_activity_path(
                                  calendar, orientation, activity
                                ))
      expect(page).to have_text(activity.base_activity_type.name)
      expect(page).to have_text(I18n.t("enums.tcc.#{activity.tcc}"))
      expect(page).to have_text(activity.deadline)
    end

    expect(page).to have_css("a[href='#{active_link}'].active")
  end
end
