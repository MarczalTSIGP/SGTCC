require 'rails_helper'

describe 'Orientation::activities', type: :feature, js: true do
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:academic) { orientation.academic }
  let(:calendar) { orientation.current_calendar }
  let(:activities) { calendar.activities }
  let(:active_link) { academics_calendars_path }

  before do
    login_as(academic, scope: :academic)
  end

  describe '#index' do
    context 'when shows all the orientation activities' do
      it 'shows all the activites' do
        visit academics_calendar_orientation_activities_path(calendar, orientation)

        activities.each do |activity|
          expect(page).to have_link(activity.name, href: academics_calendar_orientation_activity_path(calendar, orientation, activity))
          expect(page).to have_content(activity.base_activity_type.name)
          expect(page).to have_content(I18n.t("enums.tcc.#{activity.tcc}"))
          expect(page).to have_content(activity.deadline)
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
                                       academic_activity.summary])

        link_active = "#{link(active_link)}.active"

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url),
                                        link_active])
      end
    end
  end
end
