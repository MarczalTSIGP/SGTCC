require 'rails_helper'

describe 'Orientation::activities', type: :feature, js: true do
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:academic) { orientation.academic }
  let(:calendar) { orientation.calendar }
  let(:activities) { orientation.calendar.activities }
  let(:active_link) { academics_calendars_path }

  before do
    login_as(academic, scope: :academic)
    visit academics_calendar_orientation_activities_path(calendar, orientation)
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
        visit academics_calendar_orientation_activity_path(calendar, orientation, activity)
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
                                       academic_activity.summary,
                                       academic_activity.pdf_identifier,
                                       academic_activity.complementary_files_identifier])

        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end
  end
end