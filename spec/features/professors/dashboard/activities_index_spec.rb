require 'rails_helper'

describe 'Activity::index', type: :feature, js: true do
  let!(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:academic) { orientation.academic }
  let(:calendar) { orientation.current_calendar }
  let(:activities) { calendar.activities }

  before do
    login_as(professor, scope: :professor)
    visit professors_root_path
  end

  describe '#index' do
    context 'when shows all activities with pending approvement' do
      it 'shows all the activities' do
        activities.each do |activity|
          next if activity.judgment

          expect(page).to have_link(activity.name,
                                    href: professors_orientation_calendar_activity_path(
                                      academic.orientations.last, activity.calendar, activity
                                    ))

          expect(page).to have_contents([activity.base_activity_type.name,
                                         academic.name,
                                         I18n.t("enums.tcc.#{activity.tcc}"),
                                         activity.deadline])
        end
      end
    end
  end
end
