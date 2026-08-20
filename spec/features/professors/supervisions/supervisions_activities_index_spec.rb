require 'rails_helper'

describe 'Supervision::activities', :js do
  let!(:professor) { create(:professor) }
  let!(:orientation) { create(:orientation, :current, :tcc_one) }
  let(:calendar) { orientation.current_calendar }
  let(:activities) { calendar.activities }
  let(:active_link) { professors_supervisions_tcc_one_path }

  before do
    orientation.professor_supervisors << professor
    login_as(professor, scope: :professor)
    visit professors_supervision_calendar_activities_path(orientation, calendar)
  end

  describe '#index' do
    context 'when shows all the orientation activities' do
      it 'shows all the activites' do
        activities.each do |activity|
          expect(page).to have_link(activity.name,
                                    href: professors_supervision_calendar_activity_path(
                                      orientation, calendar, activity
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
