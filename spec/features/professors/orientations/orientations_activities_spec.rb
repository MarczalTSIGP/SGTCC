require 'rails_helper'

describe 'Orientation::activities', :js do
  let!(:orientation) { create(:orientation) }
  let(:professor) { orientation.advisor }
  let(:academic) { orientation.academic }
  let(:activities) { orientation.current_calendar.activities }
  let(:active_link) { professors_orientations_tcc_one_path }

  before do
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

    context 'when show the activity by orientation' do
      let(:activity) { activities.first }

      let!(:academic_activity) do
        create(:academic_activity, academic:, activity:)
      end

      before do
        visit professors_orientation_calendar_activity_path(orientation,
                                                            orientation.current_calendar,
                                                            activity)
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
