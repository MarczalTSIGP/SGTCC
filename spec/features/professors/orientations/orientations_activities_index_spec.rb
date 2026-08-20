require 'rails_helper'

describe 'Orientation::activities', :js do
  let!(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:activities) { orientation.current_calendar.activities }
  let(:active_link) { professors_orientations_tcc_one_path }

  before do
    create(:activity, :project, calendar: orientation.current_calendar)
    login_as(professor, scope: :professor)
    visit professors_orientation_calendar_activities_path(orientation, orientation.current_calendar)
  end

  describe '#index' do
    context 'when shows all the orientation activities' do
      it 'shows all the activites' do
        activities.each do |activity|
          expect(page).to have_link(activity.name,
                                    href: professors_orientation_calendar_activity_path(
                                      orientation, orientation.current_calendar, activity
                                    ))

          expect(page).to have_contents([activity.base_activity_type.name,
                                         I18n.t("enums.tcc.#{activity.tcc}"),
                                         activity.deadline])
        end
        expect(page).to have_css("a[href='#{active_link}'].active")
      end
    end
  end
end
