require 'rails_helper'

describe 'Supervision::activities index' do
  let(:external_member) { create(:external_member) }
  let(:orientation) { create(:current_orientation_tcc_one) }
  let(:activities) { orientation.current_calendar.activities }
  let(:active_link) { external_members_supervisions_tcc_one_path }

  before do
    orientation.external_member_supervisors << external_member
    login_as(external_member, scope: :external_member)
    visit external_members_supervision_calendar_activities_path(orientation,
                                                                orientation.current_calendar)
  end

  it 'shows all the activites' do
    activities.each do |activity|
      expect(page).to have_link(activity.name,
                                href: external_members_supervision_calendar_activity_path(
                                  orientation, orientation.current_calendar, activity
                                ))
      expect(page).to have_text(activity.base_activity_type.name)
      expect(page).to have_text(I18n.t("enums.tcc.#{activity.tcc}"))
      expect(page).to have_text(activity.deadline)
    end
    expect(page).to have_css("a[href='#{active_link}'].active")
  end
end
