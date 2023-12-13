require 'rails_helper'

describe 'Orientation::activities', type: :feature do
  let!(:professor) { create(:professor_tcc_one) }
  let(:orientation) { create(:current_orientation_tcc_two) }

  before do
    login_as(professor, scope: :professor)
    calendar = orientation.current_calendar
    visit tcc_one_professors_orientation_calendar_activities_path(orientation, calendar)
  end

  describe '#index' do
    context 'when shows all the orientation activities' do
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

    context 'when show the activity by orientation' do
      let(:activity) { orientation.current_calendar.activities.first }
      let!(:academic_activity) do
        create(:academic_activity, academic: orientation.academic, activity: activity)
      end

      before do
        calendar = orientation.current_calendar
        visit tcc_one_professors_orientation_calendar_activity_path(orientation,
                                                                    calendar, activity)
      end

      it 'shows the activity' do
        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       activity.deadline,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at),
                                       orientation.academic.name,
                                       academic_activity.title,
                                       academic_activity.summary])

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url)])
      end
    end
  end
end
