require 'rails_helper'

describe 'Orientation::activities', type: :feature, js: true do
  let!(:professor) { create(:professor_tcc_one) }
  let!(:calendar) { create(:current_calendar_tcc_one) }
  let!(:orientation) { create(:orientation, calendar: calendar) }
  let(:academic) { orientation.academic }
  let(:activities) { orientation.calendar.activities }
  let(:active_link) { tcc_one_professors_calendar_orientations_path(calendar) }

  before do
    login_as(professor, scope: :professor)
    visit tcc_one_professors_calendar_orientation_activities_path(calendar, orientation)
  end

  describe '#index' do
    context 'when shows all the orientation activities' do
      it 'shows all the activites' do
        activities.each do |activity|
          expect(page).to have_contents([activity.name,
                                         activity.base_activity_type.name,
                                         I18n.t("enums.tcc.#{activity.tcc}"),
                                         activity.deadline])
        end
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when show the activity by orientation' do
      let(:activity) { activities.first }

      let!(:academic_activity) do
        create(:academic_activity, academic: academic, activity: activity)
      end

      before do
        visit tcc_one_professors_calendar_orientation_activity_path(calendar, orientation, activity)
      end

      it 'shows the activity' do
        expect(page).to have_contents([activity.name,
                                       activity.base_activity_type.name,
                                       activity.deadline,
                                       I18n.t("enums.tcc.#{activity.tcc}"),
                                       complete_date(activity.created_at),
                                       complete_date(activity.updated_at),
                                       academic.name,
                                       academic_activity.title,
                                       academic_activity.summary])

        link_active = "#{link(active_link)}.active"

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url),
                                        link_active])
      end
    end
  end
end
