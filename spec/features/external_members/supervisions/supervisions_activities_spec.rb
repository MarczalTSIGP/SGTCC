require 'rails_helper'

describe 'Supervision::activities', type: :feature do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:current_orientation_tcc_one) }
  let(:academic) { orientation.academic }
  let(:activities) { orientation.current_calendar.activities }
  let(:active_link) { external_members_supervisions_tcc_one_path }

  before do
    orientation.external_member_supervisors << external_member
    login_as(external_member, scope: :external_member)
  end

  describe '#index' do
    context 'when shows all the orientation activities' do
      before do
        visit external_members_supervision_calendar_activities_path(orientation,
                                                                    orientation.current_calendar)
      end

      it 'shows all the activites' do
        activities.each do |activity|
          expect(page).to have_link(activity.name,
                                    href: external_members_supervision_calendar_activity_path(
                                      orientation, orientation.current_calendar, activity
                                    ))
          expect(page).to have_content(activity.base_activity_type.name)
          expect(page).to have_content(I18n.t("enums.tcc.#{activity.tcc}"))
          expect(page).to have_content(activity.deadline)
        end
        expect(page).to have_selector("a[href='#{active_link}'].active")
      end
    end

    context 'when show the activity by orientation' do
      let!(:activity) { activities.first }
      let!(:academic_activity) do
        create(:academic_activity, academic: academic, activity: activity)
      end

      before do
        visit external_members_supervision_calendar_activity_path(orientation,
                                                                  orientation.current_calendar,
                                                                  activity)
      end

      it 'shows the activity' do
        expect(page).to have_content(activity.name)
        expect(page).to have_content(activity.base_activity_type.name)
        expect(page).to have_content(activity.deadline)
        expect(page).to have_content(I18n.t("enums.tcc.#{activity.tcc}"))
        expect(page).to have_content(complete_date(activity.created_at))
        expect(page).to have_content(complete_date(activity.updated_at))
        expect(page).to have_content(academic.name)
        expect(page).to have_content(academic_activity.title)
        expect(page).to have_content(academic_activity.summary)

        link_active = "#{link(active_link)}.active"

        expect(page).to have_selectors([link(academic_activity.pdf.url),
                                        link(academic_activity.complementary_files.url),
                                        link_active])
      end
    end
  end
end
