require 'rails_helper'

describe 'Supervision::activities', type: :feature, js: true do
  let!(:external_member) { create(:external_member) }
  let!(:orientation) { create(:current_orientation_tcc_one) }
  let(:academic) { orientation.academic }
  let(:activities) { orientation.calendar.activities }
  let(:active_link) { external_members_supervisions_tcc_one_path }

  before do
    orientation.external_member_supervisors << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_supervision_activities_path(orientation)
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
        visit external_members_supervision_activity_path(orientation, activity)
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
