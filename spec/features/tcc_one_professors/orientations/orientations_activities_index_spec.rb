require 'rails_helper'

describe 'Orientation::activities index' do
  let!(:professor) { create(:professor_tcc_one) }
  let(:orientation) { create(:current_orientation_tcc_two) }

  before do
    login_as(professor, scope: :professor)
    calendar = orientation.current_calendar
    visit tcc_one_professors_orientation_calendar_activities_path(orientation, calendar)
  end

  it 'shows all the activites' do
    orientation.current_calendar.activities.each do |activity|
      expect(page).to have_link(activity.name,
                                href: tcc_one_professors_orientation_calendar_activity_path(
                                  orientation, orientation.current_calendar, activity
                                ))
      expect(page).to have_contents([activity.base_activity_type.name,
                                     I18n.t("enums.tcc.#{activity.tcc}"),
                                     activity.deadline])
    end
  end
end
